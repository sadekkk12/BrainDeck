//
//  SubCategory+CoreDataProperties.swift
//  FlashcardApp
//
//  Created by Sadek on 19/04/2024.
//
//

import Foundation
import CoreData


extension SubCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubCategory> {
        return NSFetchRequest<SubCategory>(entityName: "SubCategory")
    }

    @NSManaged public var name: String?
    @NSManaged public var category: Category?
    @NSManaged public var flashCard: NSSet?

}

// MARK: Generated accessors for flashCard
extension SubCategory {

    @objc(addFlashCardObject:)
    @NSManaged public func addToFlashCard(_ value: FlashCard)

    @objc(removeFlashCardObject:)
    @NSManaged public func removeFromFlashCard(_ value: FlashCard)

    @objc(addFlashCard:)
    @NSManaged public func addToFlashCard(_ values: NSSet)

    @objc(removeFlashCard:)
    @NSManaged public func removeFromFlashCard(_ values: NSSet)

}

extension SubCategory : Identifiable {

}
