//
//  Categories.swift
//  FlashcardApp
//
//  Created by Sadek on 21/02/2024.
//

import Foundation
class Category {
    var name: String
    var subCategories: [SubCategory]
    init(name: String) {
        self.name = name
        self.subCategories = []
    }
    
    func addSubCategory(_ subCategoryToAdd: SubCategory){
        self.subCategories.append(subCategoryToAdd)
    }
}
