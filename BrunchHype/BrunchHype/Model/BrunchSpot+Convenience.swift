//
//  BrunchSpot+Convenience.swift
//  BrunchHype
//
//  Created by Kelsey Sparkman on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

extension BrunchSpot {
    convenience init(name: String, tier: String = "Unrated", summary: String = "No summary added", context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.tier = tier
        self.summary = summary
    }
}
