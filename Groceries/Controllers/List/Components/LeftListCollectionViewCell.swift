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
    func shouldRefreshNeedToBuyList()
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
        textField.addTarget(self, action: #selector(self.searchFieldTextDidChange), for: .editingChanged)
        textField.clearButtonMode = .always
        textField.text = "chips"
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
    
    fileprivate lazy var categorySelectionView: CategorySelectionView = {
        let categorySelectionView = CategorySelectionView()
        return categorySelectionView
    }()
    
    fileprivate lazy var priceSelectionView: PriceSelectionView = {
        let priceSelectionView = PriceSelectionView()
        return priceSelectionView
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
        elementCreationView.addSubview(categorySelectionView)
        elementCreationView.addSubview(priceSelectionView)
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
        
        categorySelectionView.frame.size.width = elementCreationView.bounds.width
        categorySelectionView.frame.size.height = 120
        categorySelectionView.frame.origin.y = CGFloat.formMargin
        
        priceSelectionView.frame.size.width = elementCreationView.bounds.width
        priceSelectionView.frame.size.height = 80
        priceSelectionView.frame.origin.y = categorySelectionView.frame.maxY + CGFloat.formMargin
        
        let dualFormAvailableWidth: CGFloat = elementCreationView.bounds.width - 2 * CGFloat.pageMargin - CGFloat.formMargin
        
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
        
        updateElements(query: text)
    }
    
    func cancelCreation() {
        searchAddTextField.clearText()
        searchAddTextField.resignFirstResponder()
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
    
    // MARK: - Public Methods
    
    func refresh() {
        guard let text = searchAddTextField.text else {
            updateElements()
            return
        }
        updateElements(query: text)
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

        elements = dataSource.unactiveElements().filter({ element in return element.matchesQuery(query: query.lowercased().trimmingCharacters(in: .whitespaces)) })
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
                self.categorySelectionView.reset()
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
        cell.delegate = self
        return cell
    }
    
}

extension LeftListCollectionViewCell: OverviewTableViewCellDelegate {
    
    func didSwipeCell(withElement element: Element) {
        if let index = elements.index(where: {elem in element == elem}) {
            let indexPath = IndexPath(row: index, section: 0)
            element.active = true
            elements.remove(at: index)
            DispatchQueue.main.async(execute: {
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .top)
                self.tableView.endUpdates()
            })
            
            delegate?.shouldRefreshNeedToBuyList()
        }
    }
    
}
