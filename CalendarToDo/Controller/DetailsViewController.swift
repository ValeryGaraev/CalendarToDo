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
    private let realmManager: RealmManager
    private var image: UIImage? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let imagePickerController = UIImagePickerController()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM dd, yyyy"
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
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        setupTableView()
        setupUI()
    }
    
    // MARK: - Initializers
    
    init(toDoItem: ToDoItem, realmManager: RealmManager) {
        self.toDoItem = toDoItem
        self.realmManager = realmManager
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
        navigationItem.title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add image", style: .plain, target: self, action: #selector(didTapAddImageButton))
        
        if let image = UIImage(data: toDoItem.image) {
            self.image = image
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
        tableView.setConstraints(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                 leftAnchor: view.safeAreaLayoutGuide.leftAnchor,
                                 bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                                 rightAnchor: view.safeAreaLayoutGuide.rightAnchor,
                                 paddingTop: 0,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0)
    }
    
    // MARK: - Selectors
    
    @objc private func refresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc private func didTapAddImageButton() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return view.frame.width
        } else {
            return 44
        }
    }
}

// MARK: - UITableViewDataSource

extension DetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        print(#function)
        if image == nil {
            return 4
        } else {
            return 5
        }
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
        case 4:
            return "Image"
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
            cell.textLabel?.text = "On " + dateFormatter.string(from: Date(timeIntervalSince1970: toDoItem.startDate)) + " at " + timeFormatter.string(from: Date(timeIntervalSince1970: toDoItem.startDate))
        case 2:
            cell.textLabel?.text = "On " + dateFormatter.string(from: Date(timeIntervalSince1970: toDoItem.endDate)) + " at " + timeFormatter.string(from: Date(timeIntervalSince1970: toDoItem.endDate))
        case 3:
            cell.textLabel?.text = toDoItem.itemDescription
        case 4:
            cell.imageView?.image = image
            cell.imageView?.fillView(cell)
        default:
            cell.textLabel?.text = ""
        }

        return cell
    }
}

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.image = image
        guard let imageData = image.pngData() else { return }
        realmManager.addImage(imageData, to: self.toDoItem)
        dismiss(animated: true, completion: nil)
    }
}
