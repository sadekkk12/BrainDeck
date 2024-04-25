//
//  SubCategoryViewController.swift
//  FlashcardApp
//
//  Created by Sadek on 19/04/2024.
//

import UIKit

class SubCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    var category: Category?
    var subcategories: [SubCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadFlashcards()
    }
    // MARK: - Configuration
    /// Configures table view properties and navbar aesthetics.
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.view.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
        tableView.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        title = category?.name ?? "Subcategories" // sets title as the chosen subcategorys name
    }
    /// Loads subcategories from the persistent container associated with the selected category.
    private func loadFlashcards() {
        if let subCategorySet = category?.subCategory as? Set<SubCategory> {
            subcategories = Array(subCategorySet)
        } else {
            subcategories = []
        }
        tableView.reloadData()
    }
    
    
  
    // MARK: - Actions
    /// Adds a new subcategory through an alert dialogue.
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Category", message: "Enter new Category", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [unowned alert] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                self.createSubCategory(name: name)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Create subcategory
    /// Creates a new subcategory and saves it to the context.
    private func createSubCategory(name: String) {
        let newSubCategory = SubCategory(context: context)
        newSubCategory.name = name
        category?.addToSubCategory(newSubCategory) // Use the generated accessor to add to the relationship set
        saveContext()
    }

     /// Saves any changes made to the context.
    private func saveContext() {
        do {
            try context.save()
            loadFlashcards()
        } catch {
            showError(message: "Unable to save category.")
        }
    }
    /// Displays an alert for errors encountered during data operations.
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

     /// Displays an alert for errors encountered during data operations.

     // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryCell", for: indexPath)
        cell.textLabel?.text = subcategories[indexPath.row].name
        return cell
    }


    // MARK: - Swipe Actions
    /// Configures swipe actions for editing and deleting subcategories.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.deleteSubCategory(at: indexPath)
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            self.showEditAlert(for: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .darkGray
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    // MARK: - Editing and Deleting Subcategories
    /// Deletes a subcategory from the context and updates the UI.
    private func deleteSubCategory(at indexPath: IndexPath) {
        context.delete(subcategories[indexPath.row])
        saveContext()
    }
     /// Opens an alert to edit an existing subcategory.
    private func showEditAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Category", message: "Edit your Category", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.subcategories[indexPath.row].name
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                self.updateSubCategory(at: indexPath, with: newName)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    /// Updates the name of a subcategory in the context and saves it.
    private func updateSubCategory(at indexPath: IndexPath, with newName: String) {
        let category = subcategories[indexPath.row]
        category.name = newName
        saveContext()
    }
    // MARK: - Navigation
    /// Handles navigation to the flashcards of the selected subcategory.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let flashCardVC = storyboard.instantiateViewController(withIdentifier: "FlashcardViewController") as? FlashcardViewController {
            flashCardVC.subCategory = subcategories[indexPath.row]
            navigationController?.pushViewController(flashCardVC, animated: true)
        }
    }
    
}


// FIXME: Title glitching
