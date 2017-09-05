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
    
    fileprivate lazy var searchTextField: GRTextField = {
        let textField = GRTextField(icon: Asset.searchIcon.image)
        textField.delegate = self
        textField.returnKeyType = .search
        textField.placeholder = L10n.searchPlaceholder
        textField.addTarget(self, action: #selector(self.searchFieldTextDidChange), for: .editingChanged)
        textField.clearButtonMode = .always
        return textField
    }()
    
    fileprivate lazy var addButton: GRButton = {
        let button = GRButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.tintColor = .white
        button.addTarget(self, action: #selector(self.didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var elementCreationView: ElementCreationView = {
        let elementCreationView = ElementCreationView()
        elementCreationView.isHidden = true
        elementCreationView.alpha = 0
        elementCreationView.elementCreationDelegate = self
        return elementCreationView
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        addSubview(searchTextField)
        addSubview(addButton)
        addSubview(elementCreationView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addButton.frame.size.width = CGFloat.formFieldHeight
        addButton.frame.size.height = CGFloat.formFieldHeight
        addButton.layer.cornerRadius = CGFloat.formFieldRadius
        addButton.frame.origin.x = bounds.width - addButton.frame.width - CGFloat.pageMargin
        addButton.frame.origin.y = CGFloat.pageMargin
        
        searchTextField.frame.size.width = addButton.frame.minX - CGFloat.pageMargin - CGFloat.formMargin
        searchTextField.frame.size.height = CGFloat.formFieldHeight
        searchTextField.frame.origin.x = CGFloat.pageMargin
        searchTextField.frame.origin.y = CGFloat.pageMargin
        
        tableView.frame.size.width = bounds.width
        tableView.frame.size.height = bounds.height - searchTextField.frame.maxY - CGFloat.pageMargin - keyboardHeight
        tableView.frame.origin.y = searchTextField.frame.maxY + CGFloat.pageMargin
        
        elementCreationView.frame.size.width = bounds.width
        elementCreationView.frame.size.height = bounds.height - keyboardHeight
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
        guard let text = searchTextField.text else {
            return
        }
        
        updateElements(query: text)
    }
    
    func didTapAddButton() {
        elementCreationView.isHidden = false
        elementCreationView.nameTextField.becomeFirstResponder()
        delegate?.userDidStartSearching()
        
        UIView.animate(withDuration: 0.3) {
            self.elementCreationView.alpha = 1
        }
    }
 
    func didTapOutsideKeyboard() {
        searchTextField.resignFirstResponder()
        delegate?.userDidStopSearching()
    }

    // MARK: - Private Methods

    fileprivate func updateElements(query: String = "") {
        guard let dataSource = dataSource else {
            elements = []
            tableView.reloadData()
            return
        }
        guard query != "" else {
            elements = dataSource.unactiveElements()
            tableView.reloadData()
            return
        }

        elements = dataSource.unactiveElements().filter({ element in return element.matchesQuery(query: query.lowercased().trimmingCharacters(in: .whitespaces)) })
        tableView.reloadData()
    }

    fileprivate func activateElement(element: Element) {
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

// MARK: - UITextFieldDelegate

extension LeftListCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.userDidStartSearching()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapOutsideKeyboard()
        return false
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

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

// MARK: - OverviewTableViewCellDelegate

extension LeftListCollectionViewCell: OverviewTableViewCellDelegate {
    
    func restartActivationProcess(forElement element: Element) {
        element.activationTimer?.invalidate()
        element.activationTimer = nil
        element.activationTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
            self.activateElement(element: element)
        })
    }

    func completeActivationProcess(forElement element: Element) {
        element.activationTimer?.invalidate()
        element.activationTimer = nil
        activateElement(element: element)
    }
}

// MARK: - PriceSelectionViewDelate

extension LeftListCollectionViewCell: ElementCreationViewDelegate {
    
    func elementCreationViewShouldCloseView() {
        searchTextField.clearText()
        elementCreationView.reset()
        elementCreationView.nameTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            self.elementCreationView.alpha = 0
        }
        delegate?.userDidStopSearching()
    }
    
}
