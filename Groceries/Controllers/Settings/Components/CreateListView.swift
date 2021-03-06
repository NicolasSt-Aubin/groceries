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
    func presentAlertController(_ alertController: UIAlertController)
}

class CreateListView: UIView {

    // MARK: - Properties
    
    var keyboardHeight: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
    
    var delegate: CreateListViewDelegate? = nil
    
    var list: List? = nil {
        didSet {
            if let list = list {
                listNameField.text = list.name
                listNameField.editingChanged()
                
                doneButton.setTitle(L10n.done, for: .normal)
                doneButton.backgroundColor = .flatBelizeHole
            } else {
                listNameField.clearText()
                
                doneButton.setTitle(L10n.cancel, for: .normal)
                doneButton.backgroundColor = .flatSilver
            }
            
            inviteField.clearText()

            userTableView.reloadData()
            setNeedsLayout()
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
    
    var involvedUsers: [User] {
        if let list = list {
            return list.involvedUsers
        } else {
            return []
        }
    }
    
    var isInviting: Bool {
        return inviteField.isFirstResponder && keyboardHeight > 0
    }
    
    var userTableViewMaxHeight: CGFloat {
        if isInviting {
            return bounds.height - keyboardHeight - 20 - CGFloat.pageMargin*2 - CGFloat.formMargin*4 - CGFloat.formFieldHeight
        } else {
            return bounds.height - 80 - CGFloat.pageMargin - CGFloat.formMargin*3 - CGFloat.formFieldHeight*3 - createListLabel.frame.height - CGFloat.topTitleMargin
        }
    }
    
    var leaveAlertController: UIAlertController {
        let alertController = UIAlertController(title: L10n.leave + " " + list!.name, message: L10n.confirmationQuestion(L10n.leave, list!.name), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        
        let leaveAction = UIAlertAction(title: L10n.leave, style: .destructive, handler: { _ in
            self.leaveList()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(leaveAction)
        
        return alertController
    }
    
    var deleteAlertController: UIAlertController {
        let alertController = UIAlertController(title: L10n.delete + " " + list!.name, message: L10n.confirmationQuestion(L10n.delete, list!.name), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: L10n.delete, style: .destructive, handler: { _ in
            self.deleteList()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        return alertController
    }
    
    var optionAlertController: UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let leaveAction = UIAlertAction(title: L10n.leave, style: .default, handler: { _ in
            self.delegate?.presentAlertController(self.leaveAlertController)
        })
        
        let deleteAction = UIAlertAction(title: L10n.delete, style: .destructive, handler: { _ in
            self.delegate?.presentAlertController(self.deleteAlertController)
        })
        
        let cancelButton = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(leaveAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelButton)
        
        return alertController
    }
    
    // MARK: - UI Elements

    fileprivate lazy var createListLabel: UILabel = {
        let label = UILabel.generateTitleLabel()
        label.text = L10n.manageList
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var optionButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .clear
        button.setImage(Asset.optionsIcon.image, for: .normal)
        button.addTarget(self, action: #selector(self.didTapOptionsButton), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    fileprivate lazy var listNameInstructionLabel: UILabel = {
        let label = UILabel.generateInstructionLabel()
        label.text = L10n.listName.uppercased()
        label.sizeToFit()
        return label
    }()
    
    lazy var listNameField: GRTextField = {
        let textField = GRTextField(icon: Asset.addIcon.image)
        textField.returnKeyType = .send
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
    
    fileprivate lazy var userTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserTableViewCell.classForCoder(), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.borderize(width: 1, color: .flatSilver)
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        return tableView
    }()
    
    fileprivate lazy var inviteField: GRTextField = {
        let textField = GRTextField(icon: Asset.userIcon.image)
        textField.returnKeyType = .send
        textField.placeholder = L10n.email.capitalized
        textField.delegate = self
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    fileprivate lazy var inviteButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.invite, for: .normal)
        return button
    }()
    
    fileprivate lazy var doneButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.done, for: .normal)
        button.addTarget(self, action: #selector(self.didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        addSubview(createListLabel)
        addSubview(optionButton)
        addSubview(listNameInstructionLabel)
        addSubview(listNameField)
        addSubview(inviteInstructionLabel)
        addSubview(userTableView)
        addSubview(inviteField)
        addSubview(doneButton)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignAllSelectors))
        addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createListLabel.alpha = isInviting ? 0 : 1
        createListLabel.frame.origin.y = CGFloat.topTitleMargin
        createListLabel.frame.origin.x = CGFloat.pageMargin
        
        optionButton.alpha = !isInviting && list != nil ? 1 : 0
        optionButton.frame.size.width = 40
        optionButton.frame.size.height = 40
        optionButton.center.y = createListLabel.center.y
        optionButton.frame.origin.x = bounds.width - optionButton.frame.width - CGFloat.pageMargin
        
        listNameInstructionLabel.alpha = isInviting ? 0 : 1
        listNameInstructionLabel.frame.origin.x = createListLabel.frame.origin.x
        listNameInstructionLabel.frame.origin.y = createListLabel.frame.maxY + 20
        
        listNameField.alpha = isInviting ? 0 : 1
        listNameField.frame.size.width = bounds.width - CGFloat.pageMargin*2
        listNameField.frame.size.height = CGFloat.formFieldHeight
        listNameField.frame.origin.x = CGFloat.pageMargin
        listNameField.frame.origin.y = listNameInstructionLabel.frame.maxY + CGFloat.formMargin
        listNameField.layer.cornerRadius = CGFloat.formFieldRadius
        
        inviteInstructionLabel.alpha = list == nil ? 0 : 1
        inviteInstructionLabel.frame.origin.x = createListLabel.frame.origin.x
        inviteInstructionLabel.frame.origin.y = isInviting ? CGFloat.pageMargin + 20 : listNameField.frame.maxY + 20
        
        userTableView.alpha = list == nil ? 0 : 1
        userTableView.frame.size.width = bounds.width - CGFloat.pageMargin*2
        userTableView.frame.size.height = min(CGFloat(involvedUsers.count) * UserTableViewCell.height, userTableViewMaxHeight)
        userTableView.layer.cornerRadius = CGFloat.formFieldRadius
        userTableView.frame.origin.y = inviteInstructionLabel.frame.maxY + CGFloat.formMargin
        userTableView.center.x = bounds.width/2
        
        inviteField.alpha = list == nil ? 0 : 1
        inviteField.frame.size.width = bounds.width - 2*CGFloat.pageMargin //- CGFloat.formMargin - inviteButton.frame.width
        inviteField.frame.size.height = CGFloat.formFieldHeight
        inviteField.frame.origin.y = isInviting ? bounds.height - inviteField.frame.height - CGFloat.pageMargin - keyboardHeight : userTableView.frame.maxY + CGFloat.formMargin
        inviteField.frame.origin.x = CGFloat.pageMargin
        
        doneButton.frame.size.width = bounds.width - CGFloat.pageMargin*2
        doneButton.frame.size.height = CGFloat.formFieldHeight
        doneButton.layer.cornerRadius = CGFloat.formFieldRadius
        doneButton.frame.origin.y = bounds.height - doneButton.frame.height - CGFloat.pageMargin
        doneButton.center.x = bounds.width/2
        
    }
    
    // MARK: - Selector Methods
    
    func didTapDoneButton() {
        delegate?.shouldStopCreation()
    }
    
    func didTapOptionsButton() {
        delegate?.presentAlertController(optionAlertController)
    }
    
    func resignAllSelectors() {
        endEditing(true)
    }
    
    func keyboardWillChangeFrame(_ notification: NSNotification) {
        
        if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = frame.height
        }
        
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = 0
    }
    
    // MARK: - Private Methods
    
    fileprivate func saveList() {
        if let list = list {
            let oldName = list.name

            list.name = listNameField.text!

            listNameField.resignFirstResponder()
            listNameField.isLoading = true
            
            APIService.updateList(list: list, success: { list in
                self.listNameField.isLoading = false
                self.list = list
            }, failure: { error in
                list.name = oldName
                self.listNameField.text = oldName
                self.listNameField.isLoading = false
                Popup.showError(error)
            })
            
        } else {
            let list = List()
            list.name = listNameField.text!
            
            listNameField.resignFirstResponder()
            listNameField.isLoading = true
            
            APIService.createList(list: list, success: { list in
                self.listNameField.isLoading = false
                CurrentUserService.shared.userLists.append(list)
                self.list = list
            }, failure: { error in
                self.listNameField.isLoading = false
                Popup.showError(error)
            })
        }
    }
    
    fileprivate func inviteUserToList() {
        guard let list = list else {
            return
        }
        
        inviteField.isLoading = true
        
        APIService.inviteUser(toList: list, email: inviteField.text!, success: { list in
            self.inviteField.isLoading = false
            self.inviteField.text = ""
            self.list = list
            self.userTableView.scrollToRow(at: IndexPath(row: self.involvedUsers.count-1, section: 0), at: .bottom, animated: true)
        }, failure: { error in
            self.inviteField.isLoading = false
            Popup.showError(error)
        })
    }
    
    fileprivate func leaveList() {
        guard let list = list else {
            return
        }
        
        Popup.showProgress()
        
        APIService.leaveList(list: list, success: {
            Popup.showSuccess()
            if let index = CurrentUserService.shared.userLists.index(where: {secondList in secondList == list}) {
                CurrentUserService.shared.userLists.remove(at: index)
            }
            self.delegate?.shouldStopCreation()
        }, failure: { error in
            Popup.showError(error)
        })
        
    }
    
    fileprivate func deleteList() {
        guard let list = list else {
            return
        }
        
        Popup.showProgress()
        
        APIService.deleteList(list: list, success: { list in
            Popup.showSuccess()
            if let index = CurrentUserService.shared.userLists.index(where: {secondList in secondList == list}) {
                CurrentUserService.shared.userLists.remove(at: index)
            }
            self.delegate?.shouldStopCreation()
        }, failure: { error in
            Popup.showError(error)
        })
        
    }
    
}

extension CreateListView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case listNameField:
            if textField.text != nil && textField.text != "" && !listNameField.isLoading {
                saveList()
                return true
            } else {
                Popup.showError()
                return false
            }
        case inviteField:
            if textField.text != nil && textField.text != "" && !inviteField.isLoading {
                inviteUserToList()
                return true
            } else {
                Popup.showError()
                return false
            }
        default:
            return true
        }

    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension CreateListView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return involvedUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        cell.separatorView.isHidden = indexPath.row == involvedUsers.count-1
        cell.user = involvedUsers[indexPath.row]
        return cell
    }
    
}
