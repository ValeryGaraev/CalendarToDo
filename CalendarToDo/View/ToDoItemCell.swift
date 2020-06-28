//
//  ToDoItemCell.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 28.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import UIKit

class ToDoItemCell: UITableViewCell {
    
    // MARK: - Properties
    
    var startDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    var startTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    var endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    var endTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [startDateLabel, startTimeLabel, dividerView, endTimeLabel, endDateLabel])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .center
        
        addSubview(stackView)
        
        dividerView.setConstraints(width: 80, height: 0.75)
        
        stackView.setConstraints(topAnchor: self.topAnchor,
                                 leftAnchor: self.leftAnchor,
                                 bottomAnchor: self.bottomAnchor,
                                 paddingTop: 10,
                                 paddingLeft: 0,
                                 paddingBottom: 10,
                                 width: 100)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
