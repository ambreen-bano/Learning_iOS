//
//  NotesViewController.swift
//  CoreData_Learning
//
//  Created by Ambreen Bano on 20/08/25.
//

import Foundation
import UIKit
import CoreData

class NotesViewController: UIViewController {
    @IBOutlet weak var addNoteBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readNotes()
        NotificationCenter.default.addObserver(self, selector: #selector(dataModified), name: .NSManagedObjectContextDidSave , object: nil)
    }
    
    @objc func dataModified() {
        /*
         1. When we are using only viewContext which is main thread then no issues will occure related to thread if CRUD is small.
         2. If we are using only BackgroundContext or mixed of BackgroundContext/viewContext for operations in the code then need to use Notification - NSManagedObjectContextDidSave.
         3. This Notification will call after every BackgroundContext/viewContext save method called.
         4. Always remember we will receive this notification NSManagedObjectContextDidSave on the SAME thread from save was called. So if we called bgContext.save(), the notification is delivered on that background queue.
         5. So better to switch on Main thread for UI updation after receiving this event.
         6. Instance of the Entity created using BG context can not be directly use for UI update on the Main thread. So, we need to read Entity from viewContext of main thread before using it to update UI.
         */
        readNotes()
    }
    
    func showAlertToAddNote() {
        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Add Note"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] alertAction in
            if let noteText = alert.textFields?.first?.text {
               // self?.createNote(noteText) //A. Using Main Thread
                self?.createNoteUsingBackgroundContext(noteText) //B. Using BG thread
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func showAlertToUpdateNote(_ note: Note) {
        let alert = UIAlertController(title: "Update Note", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Update Note"
        }
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak self] alertAction in
            if let noteText = alert.textFields?.first?.text {
                self?.updateNote(note, text: noteText)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func addNoteTap(_ sender: Any) {
        showAlertToAddNote()
    }
}



extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell {
            if indexPath.row < notes.count {
                cell.noteTextLabel.text = notes[indexPath.item].noteText
                return cell
            }
        }
        return UITableViewCell()
    }
}



extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.item]
        showAlertToUpdateNote(note)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.item]
            deleteNote(note)
        }
    }
}



//Core Data Read create update delete
extension NotesViewController {
    func readNotes() {
        do {
            //<Note> is fetch request data return type
            let fetchRequest: NSFetchRequest<Note> = NSFetchRequest<Note>(entityName: "Note")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)] //Sorting
            fetchRequest.fetchLimit = 3 //limit on fetched items
            let date = Date().addingTimeInterval(-5.0)
            fetchRequest.predicate = NSPredicate(format: "createdDate < %@", date as CVarArg) //Filter on fetched items
            
            notes = try CoreDataModelStack.shared.context.fetch(fetchRequest)
            print("Fetching success...")
            if Thread.isMainThread {
                //If notification received on Main Thread via viewContext
                self.tableView.reloadData()
            } else {
                //If notification received on BG Thread via BackgroundContext
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        } catch {
            print("Fetching failed with error : \(error)")
        }
    }
    
    func createNote(_ noteText: String) {
        do {
            if let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: CoreDataModelStack.shared.context) as? Note {
                note.noteText = noteText
                note.createdDate = Date()
                
                if CoreDataModelStack.shared.context.hasChanges {
                    try CoreDataModelStack.shared.context.save() //always save after any changes
                    print("Note Created...")
                }
            }
        } catch {
            print("Failed to create Note : \(error)")
        }
    }
    
    func updateNote(_ note: Note, text: String) {
        do {
            note.noteText = text
            try CoreDataModelStack.shared.context.save()
            print("Note updated...")
        } catch {
            print("Error in updating Note : \(error)")
        }
    }
    
    func deleteNote(_ note: Note) {
        do {
            CoreDataModelStack.shared.context.delete(note)
            try CoreDataModelStack.shared.context.save() //always save after any changes
            print("Note deleted...")
        } catch {
            print("Error in Note deletion : \(error)")
        }
    }
}



/* Core Data, Background thread context */
extension NotesViewController {
    func createNoteUsingBackgroundContext(_ noteText: String) {
        CoreDataModelStack.shared.BackgroundContext.perform {
            do {
                if let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: CoreDataModelStack.shared.BackgroundContext) as? Note {
                    note.noteText = noteText
                    note.createdDate = Date()
                    
                    if CoreDataModelStack.shared.BackgroundContext.hasChanges {
                        try CoreDataModelStack.shared.BackgroundContext.save() //always save after any changes
                        print("Note Created using BG thread...")
                    }
                }
            } catch {
                print("Failed to create Note using BG thread : \(error)")
            }
        }
    }
}
