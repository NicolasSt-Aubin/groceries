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
            UIView.animate(withDuration: 0.3) {
                self.imageContainerView.transform = self.isInSelection ? CGAffineTransform(scaleX: 2.5, y: 2.5) : .identity
                self.contentView.layer.borderColor = self.isInSelection ? self.category.color.cgColor : UIColor.flatSilver.cgColor
            }
        }
    }
    
    // MARK: - UI Elements
 
    fileprivate lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBlack
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
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageContainerView)
        contentView.addSubview(categoryImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = CGFloat.formFieldRadius
        contentView.layer.borderColor = isInSelection ? category.color.cgColor : UIColor.flatSilver.cgColor
        
        imageContainerView.frame.size = isInSelection ? CGSize(width: 150, height: 150) : CGSize(width: 50, height: 50)
        imageContainerView.layer.cornerRadius = imageContainerView.frame.height/2
        imageContainerView.center.x = contentView.bounds.width/2
        imageContainerView.center.y = contentView.bounds.height/2
        
        categoryImageView.frame.size = CGSize(width: 40, height: 40)
        categoryImageView.center.x = imageContainerView.center.x
        categoryImageView.center.y = imageContainerView.center.y + 10
    }
    
}
