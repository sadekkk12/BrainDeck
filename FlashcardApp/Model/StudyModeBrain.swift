//
//  StudyModeBrain.swift
//  FlashcardApp
//
//  Created by Sadek on 21/02/2024.
//

import CoreData

struct StudyModeBrain {
    private var flashcardIndex = 0
    private var flashcards: [FlashCard] = []
    
    init(subcategory: SubCategory) {
        loadFlashcards(for: subcategory)
    }
    
    mutating func loadFlashcards(for subcategory: SubCategory) {
        if let cards = subcategory.flashCard?.allObjects as? [FlashCard] {
            flashcards = cards.shuffled()  // Assuming you may want to shuffle the cards
        }
    }
    
    func getCurrentCard () -> FlashCard? {
        guard !flashcards.isEmpty else { return nil }
        return flashcards[flashcardIndex]
    }
    
    mutating func goToNextFlashcard() {
        if flashcardIndex + 1 < flashcards.count {
            flashcardIndex += 1
        } else {
            flashcardIndex = 0  // Optionally restart or handle completion
        }
    }

    mutating func goToPreviousFlashcard() {
        if flashcardIndex > 0 {
            flashcardIndex -= 1
        } else {
            flashcardIndex = flashcards.count - 1  // Optionally loop around
        }
    }
}
