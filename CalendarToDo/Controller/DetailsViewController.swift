//
//  DetailsViewController.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 27.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let toDoItem: ToDoItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print(toDoItem)
    }
    
    // MARK: - Initializers
    
    init(toDoItem: ToDoItem) {
        self.toDoItem = toDoItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // set background
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
}
