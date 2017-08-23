//
//  CreateListView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-07-04.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol CreateListViewDelegate {
    func shouldStopCreation()
}

class CreateListView: UIView {

    // MARK: - Properties
    
    var delegate: CreateListViewDelegate? = nil
    
    var list: List? = nil {
        didSet {
            userTalbeView.reloadData()
            setNeedsLayout()
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UI Elements

    fileprivate lazy var createListLabel: UILabel = {
        let label = UILabel.generateTitleLabel()
        label.text = L10n.createList
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var listNameInstructionLabel: UILabel = {
        let label = UILabel.generateInstructionLabel()
        label.text = L10n.listName.uppercased()
        label.sizeToFit()
        return label
    }()
    
    lazy var listNameField: GRTextField = {
        let textField = GRTextField(icon: Asset.addIcon.image)
        textField.returnKeyType = UIReturnKeyType.send
        textField.placeholder = L10n.name
        textField.delegate = self
        return textField
    }()
    
    fileprivate lazy var inviteInstructionLabel: UILabel = {
        let label = UILabel.generateInstructionLabel()
        label.text = L10n.inviteFriends.uppercased()
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var userTalbeView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserTableViewCell.classForCoder(), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    fileprivate lazy var inviteField: GRTextField = {
        let textField = GRTextField(icon: Asset.userIcon.image)
        textField.returnKeyType = .go
        textField.placeholder = L10n.email.capitalized
        return textField
    }()
    
    fileprivate lazy var inviteButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.invite, for: .normal)
        return button
    }()
    
    fileprivate lazy var cancelButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.cancel, for: .normal)
        button.backgroundColor = .flatSilver
        button.addTarget(self, action: #selector(self.didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var addButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.add, for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        addSubview(createListLabel)
        addSubview(listNameInstructionLabel)
        addSubview(listNameField)
        addSubview(inviteInstructionLabel)
        addSubview(userTalbeView)
        addSubview(inviteField)
        addSubview(inviteButton)
//        addSubview(cancelButton)
//        addSubview(addButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createListLabel.frame.origin.y = CGFloat.topTitleMargin
        createListLabel.frame.origin.x = CGFloat.pageMargin
        
        listNameInstructionLabel.frame.origin.x = createListLabel.frame.origin.x
        listNameInstructionLabel.frame.origin.y = createListLabel.frame.maxY + 20
        
        listNameField.frame.size.width = bounds.width - CGFloat.pageMargin*2
        listNameField.frame.size.height = CGFloat.formFieldHeight
        listNameField.frame.origin.x = CGFloat.pageMargin
        listNameField.frame.origin.y = listNameInstructionLabel.frame.maxY + CGFloat.formMargin
        listNameField.layer.cornerRadius = CGFloat.formFieldRadius
        
        inviteInstructionLabel.alpha = list == nil ? 0 : 1
        inviteInstructionLabel.frame.origin.x = createListLabel.frame.origin.x
        inviteInstructionLabel.frame.origin.y = listNameField.frame.maxY + 20
        
//        userTalbeView.frame.size.wi
        
        inviteButton.alpha = list == nil ? 0 : 1
        inviteButton.sizeToFit()
        inviteButton.frame.size.width += 6*CGFloat.formMargin
        inviteButton.frame.size.height = CGFloat.formFieldHeight
        inviteButton.frame.origin.y = inviteInstructionLabel.frame.maxY + CGFloat.formMargin
        inviteButton.layer.cornerRadius = CGFloat.formFieldRadius
        
        inviteField.alpha = list == nil ? 0 : 1
        inviteField.frame.size.width = bounds.width - 2*CGFloat.pageMargin - CGFloat.formMargin - inviteButton.frame.width
        inviteField.frame.size.height = CGFloat.formFieldHeight
        inviteField.frame.origin.y = inviteButton.frame.origin.y
        inviteField.frame.origin.x = CGFloat.pageMargin
        
        inviteButton.frame.origin.x = inviteField.frame.maxX + CGFloat.formMargin
        
        let dualFormAvailableWidth: CGFloat = bounds.width - 2 * CGFloat.pageMargin - CGFloat.formMargin
        
//        cancelButton.frame.size.width = dualFormAvailableWidth/2
//        cancelButton.frame.size.height = CGFloat.formFieldHeight
//        cancelButton.frame.origin.x = CGFloat.pageMargin
//        cancelButton.frame.origin.y = bounds.height - cancelButton.frame.height - CGFloat.pageMargin
//        cancelButton.layer.cornerRadius = CGFloat.formFieldRadius
//        
//        addButton.frame.size = cancelButton.frame.size
//        addButton.frame.origin.x = cancelButton.frame.maxX + CGFloat.formMargin
//        addButton.frame.origin.y = cancelButton.frame.origin.y
//        addButton.layer.cornerRadius = CGFloat.formFieldRadius
    }
    
    // MARK: - Selector Methods
    
    func didTapCancelButton() {
        delegate?.shouldStopCreation()
    }
    
    // MARK: - Private Methods
    
    func saveList() {
        if let list = list {
            // TO DO: Update list
        } else {
            let list = List()
            list.name = listNameField.text!
            
            listNameField.resignFirstResponder()
            listNameField.isLoading = true
            
            APIService.createList(list: list, success: { list in
                self.listNameField.isLoading = false
                self.list = list
                self.inviteField.becomeFirstResponder()
            }, failure: { error in
                // TO DO: Helper class de momo pour
            })
        }
    }
    
}

extension CreateListView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text != nil && textField.text != "" && !listNameField.isLoading {
            saveList()
            return true
        }
        
        return false
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension CreateListView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = list else {
            return 0
        }
        return list.involvedUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let list = list else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        cell.separatorView.isHidden = indexPath.row == elements.count-1
        cell.user = list.involvedUsers[indexPath.row]
        return cell
    }
    
}
