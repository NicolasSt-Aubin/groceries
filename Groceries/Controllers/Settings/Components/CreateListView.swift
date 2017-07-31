//
//  CreateListView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-07-04.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class CreateListView: UIView {

    // test
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
    
    fileprivate lazy var listNameField: GRTextField = {
        let textField = GRTextField(icon: Asset.addIcon.image)
        textField.returnKeyType = .next
        textField.placeholder = L10n.name
        return textField
    }()
    
    fileprivate lazy var inviteInstructionLabel: UILabel = {
        let label = UILabel.generateInstructionLabel()
        label.text = L10n.inviteFriends.uppercased()
        label.sizeToFit()
        return label
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
        addSubview(inviteField)
        addSubview(inviteButton)
        addSubview(cancelButton)
        addSubview(addButton)
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
        
        inviteInstructionLabel.frame.origin.x = createListLabel.frame.origin.x
        inviteInstructionLabel.frame.origin.y = listNameField.frame.maxY + 20
        
        inviteButton.sizeToFit()
        inviteButton.frame.size.width += 6*CGFloat.formMargin
        inviteButton.frame.size.height = CGFloat.formFieldHeight
        inviteButton.frame.origin.y = inviteInstructionLabel.frame.maxY + CGFloat.formMargin
        inviteButton.layer.cornerRadius = CGFloat.formFieldRadius
        
        inviteField.frame.size.width = bounds.width - 2*CGFloat.pageMargin - CGFloat.formMargin - inviteButton.frame.width
        inviteField.frame.size.height = CGFloat.formFieldHeight
        inviteField.frame.origin.y = inviteButton.frame.origin.y
        inviteField.frame.origin.x = CGFloat.pageMargin
        
        inviteButton.frame.origin.x = inviteField.frame.maxX + CGFloat.formMargin
    }
    
}
