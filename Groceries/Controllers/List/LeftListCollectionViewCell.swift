//
//  LeftListCollectionViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol LeftListCollectionViewCellDelegate {
    func userDidStartSearching()
    func userDidStopSearching()
}

class LeftListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Class Properties
    
    static let reuseIdentifier = "LeftListCollectionViewCellReuseIdentifier"
    
    // MARK: - Properties
    
    var delegate: LeftListCollectionViewCellDelegate? = nil
    
    fileprivate var keyboardHeight: CGFloat = 0 {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    fileprivate var userIsCreating: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var searchAddTextField: GRTextField = {
        let textField = GRTextField(icon: Asset.searchIcon.image)
        textField.delegate = self
        textField.returnKeyType = .done
        textField.placeholder = L10n.searchPlaceholder
        return textField
    }()
    
    fileprivate lazy var categoryTextField: GRTextField = {
        let textField = GRTextField(icon: Asset.categoryIcon.image)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.placeholder = L10n.category
        return textField
    }()
    
    fileprivate lazy var priceTextField: GRTextField = {
        let textField = GRTextField(icon: Asset.priceIcon.image)
        textField.delegate = self
        textField.returnKeyType = .done
        textField.placeholder = L10n.optionalIndicator
        return textField
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OverviewTableViewCell.classForCoder(), forCellReuseIdentifier: OverviewTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = false
        return tableView
    }()
    
    fileprivate lazy var addButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.add, for: .normal)
//        button.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        addSubview(searchAddTextField)
        addSubview(categoryTextField)
        addSubview(priceTextField)
        addSubview(addButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchAddTextField.frame.size.width = bounds.width - 2 * CGFloat.pageMargin
        searchAddTextField.frame.size.height = CGFloat.formFieldHeight
        searchAddTextField.center.x = bounds.width/2
        searchAddTextField.frame.origin.y = CGFloat.pageMargin
        
        let dualFormAvailableWidth: CGFloat = bounds.width - 2 * CGFloat.pageMargin - CGFloat.formMargin
        
        categoryTextField.alpha = userIsCreating ? 1 : 0
        categoryTextField.isUserInteractionEnabled = userIsCreating
        categoryTextField.frame.size.height = CGFloat.formFieldHeight
        categoryTextField.frame.size.width = dualFormAvailableWidth * 2 / 3
        categoryTextField.frame.origin.x = CGFloat.pageMargin
        categoryTextField.frame.origin.y = searchAddTextField.frame.maxY + CGFloat.formMargin
        
        priceTextField.alpha = userIsCreating ? 1 : 0
        priceTextField.isUserInteractionEnabled = userIsCreating
        priceTextField.frame.size.height = CGFloat.formFieldHeight
        priceTextField.frame.size.width = dualFormAvailableWidth * 1 / 3
        priceTextField.frame.origin.x = categoryTextField.frame.maxX + CGFloat.formMargin
        priceTextField.frame.origin.y = categoryTextField.frame.origin.y
        
        addButton.alpha = userIsCreating ? 1 : 0
        addButton.isUserInteractionEnabled = userIsCreating
        addButton.frame.size = searchAddTextField.frame.size
        addButton.center.x = bounds.width/2
        addButton.frame.origin.y = bounds.height - addButton.frame.height - CGFloat.pageMargin - keyboardHeight
        
        tableView.alpha = userIsCreating ? 0 : 1
        tableView.frame.size.width = bounds.width
        tableView.frame.size.height = bounds.height - searchAddTextField.frame.maxY - CGFloat.pageMargin - keyboardHeight
        tableView.frame.origin.y = searchAddTextField.frame.maxY + CGFloat.pageMargin
    }
    
    // MARK: - Selector Methods
    
    func keyboardWillChangeFrame(_ notification: NSNotification) {
        
        if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = frame.height
        }
        
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = 0
    }

}

extension LeftListCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userIsCreating = true
        delegate?.userDidStartSearching()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userIsCreating = false
        delegate?.userDidStopSearching()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension LeftListCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OverviewTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.reuseIdentifier, for: indexPath)
    }
    
}
