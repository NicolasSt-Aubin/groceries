//
//  RightListCollectionViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol RightListCollectionViewCellDataSource {
    func onShelfElements() -> [Element]
    func inCartElements() -> [Element]
}

class RightListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Class Properties
    
    static let reuseIdentifier = "RightListCollectionViewCellReuseIdentifier"
    
    var dataSource: RightListCollectionViewCellDataSource? = nil
    
    var virtualNumberOfSections: Int {
        guard let dataSource = dataSource else {
            return 0
        }
        
        if dataSource.onShelfElements().count > 0 && dataSource.inCartElements().count > 0 {
            return 2
        } else if dataSource.onShelfElements().count > 0 || dataSource.inCartElements().count > 0 {
            return 1
        } else {
            return 0
        }
        
    }
    
    var desiredTableViewHeight: CGFloat {
        guard let dataSource = dataSource else {
            return 0
        }
        
        return CGFloat(dataSource.onShelfElements().count + dataSource.inCartElements().count) * NeedToBuyTableViewCell.height + CGFloat(virtualNumberOfSections) * NeedToBuyTableHeaderView.height
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NeedToBuyTableViewCell.classForCoder(), forCellReuseIdentifier: NeedToBuyTableViewCell.reuseIdentifier)
        tableView.register(NeedToBuyTableHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: NeedToBuyTableHeaderView.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    fileprivate lazy var completeButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.complete, for: .normal)
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
        
        tableView.frame.size.width = bounds.width - CGFloat.pageMargin * 2
        
        let maxTableViewHeight = completeButton.frame.minY - CGFloat.pageMargin * 2
        
        tableView.frame.size.height = desiredTableViewHeight > maxTableViewHeight ? maxTableViewHeight : desiredTableViewHeight
        tableView.frame.origin.y = CGFloat.pageMargin
        tableView.center.x = bounds.width/2
        tableView.layer.cornerRadius = CGFloat.formFieldRadius
    }
    
    // MARK: - Selector Methods
    
    func didTapCheckButton(_ sender : UIButton?) {
        guard let checkButton = sender as? CheckButton else {
            return
        }
        
        guard let element = checkButton.element else {
            return
        }
        
        guard let dataSource = dataSource else {
            return
        }

        if let index = dataSource.onShelfElements().index(where: {elem in element == elem}) {
            
            let oldIndexPath = IndexPath(row: index, section: 0)
            element.inCart = true
            
            
            if let index = dataSource.inCartElements().index(where: {elem in element == elem}) {
                let newIndexPath = IndexPath(row: index, section: 1)
                
                checkButton.isChecked = true
                checkButton.animateCheck {
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.beginUpdates()
                        self.tableView.deleteRows(at: [oldIndexPath], with: .top)
                        self.tableView.insertRows(at: [newIndexPath], with: .top)
                        self.tableView.endUpdates()
                        
                        self.reloadHeaders()
                    })
                    
                }
            }
            
        } else if let index = dataSource.inCartElements().index(where: {elem in element == elem}) {
            
            let oldIndexPath = IndexPath(row: index, section: 1)
            element.inCart = false
            
            if let index = dataSource.onShelfElements().index(where: {elem in element == elem}) {
                let newIndexPath = IndexPath(row: index, section: 0)
                
                checkButton.isChecked = false
                checkButton.animateCheck {
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.beginUpdates()
                        self.tableView.deleteRows(at: [oldIndexPath], with: .top)
                        self.tableView.insertRows(at: [newIndexPath], with: .top)
                        self.tableView.endUpdates()
                        
                        self.reloadHeaders()
                    })
                    
                }
            }
            
        }
        
    }
    
    fileprivate func reloadHeaders() {
        // Necessary hack to improve animation when one section empties into the other
        
        let maxTableViewHeight = completeButton.frame.minY - CGFloat.pageMargin * 2
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame.size.height = self.desiredTableViewHeight > maxTableViewHeight ? maxTableViewHeight : self.desiredTableViewHeight
            self.tableView.contentOffset.y = self.tableView.contentOffset.y+1
        }
    }
    
}

extension RightListCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    
    // Header
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: NeedToBuyTableHeaderView.reuseIdentifier) as! NeedToBuyTableHeaderView
        
        if section == 0 {
            view.title = L10n.onTheShelf
        } else if section == 1 {
            view.title = L10n.inYourCart
        } else {
            view.title = " "
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let dataSource = dataSource else {
            return 0
        }
        
        if section == 0 && dataSource.onShelfElements().count > 0 {
            return NeedToBuyTableHeaderView.height
        } else if section == 1 && dataSource.inCartElements().count > 0 {
            return NeedToBuyTableHeaderView.height
        }
        
        return 0
    }
    
    // Cells
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        
        if section == 0 {
            return dataSource.onShelfElements().count
        } else if section == 1 {
            return dataSource.inCartElements().count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NeedToBuyTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSource else {
            return tableView.dequeueReusableCell(withIdentifier: NeedToBuyTableViewCell.reuseIdentifier, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NeedToBuyTableViewCell.reuseIdentifier, for: indexPath) as! NeedToBuyTableViewCell
        
        if indexPath.section == 0 {
            
            let elements = dataSource.onShelfElements()
            cell.separatorView.isHidden = indexPath.row == elements.count-1 && dataSource.inCartElements().count == 0
            cell.element = elements[indexPath.row]
            
        } else if indexPath.section == 1 {
            
            let elements = dataSource.inCartElements()
            cell.separatorView.isHidden = indexPath.row == elements.count-1
            cell.element = elements[indexPath.row]
            
        }

        cell.checkButton.addTarget(self, action: #selector(self.didTapCheckButton(_:)), for: .touchUpInside)
        return cell
    }
    
}
