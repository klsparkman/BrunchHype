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
