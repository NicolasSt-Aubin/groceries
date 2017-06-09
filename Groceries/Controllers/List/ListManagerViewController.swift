//
//  ListManagerViewController.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class ListManagerViewController: BaseViewController {

    // MARK: - UI Elements
    
    fileprivate lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel.generateTitleLabel()
        label.text = "Appart"
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var leftPageButton: GRButton = {
        let button = GRButton()
        button.setTitle("Overview", for: .normal)
        button.setTitleColor(.flatBelizeHole, for: .normal)
        return button
    }()
    
    fileprivate lazy var rightPageButton: GRButton = {
        let button = GRButton()
        button.setTitle("Need to buy", for: .normal)
        button.setTitleColor(.flatBlack, for: .normal)
        return button
    }()
    
    fileprivate lazy var pageSelectionIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBelizeHole
        return view
    }()
    
    fileprivate lazy var searchAddTextField: UITextField = {
        let textField = UITextField.generateGRTextField()
//        textField.delegate = self
        textField.returnKeyType = .done
        textField.placeholder = "Milk, chicken, juice..."
        return textField
    }()
    
    fileprivate lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(LeftListCollectionViewCell.self, forCellWithReuseIdentifier: LeftListCollectionViewCell.reuseIdentifier)
        collectionView.register(RightListCollectionViewCell.self, forCellWithReuseIdentifier: RightListCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatCloud
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(leftPageButton)
        headerView.addSubview(rightPageButton)
        headerView.addSubview(pageSelectionIndicatorView)
        
        view.addSubview(searchAddTextField)
        view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        titleLabel.frame.origin.y = 30
        titleLabel.center.x = view.bounds.width/2
        
        leftPageButton.frame.size.width = view.bounds.width/2
        leftPageButton.frame.size.height = 40
        leftPageButton.frame.origin.x = 0
        leftPageButton.frame.origin.y = titleLabel.frame.maxY + 20
        
        rightPageButton.frame.size = leftPageButton.frame.size
        rightPageButton.frame.origin.x = leftPageButton.frame.maxX
        rightPageButton.frame.origin.y = leftPageButton.frame.origin.y
        
        pageSelectionIndicatorView.frame.size.width = leftPageButton.titleLabel!.frame.size.width
        pageSelectionIndicatorView.frame.size.height = 3
        pageSelectionIndicatorView.frame.origin.y = leftPageButton.frame.maxY
        pageSelectionIndicatorView.center.x = leftPageButton.center.x
        pageSelectionIndicatorView.layer.cornerRadius = pageSelectionIndicatorView.frame.height/2
        
        headerView.frame.size.width = view.bounds.width
        headerView.frame.size.height = pageSelectionIndicatorView.frame.maxY + 1
        
        searchAddTextField.frame.size.width = view.bounds.width - 2 * CGFloat.pageMargin
        searchAddTextField.frame.size.height = CGFloat.formFieldHeight
        searchAddTextField.center.x = view.bounds.width/2
        searchAddTextField.frame.origin.y = headerView.frame.maxY + CGFloat.pageMargin
        searchAddTextField.layer.cornerRadius = CGFloat.formFieldRadius
        
        collectionView.frame.size.width = view.bounds.width
        collectionView.frame.size.height = view.bounds.height - searchAddTextField.frame.maxY - CGFloat.pageMargin
        collectionView.frame.origin.y = searchAddTextField.frame.maxY + CGFloat.pageMargin
    }
    
    // MARK: - Private Methods
    
    fileprivate func updatePagingLayout() {
        
        // Calculate progress
        
        var progress = collectionView.contentOffset.x / collectionView.frame.width
        
        if progress < 0 { progress = 0 }
        if progress > 1 { progress = 1 }
        
        // Update selection line position
        
        let leftPosition = leftPageButton.center.x
        let rightPosition = rightPageButton.center.x
        let distance = rightPosition - leftPosition
        
        pageSelectionIndicatorView.center.x = leftPosition + distance * progress
      
        // Update selection line width
        
        let leftWidth = leftPageButton.titleLabel!.frame.width
        let rightWidth = rightPageButton.titleLabel!.frame.width
        let widthDifference = rightWidth - leftWidth
        
        pageSelectionIndicatorView.frame.size.width = leftWidth + widthDifference * progress
    }

}

extension ListManagerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePagingLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: LeftListCollectionViewCell.reuseIdentifier, for: indexPath)
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: RightListCollectionViewCell.reuseIdentifier, for: indexPath)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}
