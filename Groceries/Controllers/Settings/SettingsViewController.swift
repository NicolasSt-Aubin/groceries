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
        return .lightContent
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
        
        topView.frame.size.height = userNameField.frame.maxY + bigMargin
        
        collectionView.frame.size.width = view.bounds.width
        collectionView.frame.size.height = view.bounds.height - topView.frame.maxY
        collectionView.frame.origin.y = topView.frame.maxY
    }
    
    // MARK: - Selector methods
    
    func didTapLogoutButton() {
        collectionView.reloadData()
        print(CurrentUserService.shared.userLists.count)
    }

}

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        selectedCategory = categories[indexPath.item]
        //        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        //
        //        for cell in collectionView.visibleCells {
        //            guard let cell = cell as? CategorySelectionCollectionViewCell else {
        //                continue
        //            }
        //
        //            if let category = selectedCategory {
        //                cell.isInSelection = cell.category == category
        //            } else {
        //                cell.isInSelection = false
        //            }
        //        }
    }
    
}
