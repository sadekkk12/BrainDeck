//
//  SubCategories.swift
//  FlashcardApp
//
//  Created by Sadek on 21/02/2024.
//

import Foundation
class SubCategory: Category {
    var flashCard: [FlashCard]
    
    override init(name: String) {
        self.flashCard = []
        super.init(name: name)
    }
    
    func addFlashCard(_ cardToAdd: FlashCard){
        self.flashCard.append(cardToAdd)
        
    }
}
