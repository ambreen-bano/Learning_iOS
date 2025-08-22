//
//  NotesViewController.swift
//  CoreData_Learning
//
//  Created by Ambreen Bano on 20/08/25.
//

import Foundation
import UIKit
import CoreData

/*NSFetchedResultsController is use for update automatically table/collection view data.
 sortDescriptors is mandatory to set in NSFetchRequest. NSFetchedResultsController doesn't know where to insert new row [at bottom or at top or in middle]. So, we need to set sortDescriptor in NSFetchRequest. Then, on the basis of sortDescriptors, NSFetchedResultsController insert rows.
 
 Your FRC correctly detected the insert (from your background save → main context via automaticallyMergesChangesFromParent ).
 the table view or collection view will update automatically, whenever Core Data changes.
 
 Instead of manually re-fetching or tracking notes, we let Core Data handle updates. Then: Background saves auto-merge into main and Table view updates automatically (insert/delete/modify rows)
 
 We don't need to reloadTable manually after data changes. ONly need to implement NSFetchedResultsController Delegates to handle updates in data.
 
 We even don't need to create model struct for table data reloads. NSFetchedResultsController contain sections and all data objects
 */


class NotesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var addNoteBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var fetchResultController: NSFetchedResultsController<Note>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchResultController()
    }
    
    
    func setupFetchResultController() {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)] //Mandatory
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataModelStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController?.delegate = self
        try? fetchResultController?.performFetch()
    }
    
    
    func showAlertToAddNote() {
        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Add Note"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] alertAction in
            if let noteText = alert.textFields?.first?.text {
                self?.createNoteUsingBackgroundContext(noteText)
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
                self?.updateNoteUsingMainContext(note, noteText)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    
    @IBAction func addNoteTap(_ sender: Any) {
        showAlertToAddNote()
    }
}


//TableView DataSource Delegates
extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController?.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell {
            if let note = fetchResultController?.object(at: indexPath) {
                cell.noteTextLabel.text = note.noteText
                return cell
            }
        }
        return UITableViewCell()
    }
}

//TableView DataSource Delegates
extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let note = fetchResultController?.object(at: indexPath) {
            showAlertToUpdateNote(note)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let note = fetchResultController?.object(at: indexPath) {
                //The note objects displayed on UI from FRC belong to the main context. Deleting/editing them from main thread avoids the crash “cannot delete objects in other contexts”.
                CoreDataModelStack.shared.context.delete(note)
                try? CoreDataModelStack.shared.context.save()
            }
        }
    }
    
}


//NSFechResultController Delegates
extension NotesViewController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("didChange")
        switch type {
        case .insert:
            guard let nip = newIndexPath else { return }
            tableView.insertRows(at: [nip], with: .automatic)
        case .delete:
            guard let ip = indexPath else { return }
            tableView.deleteRows(at: [ip], with: .automatic)
        case .update:
            guard let ip = indexPath else { return }
            tableView.reloadRows(at: [ip], with: .automatic)
        case .move:
            guard let ip = indexPath, let nip = newIndexPath else { return }
            tableView.moveRow(at: ip, to: nip)
        default: break
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
    
    func updateNoteUsingMainContext(_ note: Note, _ noteText: String) {
        //The note objects displayed on UI from FRC belong to the main context. Deleting/editing them from main thread avoids the crash “cannot delete objects in other contexts”.
        note.noteText = noteText
        try? CoreDataModelStack.shared.context.save()
    }
}
