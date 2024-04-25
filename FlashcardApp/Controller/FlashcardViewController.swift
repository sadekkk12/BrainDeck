//
//  FlashcardViewController.swift
//  FlashcardApp
//
//  Created by Sadek on 20/04/2024.
//

import UIKit

class FlashcardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties
    var subCategory: SubCategory?
    var flashcards: [FlashCard] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadFlashcards()
    }

    // MARK: - Configuration
    /// Sets up tableView properties and aesthetics.
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.view.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
            tableView.backgroundColor = UIColor(red: 10/255.0, green: 22/255.0, blue: 35/255.0, alpha: 1)
            navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        title = subCategory?.name ?? "Flashcards"
    }
    /// Loads flashcards from the persistent container associated with the selected subcategory.
    private func loadFlashcards() {
        if let subCategory = subCategory, let set = subCategory.flashCard as? Set<FlashCard> {
            flashcards = Array(set)
        }
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashcardCell", for: indexPath)
        cell.textLabel?.text = flashcards[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            editFlashcard(at: indexPath)
        }


    // MARK: - Swipe Actions
    /// Configures swipe actions for editing and deleting flashcards.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.deleteFlashcard(at: indexPath)
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            self.editFlashcard(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .darkGray
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    private func deleteFlashcard(at indexPath: IndexPath) {
        let flashcardToDelete = flashcards[indexPath.row]
        context.delete(flashcardToDelete)
        saveContext()
    }

    private func editFlashcard(at indexPath: IndexPath) {
        let flashcard = flashcards[indexPath.row]
        showFlashcardForm(for: flashcard)
    }

    // MARK: - Navigation to FlashcardCreationForm
     @objc private func didTapAdd() {
        showFlashcardForm(for: nil)
    }

    private func showFlashcardForm(for flashcard: FlashCard?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FlashcardFormViewController") as? FlashcardFormViewController {
            vc.flashcard = flashcard
            vc.subCategory = subCategory
            vc.onSave = { [weak self] in
                self?.loadFlashcards()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK: - Persistence
    /// Saves any changes made to the context.
    private func saveContext() {
        do {
            try context.save()
            loadFlashcards()
        } catch {
            showError(message: "Unable to save flashcard: \(error.localizedDescription)")
        }
    }
    
    
    /// Displays an error message in case of failure to save context changes.
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

