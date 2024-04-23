//
//  Category+CoreDataProperties.swift
//  FlashcardApp
//
//  Created by Sadek on 19/04/2024.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var subCategory: NSSet?

}

// MARK: Generated accessors for subCategory
extension Category {

    @objc(addSubCategoryObject:)
    @NSManaged public func addToSubCategory(_ value: SubCategory)

    @objc(removeSubCategoryObject:)
    @NSManaged public func removeFromSubCategory(_ value: SubCategory)

    @objc(addSubCategory:)
    @NSManaged public func addToSubCategory(_ values: NSSet)

    @objc(removeSubCategory:)
    @NSManaged public func removeFromSubCategory(_ values: NSSet)

}

extension Category : Identifiable {

}
