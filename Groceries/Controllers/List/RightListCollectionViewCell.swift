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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
}
