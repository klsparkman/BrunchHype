//
//  BrunchSpotController.swift
//  BrunchHype
//
//  Created by Kelsey Sparkman on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class BrunchSpotController {
    
    // Mark: - Properties
    static let shared = BrunchSpotController()
        
    // Mark: - Fetched Results
    let fetchResultsController: NSFetchedResultsController<BrunchSpot>
    
    init() {
        let request: NSFetchRequest<BrunchSpot> = BrunchSpot.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "tier", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        let resultsController: NSFetchedResultsController<BrunchSpot> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "tier", cacheName: nil)
        fetchResultsController = resultsController
        do {
           try fetchResultsController.performFetch()
        } catch {
            print("Could not perform the fetch \(error.localizedDescription)")
        }
    }
    
    // Mark: - CRUD functions
    func create(brunchSpotWith name: String) {
        BrunchSpot(name: name)
        saveToPersistentStore()
    }
    
    func update(brunchSpot: BrunchSpot, name: String, tier: String, summary: String) {
        brunchSpot.name = name
        brunchSpot.tier = tier
        brunchSpot.summary = summary
        saveToPersistentStore()
    }
    
    func remove(brunchSpot: BrunchSpot) {
        CoreDataStack.context.delete(brunchSpot)
        saveToPersistentStore()
    }
    
    // Mark: - Save to Persistent Store
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Context, item not saved \(error.localizedDescription)")
        }
    }
}//End of Class
