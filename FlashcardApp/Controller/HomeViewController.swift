//
//  ViewController.swift
//  FlashcardApp
//
//  Created by Sadek on 20/02/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        
    }
    // MARK: - Configuration
    /// Setting up title, navbar aesthetic
    func Configuration(){
    self.navigationItem.title = ""
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    titleLabel.text = "" // Hides Title
    NameAnimation()
    }
    /// BrainDeck title writing animation
    func NameAnimation() {
    let titleText = "BrainDeck"
    var charIndex = 0.0
     for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.075 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    // MARK: - Navigation IBActions
    @IBAction func flashCardsPressed(_ sender: UIButton) {
    }
    
    @IBAction func studyModePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func learnMorePressed(_ sender: UIButton) {
      
    }
    // TODO: Implement HOW TO button functionality and create view
}

