//
//  AddViewController.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 27.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var nameTextField = generateTextField(withPlaceholder: "Enter name")
    private lazy var descriptionTextField = generateTextField(withPlaceholder: "Enter description")
    
    private lazy var startDatePicker = generateDatePicker()
    private lazy var endDatePicker = generateDatePicker()
    
    private lazy var startDateLabel = generateLabel(withText: "Choose start date")
    private lazy var endDateLabel = generateLabel(withText: "Choose end date")
    
    private lazy var alert = UIAlertController(title: "All fields are required", message: "Please fill out both name and description fields.", preferredStyle: .alert)
    
    private let realmManager: RealmManager!
    private let date: Date!
    
    public var completionHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Initializers
    
    required init(realmManager: RealmManager, date: Date) {
        self.realmManager = realmManager
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapSaveButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapCancelButton))
        
        alert.addAction(UIAlertAction(title: "Will do!", style: .cancel, handler: nil))
        
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(startDateLabel)
        view.addSubview(endDateLabel)
        
        endDatePicker.date = Date(timeInterval: 3600, since: date)
        
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        
        nameTextField.setConstraints(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                     leftAnchor: view.leftAnchor,
                                     rightAnchor: view.rightAnchor,
                                     paddingTop: 15,
                                     paddingLeft: 15,
                                     paddingRight: 15,
                                     height: 40)
        
        descriptionTextField.setConstraints(topAnchor: nameTextField.bottomAnchor,
                                            leftAnchor: view.leftAnchor,
                                            rightAnchor: view.rightAnchor,
                                            paddingTop: 15,
                                            paddingLeft: 15,
                                            paddingRight: 15,
                                            height: 40)
        
        startDateLabel.setConstraints(topAnchor: descriptionTextField.bottomAnchor,
                                      leftAnchor: view.safeAreaLayoutGuide.leftAnchor,
                                      paddingTop: 15,
                                      paddingLeft: 15)
        
        startDatePicker.setConstraints(topAnchor: startDateLabel.bottomAnchor,
                                       leftAnchor: view.safeAreaLayoutGuide.leftAnchor,
                                       rightAnchor: view.safeAreaLayoutGuide.rightAnchor,
                                       paddingTop: 0,
                                       paddingLeft: 0,
                                       paddingRight: 0,
                                       height: 200)
        
        endDateLabel.setConstraints(topAnchor: startDatePicker.bottomAnchor,
                                    leftAnchor: view.safeAreaLayoutGuide.leftAnchor,
                                    paddingTop: 15,
                                    paddingLeft: 15)
        
        endDatePicker.setConstraints(topAnchor: endDateLabel.bottomAnchor,
                                     leftAnchor: view.safeAreaLayoutGuide.leftAnchor,
                                     rightAnchor: view.safeAreaLayoutGuide.rightAnchor,
                                     paddingTop: 0,
                                     paddingLeft: 0,
                                     paddingRight: 0,
                                     height: 200)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSaveButton() {
        guard nameTextField.text?.isEmpty == false, descriptionTextField.text?.isEmpty == false else {
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let name = nameTextField.text, let description = descriptionTextField.text else { return }
        
        let startDate = startDatePicker.date.timeIntervalSince1970
        let endDate = endDatePicker.date.timeIntervalSince1970
        
        let toDoItem = ToDoItem()
        toDoItem.itemName = name
        toDoItem.itemDescription = description
        toDoItem.startDate = startDate
        toDoItem.endDate = endDate
        
        realmManager.save(toDoItem: toDoItem)
        FirebaseManager().save(toDoItem: toDoItem) { (error, databaseReference) in
            if let error = error {
                print("DEBUG: Error saving: \(error.localizedDescription)")
                return
            }
        }
        
        completionHandler?()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - Helper functions

extension AddViewController {
    private func generateTextField(withPlaceholder placeholder: String, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = placeholder
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        if isSecure == true { textField.isSecureTextEntry = true }
        return textField
    }
    
    private func generateDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.setDate(date, animated: false)
        return datePicker
    }
    
    private func generateLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        return label
    }
}
