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

protocol LeftListCollectionViewCellDataSource {
    func unactiveElements() -> [Element]
}

class LeftListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Class Properties
    
    static let reuseIdentifier = "LeftListCollectionViewCellReuseIdentifier"
    
    // MARK: - Properties
    
    var delegate: LeftListCollectionViewCellDelegate? = nil
    var dataSource: LeftListCollectionViewCellDataSource? = nil {
        didSet {
            updateElements()
        }
    }
    
    var elements: [Element] = []
    
    var userIsCreating: Bool = false
    
    fileprivate var keyboardHeight: CGFloat = 0 {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OverviewTableViewCell.classForCoder(), forCellReuseIdentifier: OverviewTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapOutsideKeyboard))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        
        return tableView
    }()
    
    fileprivate lazy var searchAddTextField: GRTextField = {
        let textField = GRTextField(icon: Asset.searchIcon.image)
        textField.delegate = self
        textField.returnKeyType = .search
        textField.placeholder = L10n.searchPlaceholder
        textField.addTarget(self, action: #selector(self.searchFieldTextDidChange), for: .allEditingEvents)
        textField.clearButtonMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapSearchFieldClearButton))
        textField.rightView!.addGestureRecognizer(tapGestureRecognizer)
        
        return textField
    }()
    
    fileprivate lazy var elementCreationView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        return view
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
        textField.isClearable = false
        return textField
    }()
    
    fileprivate lazy var cancelButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.cancel, for: .normal)
        button.backgroundColor = .flatSilver
        button.addTarget(self, action: #selector(self.cancelCreation), for: .touchUpInside)
        return button
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
        addSubview(elementCreationView)
        elementCreationView.addSubview(categoryTextField)
        elementCreationView.addSubview(priceTextField)
        elementCreationView.addSubview(addButton)
        elementCreationView.addSubview(cancelButton)
        
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
        
        tableView.frame.size.width = bounds.width
        tableView.frame.size.height = bounds.height - searchAddTextField.frame.maxY - CGFloat.pageMargin - keyboardHeight
        tableView.frame.origin.y = searchAddTextField.frame.maxY + CGFloat.pageMargin
        
        elementCreationView.frame.size.width = bounds.width
        elementCreationView.frame.size.height = bounds.height - searchAddTextField.frame.maxY - keyboardHeight
        elementCreationView.frame.origin.y = searchAddTextField.frame.maxY
        
        let dualFormAvailableWidth: CGFloat = bounds.width - 2 * CGFloat.pageMargin - CGFloat.formMargin
        
        categoryTextField.frame.size.height = CGFloat.formFieldHeight
        categoryTextField.frame.size.width = dualFormAvailableWidth * 2 / 3
        categoryTextField.frame.origin.x = CGFloat.pageMargin
        categoryTextField.frame.origin.y = CGFloat.formMargin
        
        priceTextField.frame.size.height = CGFloat.formFieldHeight
        priceTextField.frame.size.width = dualFormAvailableWidth * 1 / 3
        priceTextField.frame.origin.x = categoryTextField.frame.maxX + CGFloat.formMargin
        priceTextField.frame.origin.y = categoryTextField.frame.origin.y
        
        cancelButton.frame.size.width = dualFormAvailableWidth/2
        cancelButton.frame.size.height = CGFloat.formFieldHeight
        cancelButton.frame.origin.x = CGFloat.pageMargin
        cancelButton.frame.origin.y = elementCreationView.bounds.height - cancelButton.frame.height - CGFloat.pageMargin
        
        addButton.frame.size = cancelButton.frame.size
        addButton.frame.origin.x = cancelButton.frame.maxX + CGFloat.formMargin
        addButton.frame.origin.y = cancelButton.frame.origin.y
        
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
    
    func searchFieldTextDidChange() {
        guard let text = searchAddTextField.text else {
            return
        }
        
        let query = text.lowercased().trimmingCharacters(in: .whitespaces)
        updateElements(query: query)
    }
    
    func cancelCreation() {
        searchAddTextField.clearText()
        searchAddTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        delegate?.userDidStopSearching()
    }
    
    func didTapOutsideKeyboard() {
        searchAddTextField.resignFirstResponder()
        delegate?.userDidStopSearching()
    }
    
    func didTapSearchFieldClearButton() {
        if !searchAddTextField.isFirstResponder {
            cancelCreation()
        } else {
            searchAddTextField.clearText()
        }
    }
    
    // MARK: - Private Methods

    fileprivate func updateElements(query: String = "") {
        guard let dataSource = dataSource else {
            elements = []
            tableView.reloadData()
            updateInputLayout()
            return
        }
        guard query != "" else {
            elements = dataSource.unactiveElements()
            tableView.reloadData()
            updateInputLayout()
            return
        }
        
        elements = dataSource.unactiveElements().filter({ element in return element.matchesQuery(query: query) })
        tableView.reloadData()
        updateInputLayout()
    }
    
    fileprivate func updateInputLayout() {
        
        if userIsCreating && elements.count > 0 {
            userIsCreating = false
        } else if !userIsCreating && elements.count == 0 {
            userIsCreating = true
        } else {
            return
        }
        print("Update required")
        
        if userIsCreating {
            
            searchAddTextField.iconImage = Asset.addIcon.image
            searchAddTextField.returnKeyType = .next
            searchAddTextField.reloadInputViews()
            elementCreationView.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.elementCreationView.alpha = 1
                self.tableView.alpha = 0
                
            }, completion: { completed in
                
                self.tableView.isHidden = true
                
            })
            
        } else {
            
            searchAddTextField.iconImage = Asset.searchIcon.image
            searchAddTextField.returnKeyType = .search
            searchAddTextField.reloadInputViews()
            tableView.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.elementCreationView.alpha = 0
                self.tableView.alpha = 1
                
            }, completion: { completed in
                
                self.elementCreationView.isHidden = true
                self.categoryTextField.clearText()
                self.priceTextField.clearText()
                
            })
            
        }
        
    }
    
}

extension LeftListCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.userDidStartSearching()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == searchAddTextField && !userIsCreating {
            textField.resignFirstResponder()
            delegate?.userDidStopSearching()
        } else if textField == searchAddTextField && userIsCreating {
            print("search + create")
            categoryTextField.becomeFirstResponder()
        } else if textField == categoryTextField {
            priceTextField.becomeFirstResponder()
        }
        
        return false
    }
    
}

extension LeftListCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OverviewTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.reuseIdentifier, for: indexPath) as! OverviewTableViewCell
        cell.element = elements[indexPath.row]
        return cell
    }
    
}
