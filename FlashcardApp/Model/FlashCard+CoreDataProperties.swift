//
//  FlashCard+CoreDataProperties.swift
//  FlashcardApp
//
//  Created by Sadek on 19/04/2024.
//
//

import Foundation
import CoreData


extension FlashCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlashCard> {
        return NSFetchRequest<FlashCard>(entityName: "FlashCard")
    }

    @NSManaged public var answer: String?
    @NSManaged public var name: String?
    @NSManaged public var question: String?
    @NSManaged public var subCategory: SubCategory?

}

extension FlashCard : Identifiable {

}
