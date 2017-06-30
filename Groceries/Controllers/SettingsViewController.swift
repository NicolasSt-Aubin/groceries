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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatMidnightBlue
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
    
    fileprivate lazy var changePasswordButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .flatMidnightBlue
        return button
    }()
    
    fileprivate lazy var changePasswordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Change password"
        label.font = UIFont.systemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var passwordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.passwordIcon.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.sizeToFit()
        return imageView
    }()
    
    fileprivate lazy var listsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.flatBlack
        label.text = "Lists"
        label.font = UIFont.systemFont(ofSize: 22)
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: self.bigMargin, bottom: 0, right: self.bigMargin)
        layout.minimumInteritemSpacing = self.smallMargin
        layout.minimumLineSpacing = self.smallMargin
        return layout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(CategorySelectionCollectionViewCell.self, forCellWithReuseIdentifier: CategorySelectionCollectionViewCell.reuseIdentifier)
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatCloud
        statusBackgroundView.isHidden = true
        
        view.addSubview(topView)
        topView.addSubview(closeButton)
        topView.addSubview(logoutButton)
        topView.addSubview(userImageView)
        topView.addSubview(userNameField)
        view.addSubview(changePasswordButton)
        changePasswordButton.addSubview(changePasswordLabel)
        changePasswordButton.addSubview(passwordImageView)
        view.addSubview(listsLabel)
        
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
        
        userImageView.frame.size = CGSize(width: 150, height: 150)
        userImageView.frame.origin.y = closeButton.frame.origin.y
        userImageView.center.x = view.bounds.width/2
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        
        userNameField.frame.size.width = topView.bounds.width
        userNameField.frame.origin.y = userImageView.frame.maxY + 20
        userNameField.center.x = topView.bounds.width/2
        
        topView.frame.size.height = userNameField.frame.maxY + bigMargin
        
        changePasswordButton.frame.size.width = view.bounds.size.width
        changePasswordButton.frame.size.height = CGFloat.formFieldHeight
        changePasswordButton.frame.origin.y = topView.frame.maxY + 10
        
        passwordImageView.frame.origin.x = changePasswordButton.bounds.width - passwordImageView.frame.width - bigMargin
        passwordImageView.center.y = changePasswordButton.bounds.height/2
        
        changePasswordLabel.frame.size.width = passwordImageView.frame.minX - bigMargin*2
        changePasswordLabel.frame.origin.x = bigMargin
        changePasswordLabel.center.y = changePasswordButton.bounds.height/2
        
        listsLabel.frame.size.width = view.bounds.width - bigMargin*2
        listsLabel.frame.origin.x = bigMargin
        listsLabel.frame.origin.y = changePasswordButton.frame.maxY + 10
    }

}
