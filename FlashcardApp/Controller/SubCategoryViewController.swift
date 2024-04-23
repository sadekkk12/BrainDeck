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
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.view.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
            
            tableView.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
            
            navigationController?.navigationBar.tintColor = UIColor.white

            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        title = category?.name ?? "Subcategories"
    }

    private func loadFlashcards() {
        if let subCategorySet = category?.subCategory as? Set<SubCategory> {
            subcategories = Array(subCategorySet)
        } else {
            subcategories = []
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryCell", for: indexPath)
        cell.textLabel?.text = subcategories[indexPath.row].name
        return cell
    }
    
    
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
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
    
    
    
    private func createSubCategory(name: String) {
        let newSubCategory = SubCategory(context: context)
        newSubCategory.name = name
        category?.addToSubCategory(newSubCategory) // Use the generated accessor to add to the relationship set

        saveContext()
    }


    private func saveContext() {
        do {
            try context.save()
            loadFlashcards()
        } catch {
            showError(message: "Unable to save category.")
        }
    }


    // MARK: - Swipe Actions
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

    private func deleteSubCategory(at indexPath: IndexPath) {
        context.delete(subcategories[indexPath.row])
        saveContext()
    }

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

    private func updateSubCategory(at indexPath: IndexPath, with newName: String) {
        let category = subcategories[indexPath.row]
        category.name = newName
        saveContext()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let flashCardVC = storyboard.instantiateViewController(withIdentifier: "FlashcardViewController") as? FlashcardViewController {
            flashCardVC.subCategory = subcategories[indexPath.row]
            navigationController?.pushViewController(flashCardVC, animated: true)
        }
    }
    
}
