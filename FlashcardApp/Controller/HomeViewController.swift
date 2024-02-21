//
//  ViewController.swift
//  FlashcardApp
//
//  Created by Sadek on 20/02/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Testing Catgory and SubCategory creation
        let mainCategory = Category(name: "Languages")
        let mainCategory2 = Category(name: "Coding")
        let subCategroy = SubCategory(name: "Spanish")
        let subCategory2 = SubCategory(name: "English")
        mainCategory.addSubCategory(subCategroy)
        mainCategory.addSubCategory(subCategory2)
       // for subcategory in mainCategory.subCategories {
         //   print(subcategory.name) }
        
       // print(mainCategory.subCategories.count)

        //Testing Flashcard creation
        let codingFlashCard = FlashCard(question: "whats 2+2?", answer: "21")
       // print("the answer this question: \(flashcard.question) IS \(flashcard.answer)")
        
        //Testing all
        subCategroy.addFlashCard(codingFlashCard)
        let categories = [mainCategory, mainCategory2]
        for category in categories {
            print("Category: \(category.name)")
            if category.subCategories.isEmpty {
                print("  No subCategories for \(category.name)")
            } else {
                for subcategory in category.subCategories {
                    // Start by printing the subcategory name directly
                    print("  SubCategory: \(subcategory.name) has the following FlashCards:")
                    if subcategory.flashCard.isEmpty {
                        print("    No flashcards")
                    } else {
                        // Directly iterate through flashcards and print them
                        for flashcard in subcategory.flashCard {
                            print(" Question: \"\(flashcard.question)\" - Answer: \"\(flashcard.answer)\"")
                        }
                    }
                }
            }
        }

        
        
    }
    
    @IBAction func flashCardsPressed(_ sender: UIButton) {
    }
    
    @IBAction func studyModePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func learnMorePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLearnMore", sender: self)
    }
    //TODO Redo layout constraints
    //TODO refactor Stacks and improve visually
    //TODO make custom color scheme for dark and light mode text
    // get 1x, 2x and 3x for background image. Change image names and packages
    
    

}

