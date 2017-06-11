//
//  CategorySelectionCollectionViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-10.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class CategorySelectionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Class Properties
    
    static let reuseIdentifier = "CategorySelectionCollectionViewCellReuseIdentifier"
    
    // MARK: - Properties
    
    var category: Category! {
        didSet {
            imageContainerView.backgroundColor = category.color
            categoryImageView.image = category.image
        }
    }
    
    var isInSelection: Bool = false {
        didSet {
            setNeedsLayout()
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UI Elements
 
    fileprivate lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBlack
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.85
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        clipsToBounds = true
        
        contentView.borderize(width: 1, color: .flatSilver)
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(categoryImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = CGFloat.formFieldRadius
        contentView.layer.borderWidth = isInSelection ? 0 : 1
        
        imageContainerView.frame.size = isInSelection ? CGSize(width: contentView.bounds.width*2, height:contentView.bounds.height*2) : CGSize(width: 50, height: 50)
        imageContainerView.layer.cornerRadius = imageContainerView.frame.height/2//CGFloat.formFieldRadius
        imageContainerView.center.x = contentView.bounds.width/2
        imageContainerView.center.y = contentView.bounds.height/2
        
        categoryImageView.frame.size = CGSize(width: 40, height: 40)
        categoryImageView.center.x = imageContainerView.bounds.width/2
        categoryImageView.center.y = imageContainerView.bounds.height/2 + 10
    }
    
}
