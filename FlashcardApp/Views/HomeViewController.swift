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
        // Do any additional setup after loading the view.
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
    // get 1x, 2x and 3x for background image
    
    

}

