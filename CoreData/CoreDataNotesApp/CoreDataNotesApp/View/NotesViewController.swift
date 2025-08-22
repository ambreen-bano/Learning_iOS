//
//  NotesViewController.swift
//  CoreData_Learning
//
//  Created by Ambreen Bano on 20/08/25.
//

import Foundation
import UIKit
import CoreData

/* Thread Confinement Rule---
 A managed object (NSManagedObject) is tied to the context (ViewContext or newBackgroundContext thread) it was fetched from. If we fetch on a background context, those objects belong to that background context. And if we access them on the viewContext thread (to update UI) can cause -Crashes (NSManagedObjectContext concurrency violation) */

struct NotesModel {
    var noteText: String
    var createdDate: Date
}


class NotesViewController: UIViewController {
    @IBOutlet weak var addNoteBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var notes: [Note] = [] {
        didSet {
            //Whenever Entity Notes is set we will update our notes display UI model
            convertEntityModelIntoUIFriendlyModel()
        }
    }
    
    var notesModel: [NotesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readNotes()
        NotificationCenter.default.addObserver(self, selector: #selector(dataModified), name: .NSManagedObjectContextDidSave , object: nil)
    }
    
    @objc func dataModified() {
        /*
         1. When we are using only viewContext (main thread). Then, no issues will occure related to thread if CRUD is small. (Not good for large data processiong, it will block UI)
         2. If we are using only BackgroundContext(Background Thread) or mixed of BackgroundContext/viewContext for operations in the code then need to use Notification - NSManagedObjectContextDidSave.
         3. This Notification will call after every BackgroundContext/viewContext save method called.
         4. Always remember we will receive this notification NSManagedObjectContextDidSave on the SAME thread from save was called. So if we called bgContext.save(), the notification is delivered on that background queue.
         5. So better to switch on Main thread for UI updation after receiving this event.
         6. Instance of the Entity created using BG context can not be directly use for UI update on the Main thread. So, we need below options to use before using it to update UI.
         
         NOTE : we can not directly use objects fetched in a background context on the UI loading. So use below OPTIONS -
         1. If the Object created on bg thread. Then, we can not directly use it to show on UI(main thread). So, we need to fetch on main thread to show it directly on UI (main thread) [Not Good]
         2. If the Object created on bg thread. Then, we can not directly use it to show on UI(main thread). So, we can fetch on background thread and convert object model into UI friendly own model and then switch to main thread to show UI friendly own model on UI (main thread)
         3. If the Object created on bg thread. Then, we can not directly use it to show on UI(main thread). So, we can get "id = object.objectID" and then on main thread we can get "uiFriendlyObject = viewContext.object(with: id)" and shown on UI. objectID is thread safe and can be use on different contexts.
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
                // self?.createNoteUsingMainContext(noteText) //A. Using Main Thread
                self?.createNoteUsingBackgroundContext(noteText) //B. Using BG thread (to avoid UI blocking)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func showAlertToUpdateNote(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Update Note", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Update Note"
        }
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak self] alertAction in
            if let noteText = alert.textFields?.first?.text {
                self?.updateNoteAt(indexPath, text: noteText)
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
        return notesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell {
            if indexPath.row < notesModel.count {
                cell.noteTextLabel.text = notesModel[indexPath.item].noteText
                return cell
            }
        }
        return UITableViewCell()
    }
}



extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlertToUpdateNote(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteAt(indexPath)
        }
    }
}



//Core Data Read create update delete
extension NotesViewController {
    
    private func convertEntityModelIntoUIFriendlyModel() {
        //Convert Entity Model into UI friendly model
        notesModel = notes.map { note in
            NotesModel(noteText: note.noteText ?? "Error - No Note Found", createdDate: note.createdDate ?? Date())
        }
    }
    
    
    func readNotesOnBGThread() {
        do {
            //<Note> is fetch request data return type
            let fetchRequest: NSFetchRequest<Note> = NSFetchRequest<Note>(entityName: "Note")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)] //Sorting
            //fetchRequest.fetchLimit = 3 //limit on fetched items
            //let date = Date().addingTimeInterval(-5.0)
            //fetchRequest.predicate = NSPredicate(format: "createdDate < %@", date as CVarArg) //Filter on fetched items
            
            notes = try CoreDataModelStack.shared.BackgroundContext.fetch(fetchRequest)
            print("Fetching success...")
            
            //Convert Entity Model into UI friendly model from notes Entity model didSet { }
            
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
    
    func readNotes() {
        do {
            //<Note> is fetch request data return type
            let fetchRequest: NSFetchRequest<Note> = NSFetchRequest<Note>(entityName: "Note")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)] //Sorting
            //fetchRequest.fetchLimit = 3 //limit on fetched items
            //let date = Date().addingTimeInterval(-5.0)
            //fetchRequest.predicate = NSPredicate(format: "createdDate < %@", date as CVarArg) //Filter on fetched items
            
            notes = try CoreDataModelStack.shared.context.fetch(fetchRequest)
            print("Fetching success...")
            
            //Convert Entity Model into UI friendly model from notes Entity model didSet { }
            
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
    
    func createNoteUsingMainContext(_ noteText: String) {
        do {
            //This method creates a new managed object (row in the database) for the given entity name.
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
    
    func updateNoteAt(_ indexPath: IndexPath, text: String) {
        do {
            notes[indexPath.item].noteText = text
            try CoreDataModelStack.shared.context.save()
            print("Note updated...")
        } catch {
            print("Error in updating Note : \(error)")
        }
    }
    
    func deleteNoteAt(_ indexPath: IndexPath) {
        do {
            let note = notes[indexPath.item]
            CoreDataModelStack.shared.context.delete(note)
            try CoreDataModelStack.shared.context.save() //Always save after any changes
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

/* Create Note OnBackgroundContext and update on UI using ObjectID. Using ObjectID it gives fault object, right now this code method not working properly because of fault object not able to display on UI. Need to find the bug causes falut object */
extension NotesViewController {
    func createNoteOnBackgroundContextUsingObjectID(_ noteText: String) {
        CoreDataModelStack.shared.BackgroundContext.perform {
            do {
                if let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: CoreDataModelStack.shared.BackgroundContext) as? Note {
                    note.noteText = noteText
                    note.createdDate = Date()
                    let id = note.objectID //Thread Safe, can use on different context
                    if CoreDataModelStack.shared.BackgroundContext.hasChanges {
                        try CoreDataModelStack.shared.BackgroundContext.save() //Always save after any changes
                        print("Note Created using BG thread...")
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        //Using "id" provides object compatible to main thread, so object created on bg thread we can use on another thread(main thread)
                        //Ensuring the object from the background context is fully usable on the main thread by setting context.automaticallyMergesChangesFromParent = true
                        if let note = CoreDataModelStack.shared.context.object(with: id) as? Note {
                            if let notes = self?.notes, notes.count > 0 {
                                self?.notes.append(note)
                            } else {
                                self?.notes = [note]
                            }
                            self?.tableView.reloadData() //not updating UI, BUG because of fault note object
                            print("Table updated with new note")
                        }
                    }
                }
            } catch {
                print("Failed to create Note using BG thread : \(error)")
            }
        }
    }
}
