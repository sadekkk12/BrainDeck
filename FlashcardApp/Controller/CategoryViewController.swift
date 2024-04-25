//
//  CategoryViewController.swift
//  FlashcardApp
//
//  Created by Sadek on 23/02/2024.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var categories = [Category]()
    private let cellIdentifier = "CategoryCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadCategories()
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
        title = "Category"
    }
    
     /// Loads categories from the persistent container and updates the table view.
    private func loadCategories() {
        do {
            categories = try context.fetch(Category.fetchRequest())
            tableView.reloadData()
        } catch {
            showError(message: "Unable to fetch categories.")
        }
    }
    
   // MARK: - Error Handling
   /// Displays an error alert with a custom message.
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Category creation
    /// Handles user action for adding a new category.
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Category", message: "Enter new Category", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [unowned alert] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                self.createCategory(name: name)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }    
    /// Creates a new category and saves it to the context.
    private func createCategory(name: String) {
        let newCategory = Category(context: context)
        newCategory.name = name
        saveContext()
    }
     /// Saves any changes to the persistent context.
    private func saveContext() {
        do {
            try context.save()
            loadCategories()
        } catch {
            showError(message: "Unable to save category.")
        }
    }

    // Mark: - Setting up TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

    // MARK: - UITableView Swipe Actions
    /// Configures swipe actions for editing and deleting categories.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.deleteCategory(at: indexPath)
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

    private func deleteCategory(at indexPath: IndexPath) {
        context.delete(categories[indexPath.row])
        saveContext()
    }

    private func showEditAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Category", message: "Edit your Category", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.categories[indexPath.row].name
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                self.updateCategory(at: indexPath, with: newName)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func updateCategory(at indexPath: IndexPath, with newName: String) {
        let category = categories[indexPath.row]
        category.name = newName
        saveContext()
    }
    
    // MARK: - Navigation
    /// Handles navigation to the subcategories of the selected category.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) 
        if let subCategoryVC = storyboard.instantiateViewController(withIdentifier: "SubCategoryViewController") as? SubCategoryViewController {
            subCategoryVC.category = categories[indexPath.row]
            navigationController?.pushViewController(subCategoryVC, animated: true)
        }
    }

}

// FIXME: Title glitching