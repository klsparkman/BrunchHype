//
//  BrunchSpotListTableViewController.swift
//  BrunchHype
//
//  Created by Kelsey Sparkman on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit
import CoreData

class BrunchSpotListTableViewController: UITableViewController {
        
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        BrunchSpotController.shared.fetchResultsController.delegate = self
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        BrunchSpotController.shared.fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // logic for "complete" and "incomplete" headers
        var name = ""
        switch BrunchSpotController.shared.fetchResultsController.sections?[section].name{
            case "S":
                name = "That good good"
            case "A":
                name = "Preety okay"
            case "Meh":
                name = "Only if they have mamosas"
            case "Unrated":
                name = "Unrated"
            default:
                name = "idk"
        }
        return name
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { // sets height for header
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BrunchSpotController.shared.fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "brunchSpotCell", for: indexPath) as? BrunchSpotTableViewCell else {return UITableViewCell()}
        let brunchSpot = BrunchSpotController.shared.fetchResultsController.object(at: indexPath)
        cell.updateViews(withBrunchSpot: brunchSpot)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let brunchSpot = BrunchSpotController.shared.fetchResultsController.object(at: indexPath)
            BrunchSpotController.shared.remove(brunchSpot: brunchSpot)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // Mark: - Helper Methods
    func presentAddBrunchSpotAlert() {
        let alertController = UIAlertController(title: "Add a Brunch Spot", message: "Doesn't even need to be good", preferredStyle: .alert)
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "What's your brunch spot's name?"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alertController.textFields?[0].text else {return}
            BrunchSpotController.shared.create(brunchSpotWith: name)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    // Mark: - Actions
    @IBAction func addBrunchSpotButtonTapped(_ sender: Any) {
        presentAddBrunchSpotAlert()
    }
}

extension BrunchSpotListTableViewController: BrunchSpotTableViewCellDelegate {
    func brunchSpotTierUpdated(_ sender: BrunchSpotTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let brunchSpot = BrunchSpotController.shared.fetchResultsController.object(at: indexPath)
        // Update the Model
        var tier = ""
        switch sender.brunchTierSegmentedController.selectedSegmentIndex {
        case 0:
            tier = "S"
        case 1:
            tier = "A"
        case 2:
            tier = "Meh"
        case -1:
            tier = "Unrated"
        default:
            tier = "Unrated"
        }
        
        BrunchSpotController.shared.changeTier(for: brunchSpot, with: tier)
        
        //update the cell
        sender.updateViews(withBrunchSpot: brunchSpot)
    }
}//End of Extension

extension BrunchSpotListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    //sets behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .delete:
            guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    //additional behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
}
