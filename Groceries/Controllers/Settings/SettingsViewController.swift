//
//  ProfileViewController.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-27.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    // MARK: - Properties
    
    let bigMargin: CGFloat = 20
    let smallMargin: CGFloat = 10
    
    var isInCreationMode: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatMidnightBlue
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var closeButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .clear
        button.setImage(Asset.clearIcon.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.sizeToFit()
        return button
    }()
    
    fileprivate lazy var logoutButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .clear
        button.setImage(Asset.logoutIcon.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.didTapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.borderize(width: 5, color: .white)
        return imageView
    }()
    
    fileprivate lazy var userNameField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 26)
        textField.textAlignment = .center
        textField.textColor = .white
        textField.tintColor = .white
        textField.text = " "
        textField.sizeToFit()
        textField.text = ""
        return textField
    }()
    
    fileprivate lazy var createListView: CreateListView = {
        let createListView = CreateListView()
        return createListView
    }()
    
    fileprivate lazy var actionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var updateUserButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .clear
        button.setTitleColor(.flatMidnightBlue, for: .normal)
        button.setTitle("Update User", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(self.enterUpdateUserMode), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var verticalSeperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .flatMidnightBlue
        return view
    }()
    
    fileprivate lazy var createListButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .clear
        button.setTitleColor(.flatMidnightBlue, for: .normal)
        button.setTitle("Create List", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(self.enterListCreationMode), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: self.bigMargin, left: self.bigMargin, bottom: self.bigMargin, right: self.bigMargin)
        layout.minimumInteritemSpacing = self.smallMargin
        layout.minimumLineSpacing = self.smallMargin
        return layout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatCloud
        statusBackgroundView.backgroundColor = .flatMidnightBlue
        
        view.addSubview(topView)
        topView.addSubview(closeButton)
        topView.addSubview(logoutButton)
        topView.addSubview(userImageView)
        topView.addSubview(userNameField)
        view.addSubview(createListView)
        view.addSubview(actionView)
        actionView.addSubview(updateUserButton)
        actionView.addSubview(verticalSeperatorLine)
        actionView.addSubview(createListButton)
        view.addSubview(collectionView)
        
        // TEMP
        userImageView.image = Asset.misterT.image
        userNameField.text = "Mister T"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        topView.frame.size.width = view.bounds.width
        topView.frame.origin.y = 20
        
        closeButton.frame.origin = CGPoint(x: bigMargin, y: bigMargin)
        
        logoutButton.frame.origin.x = topView.bounds.width - bigMargin - logoutButton.frame.width
        logoutButton.frame.origin.y = closeButton.frame.origin.y
        
        userImageView.frame.size = CGSize(width: 130, height: 130)
        userImageView.frame.origin.y = closeButton.frame.origin.y
        userImageView.center.x = view.bounds.width/2
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        
        userNameField.frame.size.width = topView.bounds.width
        userNameField.frame.origin.y = userImageView.frame.maxY + 20
        userNameField.center.x = topView.bounds.width/2
        
        topView.frame.size.height = isInCreationMode ? 0 : userNameField.frame.maxY + bigMargin
        
        actionView.alpha = isInCreationMode ? 0 : 1
        actionView.frame.size.width = view.bounds.width
        actionView.frame.size.height = CGFloat.formFieldHeight
        actionView.frame.origin.y = topView.frame.maxY
        
        createListView.alpha = isInCreationMode ? 1: 0
        createListView.frame = view.bounds
        
        updateUserButton.frame.size.width = actionView.bounds.width/2
        updateUserButton.frame.size.height = actionView.bounds.height
        
        verticalSeperatorLine.frame.size.width = 1
        verticalSeperatorLine.frame.size.height = actionView.bounds.height*2/3
        verticalSeperatorLine.center.x = actionView.bounds.width/2
        verticalSeperatorLine.center.y = actionView.bounds.height/2
        
        createListButton.frame.size = updateUserButton.frame.size
        createListButton.frame.origin.x = updateUserButton.frame.maxX
        
        collectionView.alpha = isInCreationMode ? 0 : 1
        collectionView.frame.size.width = view.bounds.width
        collectionView.frame.size.height = view.bounds.height - actionView.frame.maxY
        collectionView.frame.origin.y = actionView.frame.maxY
    }
    
    // MARK: - Selector methods
    
    func didTapLogoutButton() {
        collectionView.reloadData()
    }
    
    func enterListCreationMode() {
        isInCreationMode = true
        view.setNeedsLayout()
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func enterUpdateUserMode() {
        isInCreationMode = false
        view.setNeedsLayout()
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentUserService.shared.userLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as! ListCollectionViewCell
        cell.list = CurrentUserService.shared.userLists[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let dimension = (collectionView.bounds.width - bigMargin*2 - smallMargin)/2
        return CGSize(width: dimension, height: dimension)
    }
    
}
