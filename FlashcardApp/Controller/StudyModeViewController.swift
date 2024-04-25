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
              setup()
              setupGestureRecognizers()
              updateCardDisplay()  // Initial display update
            
          }
        
        // MARK: - Configuration
        /// Cards & navbar setup
        func setup() {
              // Configures the initial state of card views and hides the back card.
              backCardView.isHidden = true
              frontCardView.isHidden = false
              // navbar & background aesthetics
              navigationController?.navigationBar.tintColor = UIColor.white
              self.view.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
          }
        /// Adds gesture recognizers to both card views to enable flipping.
        func setupGestureRecognizers() {
              let tapGestureFront = UITapGestureRecognizer(target: self, action: #selector(flipCard))
              frontCardView.isUserInteractionEnabled = true
              frontCardView.addGestureRecognizer(tapGestureFront)

              let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(flipCard))
              backCardView.isUserInteractionEnabled = true
              backCardView.addGestureRecognizer(tapGestureBack)
          }

        // MARK: - Navigation Actions
        /// Moves to the next flashcard in the deck.
        @IBAction func nextPressed(_ sender: UIButton) {
              studyModeBrain?.goToNextFlashcard()
              updateCardDisplay()
              resetCardViews()
          }
        /// Returns to the previous flashcard in the deck.
        @IBAction func backPressed(_ sender: UIButton) {
              studyModeBrain?.goToPreviousFlashcard()
              updateCardDisplay()
              resetCardViews()
          }
        /// Resets the view state of the card views after changing cards.
        func resetCardViews() {
            // Ensure that the front card view is visible and the back is hidden after updating cards
            if isFlipped {
            flipCard() // If flipped, flip back to front
            }
          }

        /// Updates card labels with data from `studyModeBrain`.
        func updateCardDisplay() {
        if let flashcard = studyModeBrain?.getCurrentCard() {
            frontCardLabel.text = flashcard.question
            backCardLabel.text = flashcard.answer
            }
          }

        // MARK: - Actions
        /// Handles the flip animation between the front and back card views.
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
        
      }

    // TODO: Add a reset button
    // TODO: add a tracking system of current / total cards
    // TODO: point system or similar/feedback
    // FIXME: flips card when going to the next card from the backview of the previous
