//
//  CategorySelectionView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-10.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class CategorySelectionView: UIView {

    // MARK: - Class Properties 
    
    var categories: [Category] = TempDataService.categories // TEMP
    
    // MARK: - Properties
    
    var selectedCategory: Category? = nil
    
    // MARK: - UI Elements
    
    fileprivate lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: CGFloat.pageMargin, bottom: 0, right: CGFloat.pageMargin)
        layout.minimumInteritemSpacing = CGFloat.formMargin
        layout.minimumLineSpacing = CGFloat.formMargin
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(CategorySelectionCollectionViewCell.self, forCellWithReuseIdentifier: CategorySelectionCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
    
    // MARK: - Public Methods
    
    func reset() {
        selectedCategory = nil
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
    }
    
}

extension CategorySelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySelectionCollectionViewCell.reuseIdentifier, for: indexPath) as! CategorySelectionCollectionViewCell
        cell.category = categories[indexPath.item]
        if let category = selectedCategory {
            cell.isInSelection = categories[indexPath.item] == category
        } else {
            cell.isInSelection = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.height, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        for cell in collectionView.visibleCells {
            guard let cell = cell as? CategorySelectionCollectionViewCell else {
                continue
            }
            
            if let category = selectedCategory {
                cell.isInSelection = cell.category == category
            } else {
                cell.isInSelection = false
            }
        }
    }
    
}
