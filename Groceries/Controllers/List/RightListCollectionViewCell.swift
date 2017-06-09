//
//  RightListCollectionViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class RightListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Class Properties
    
    static let reuseIdentifier = "RightListCollectionViewCellReuseIdentifier"
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
//        tableView.dataSource = self
//        tableView.delegate = self
        tableView.register(ElementTableViewCell.classForCoder(), forCellReuseIdentifier: ElementTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    fileprivate lazy var completeButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .flatBelizeHole
        button.setTitleColor(.white, for: .normal)
        button.setTitle(L10n.add, for: .normal)
        //        button.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        addSubview(completeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        completeButton.frame.size.width = bounds.width - 2 * CGFloat.pageMargin
        completeButton.frame.size.height = CGFloat.formFieldHeight
        completeButton.center.x = bounds.width/2
        completeButton.frame.origin.y = bounds.height - completeButton.frame.height - CGFloat.pageMargin
        completeButton.layer.cornerRadius = CGFloat.formFieldRadius
        
        tableView.frame.size.width = bounds.width
        tableView.frame.size.height = completeButton.frame.minY - CGFloat.pageMargin * 2
        tableView.frame.origin.y = CGFloat.pageMargin
    }
    
}
