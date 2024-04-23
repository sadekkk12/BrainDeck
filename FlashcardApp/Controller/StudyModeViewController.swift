    //
    //  StudyModeViewController.swift
    //  FlashcardApp
    //
    //  Created by Sadek on 21/04/2024.
    //

    import UIKit

    class StudyModeViewController: UIViewController {
        
        @IBOutlet weak var frontCardView: UIView!
        @IBOutlet weak var backCardView: UIView!
        @IBOutlet weak var frontCardLabel: UILabel!
        @IBOutlet weak var backCardLabel: UILabel!   
        
        var studyModeBrain: StudyModeBrain?
        var isFlipped: Bool = false
        
        override func viewDidLoad() {
              super.viewDidLoad()
                setupCardViews()
              setupGestureRecognizers()
              updateCardDisplay()  // Initial display update
              navigationController?.navigationBar.tintColor = UIColor.white
            self.view.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
            
            
          }
        
          
          func setupCardViews() {
              // Initially set the back card to be hidden
              backCardView.isHidden = true
              frontCardView.isHidden = false
          }

          func setupGestureRecognizers() {
              let tapGestureFront = UITapGestureRecognizer(target: self, action: #selector(flipCard))
              frontCardView.isUserInteractionEnabled = true
              frontCardView.addGestureRecognizer(tapGestureFront)

              let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(flipCard))
              backCardView.isUserInteractionEnabled = true
              backCardView.addGestureRecognizer(tapGestureBack)
          }

          @IBAction func nextPressed(_ sender: UIButton) {
              studyModeBrain?.goToNextFlashcard()
              updateCardDisplay()
              resetCardViews()
          }
          
          @IBAction func backPressed(_ sender: UIButton) {
              studyModeBrain?.goToPreviousFlashcard()
              updateCardDisplay()
              resetCardViews()
          }

        @objc func flipCard() {
            let fromView = isFlipped ? backCardView : frontCardView
            let toView = isFlipped ? frontCardView : backCardView

            // Set the animation options for flipping
            let options: UIView.AnimationOptions = isFlipped ? [.transitionFlipFromLeft, .showHideTransitionViews] : [.transitionFlipFromRight, .showHideTransitionViews]

            // Perform the flip animation
            UIView.transition(with: toView!, duration: 0.3, options: options, animations: {
                fromView!.isHidden = true
                toView!.isHidden = false
            }) { finished in
                self.isFlipped = !self.isFlipped
            }
        }


          func resetCardViews() {
              // Ensure that the front card view is visible and the back is hidden after updating cards
              if isFlipped {
                  flipCard() // If flipped, flip back to front
              }
          }
          
          func updateCardDisplay() {
              if let flashcard = studyModeBrain?.getCurrentCard() {
                  frontCardLabel.text = flashcard.question
                  backCardLabel.text = flashcard.answer
              }
          }
      }
