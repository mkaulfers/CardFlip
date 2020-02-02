//
//  HighScore_CD+CoreDataProperties.swift
//  CardFlip
//
//  Created by Matthew Kaulfers on 2/2/20.
//  Copyright © 2020 Matthew Kaulfers. All rights reserved.
//
//

import Foundation
import CoreData


extension TotalHighScores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TotalHighScores> {
        return NSFetchRequest<TotalHighScores>(entityName: "TotalHighScores")
    }

    @NSManaged public var playerName_CD: String?
    @NSManaged public var timeCompleted_CD: String?
    @NSManaged public var totalMatches_CD: Int16
    @NSManaged public var totalAttempts_CD: Int16

}
