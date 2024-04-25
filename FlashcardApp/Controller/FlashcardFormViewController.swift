//
//  FlashcardFormViewController.swift
//  FlashcardApp
//
//  Created by Sadek on 20/04/2024.
//

import UIKit

class FlashcardFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextView: UITextView!
    
    // MARK: - Properties
    var flashcard: FlashCard? // Used for editing
    var subCategory: SubCategory? // Reference to the parent SubCategory
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadFlashcardDetails()
    }
    
    //MARK: - Setup 
    /// Configures initial view settings and delegates.
    private func setup() {
        title = flashcard == nil ? "New Flashcard" : "Edit Flashcard"
        navigationController?.navigationBar.tintColor = UIColor.white
        nameTextField.delegate = self
        questionTextField.delegate = self
        answerTextView.delegate = self
        self.view.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
        
    }

    /// Loads details into the form if editing an existing flashcard.
    private func loadFlashcardDetails() {
        nameTextField.text = flashcard?.name
        questionTextField.text = flashcard?.question
        answerTextView.text = flashcard?.answer
    }
    
   
    // MARK: - Saving Flashcard
    /// Creates or updates the flashcard in the Core Data context.
     func saveFlashcard() {
        if flashcard == nil {
            flashcard = FlashCard(context: context)
            flashcard?.subCategory = subCategory
        }

        flashcard?.name = nameTextField.text ?? ""
        flashcard?.question = questionTextField.text ?? ""
        flashcard?.answer = answerTextView.text ?? ""

        do {
            try context.save()
            dismiss(animated: true, completion: onSave)
            navigationController?.popViewController(animated: true)
        } catch {
            showError(message: "Failed to save flashcard: \(error.localizedDescription)")
        }
    }

    var onSave: (() -> Void)?
    /// Saves the flashcard when the save button is pressed.
     @IBAction func savePressed(_ sender: UIButton) {
        saveFlashcard()
    }
    
    /// Displays an alert for errors encountered during save operations.
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    // MARK: UITextFieldDelegate & UITextViewDelegate
    /// Dismisses the keyboard when the return key is pressed on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // This dismisses the keyboard for the active text field
        return true
    }

     /// Ensures text fields are not left empty during editing.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
     /// Prevents 'return' (newline) key from being added in the text view to maintain single paragraph input.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {  // Check for the 'Return' key (newline)
            textView.resignFirstResponder()  // Dismiss the keyboard
            return false  // Do not allow return character to be inserted
        }
        return true  // Allow other characters
    }


    
    
    
    
}




