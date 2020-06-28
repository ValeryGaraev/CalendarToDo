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
    private let realmManager: RealmManager
    private var toDoItems: [ToDoItem]
    private var selectedDate: Date?
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "MSK")
        return dateFormatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendar()
        setupTableView()
        setupUI()
    }
    
    // MARK: - Initializers
    
    required init(realmManager: RealmManager) {
        self.realmManager = realmManager
        self.toDoItems = self.realmManager.toDoItems(forDate: Date())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper functions
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "ToDo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        
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
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoItemCell.self, forCellReuseIdentifier: String(describing: ToDoItemCell.self))
        tableView.addSubview(refreshControl)
        view.addSubview(tableView)
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
    
    @objc private func didTapAddButton() {
        let addToDoItemVC = UINavigationController(rootViewController: AddViewController(realmManager: realmManager, date: selectedDate ?? Date()))
        self.navigationController?.present(addToDoItemVC, animated: true, completion: nil)
    }
    
    @objc private func refresh() {
        if let selectedDate = selectedDate {
            toDoItems = realmManager.toDoItems(forDate: selectedDate)
        } else {
            toDoItems = realmManager.toDoItems(forDate: Date())
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController(toDoItem: toDoItems[indexPath.row], realmManager: realmManager)
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let selectedDate = selectedDate {
            return "ToDo for \(dateFormatter.string(from: selectedDate))"
        } else {
            return "ToDo for \(dateFormatter.string(from: Date()))"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ToDoItemCell.self), for: indexPath) as! ToDoItemCell
        let startTime = timeFormatter.string(from: Date(timeIntervalSince1970: self.toDoItems[indexPath.row].startDate))
        let endTime = timeFormatter.string(from: Date(timeIntervalSince1970: self.toDoItems[indexPath.row].endDate))
        cell.startTimeLabel.text = startTime
        cell.endTimeLabel.text = endTime
        cell.nameLabel.text = self.toDoItems[indexPath.row].itemName
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FirebaseManager().remove(toDoItem: toDoItems[indexPath.row])
            realmManager.remove(toDoItem: toDoItems[indexPath.row])
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - FSCalendarDelegate

extension ListViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        self.toDoItems = realmManager.toDoItems(forDate: date)
        tableView.reloadData()
    }
}

// MARK: - FSCalendarDataSource

extension ListViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let toDoItems = realmManager.toDoItems(forDate: date)
        return toDoItems.count > 0 ? 1 : 0
    }
}

extension ListViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let toDoItems = realmManager.toDoItems(forDate: date)
        cell.eventIndicator.isHidden = false
        cell.eventIndicator.color = UIColor.green
        if !toDoItems.isEmpty {
            cell.eventIndicator.numberOfEvents = 1
        }
    }
}
