//
//  DeckSelectorViewController.swift
//  FlashcardApp
//
//  Created by Sadek on 21/04/2024.
//

import UIKit
import CoreData

class DeckSelectorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var subCategoryTextField: UITextField!
    
    // MARK: - Properties
    var categoryPickerView = UIPickerView()
    var subCategoryPickerView = UIPickerView()
    var categories: [Category] = []
    var subcategories: [SubCategory] = []
    var selectedCategory: Category?
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerViews()
        fetchCategories()
        addTapGesture()
        categoryTextField.delegate = self
        subCategoryTextField.delegate = self
         // Set the initial background color and navigation styles
        self.view.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white

        
    }
    // MARK: - Setup Methods
    /// Configures the picker views for category and subcategory selection.
    func setupPickerViews() {
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        categoryTextField.inputView = categoryPickerView
        subCategoryPickerView.dataSource = self
        subCategoryPickerView.delegate = self
        subCategoryTextField.inputView = subCategoryPickerView
    }

      /// Adds a tap gesture to dismiss the picker when tapping outside.
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissPicker() {
        view.endEditing(true) // Dismiss the keyboard when the view is tapped
    }
    
    
     // MARK: - Fetching categories
    /// Fetches categories from the Core Data store to populate the picker.
    func fetchCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
            DispatchQueue.main.async {
                self.categoryPickerView.reloadAllComponents()
            }
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
      // MARK: - UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == categoryTextField {
            subcategories = []
            subCategoryTextField.text = ""
        } else if textField == subCategoryTextField && selectedCategory != nil {
            subcategories = Array(selectedCategory!.subCategory as? Set<SubCategory> ?? [])
            DispatchQueue.main.async {
                self.subCategoryPickerView.reloadAllComponents()
            }
        }
        return true
    }
    
    // MARK: - UIPickerView configuration
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView == categoryPickerView ? categories.count : subcategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView == categoryPickerView ? categories[row].name : subcategories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView {
            selectedCategory = categories[row]
            categoryTextField.text = selectedCategory?.name
            subCategoryTextField.becomeFirstResponder() // Move focus to subcategory after selection
        } else if pickerView == subCategoryPickerView {
            subCategoryTextField.text = subcategories[row].name
            subCategoryTextField.resignFirstResponder() // Dismiss picker after selection
        }
    }
    

    // MARK: - Navigation to Study Mode
    /// Initiates study mode based on selected category and subcategory.
    @IBAction func startStudyModePressed(_ sender: UIButton) {
        guard let selectedCategory = selectedCategory,
              let subCategoryText = subCategoryTextField.text,
              !subCategoryText.isEmpty,
              let selectedSubcategory = subcategories.first(where: { $0.name == subCategoryText }),
              let flashcards = selectedSubcategory.flashCard as? Set<FlashCard>,
              !flashcards.isEmpty else {
            let alert = UIAlertController(title: "No Flashcards Available", message: "Please select a subcategory with flashcards.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        // Navigate to the study mode view controller with the selected subcategory
        if let studyVC = storyboard?.instantiateViewController(identifier: "StudyModeViewController") as? StudyModeViewController {
            studyVC.studyModeBrain = StudyModeBrain(subcategory: selectedSubcategory)
            navigationController?.pushViewController(studyVC, animated: true)
        }
    }


}

// FIXME: UIpicker picks instantly
