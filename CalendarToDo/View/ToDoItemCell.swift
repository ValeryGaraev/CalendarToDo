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
    
    let startTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let endTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.setDimensions(width: 45, height: 0.75)
        view.backgroundColor = .systemGray
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                startTimeLabel.textColor = .white
                endTimeLabel.textColor = .white
                nameLabel.textColor = .white
            }
        }

        let dateStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [startTimeLabel, dividerView, endTimeLabel])
            stackView.distribution = .equalCentering
            stackView.axis = .vertical
            stackView.alignment = .center
            return stackView
        }()
        
        addSubview(dateStackView)
        addSubview(nameLabel)
        
        dateStackView.setConstraints(topAnchor: self.topAnchor,
                                     leftAnchor: self.leftAnchor,
                                     bottomAnchor: self.bottomAnchor,
                                     paddingTop: 5,
                                     paddingLeft: 20,
                                     paddingBottom: 5,
                                     width: 50)
        
        nameLabel.setConstraints(leftAnchor: dateStackView.rightAnchor, paddingLeft: 10)
        nameLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
