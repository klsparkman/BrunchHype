//
//  BrunchSpotTableViewCell.swift
//  BrunchHype
//
//  Created by Kelsey Sparkman on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

protocol BrunchSpotTableViewCellDelegate: class {
    func brunchSpotTierUpdated(_ sender: BrunchSpotTableViewCell)
}

class BrunchSpotTableViewCell: UITableViewCell {

    // Mark: - Outlets
    @IBOutlet weak var brunchSpotNameLabel: UILabel!
    @IBOutlet weak var brunchTierSegmentedController: UISegmentedControl!
    
    weak var delegate: BrunchSpotTableViewCellDelegate?
    
    func updateViews(withBrunchSpot brunchSpot: BrunchSpot) {
        brunchSpotNameLabel.text = brunchSpot.name
        
        switch brunchSpot.tier {
        case "S":
            brunchTierSegmentedController.selectedSegmentIndex = 0
            backgroundColor = .cyan
        case "A":
            brunchTierSegmentedController.selectedSegmentIndex = 1
            backgroundColor = .yellow
        case "Meh":
            brunchTierSegmentedController.selectedSegmentIndex = 2
            backgroundColor = .lightGray
        case "Unrated":
            brunchTierSegmentedController.selectedSegmentIndex = -1
            backgroundColor = .darkGray
        default:
            brunchTierSegmentedController.selectedSegmentIndex = -1
        }
    }
    
    @IBAction func tierChanged(_ sender: Any) {
        delegate?.brunchSpotTierUpdated(self)
    }
    
}
