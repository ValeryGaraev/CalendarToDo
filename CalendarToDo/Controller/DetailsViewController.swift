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
    
    private var tableView: UITableView!
    private let toDoItem: ToDoItem
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM dd, yyyy" + " at " + "HH:mm"
        return dateFormatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
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
    
    // MARK: - Helper functions
    
    private func setupUI() {
        // set background
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.addSubview(refreshControl)
        view.addSubview(tableView)
        tableView.fillView(view)
    }
    
    // MARK: - Selectors
    
    @objc private func refresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

// MARK: - UITableViewDelegate

extension DetailsViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension DetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Start date"
        case 2:
            return "End date"
        case 3:
            return "Description"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = toDoItem.itemName
        case 1:
            cell.textLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: toDoItem.startDate))
        case 2:
            cell.textLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: toDoItem.endDate))
        case 3:
            cell.textLabel?.text = toDoItem.itemDescription
        default:
            ""
        }
        return cell
    }
}
