//
//  ListViewController.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 27.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import UIKit
import FSCalendar

class ListViewController: UIViewController {

    // MARK: - Properties
    
    private var tableView: UITableView!
    private weak var calendarView: FSCalendar!
    private let viewModel: ToDoItemViewModel
    private var toDoItems: [ToDoItem]
    private var selectedDate: Date?
    private lazy var refreshControl = UIRefreshControl()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        setupCalendar()
        setupTableView()
        setupUI()
    }
    
    // MARK: - Initializers
    
    required init(viewModel: ToDoItemViewModel) {
        self.viewModel = viewModel
        toDoItems = self.viewModel.toDoItems(forDate: Date())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        // set background
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        // setup navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "ToDo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoItem))
        
        // constraint subviews
        calendarView.setConstraints(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                    leftAnchor: view.safeAreaLayoutGuide.leftAnchor,
                                    bottomAnchor: tableView.topAnchor,
                                    rightAnchor: view.safeAreaLayoutGuide.rightAnchor,
                                    paddingTop: 0,
                                    paddingLeft: 0,
                                    paddingBottom: 0,
                                    paddingRight: 0,
                                    width: view.frame.width,
                                    height: 300)
        
        tableView.setConstraints(topAnchor: calendarView.bottomAnchor,
                                 leftAnchor: view.safeAreaLayoutGuide.leftAnchor,
                                 bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                                 rightAnchor: view.safeAreaLayoutGuide.rightAnchor,
                                 paddingTop: 0,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0)
    }
    
    private func setupTableView() {
        self.tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.addSubview(refreshControl)
    }
    
    private func setupCalendar() {
        let calendar = FSCalendar(frame: CGRect())
        calendar.firstWeekday = 2
        calendar.delegate = self
        view.addSubview(calendar)
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                calendar.appearance.titleDefaultColor = .white
            } else {
                calendar.appearance.titleDefaultColor = .black
            }
        }
        
        self.calendarView = calendar
    }
    
    // MARK: - Selectors
    
    @objc private func addToDoItem() {
        let addToDoItemVC = UINavigationController(rootViewController: AddToDoItemViewController(viewModel: viewModel))
        self.navigationController?.present(addToDoItemVC, animated: true, completion: nil)
    }
    
    @objc private func refresh() {
        if let selectedDate = selectedDate {
            toDoItems = viewModel.toDoItems(forDate: selectedDate)
        } else {
            toDoItems = viewModel.toDoItems(forDate: Date())
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController(toDoItem: toDoItems[indexPath.row])
        navigationController?.present(detailsVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ToDo"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row].itemName
        return cell
    }
}

// MARK: - FSCalendarDelegate

extension ListViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        self.toDoItems = viewModel.toDoItems(forDate: date)
        tableView.reloadData()
    }
}
