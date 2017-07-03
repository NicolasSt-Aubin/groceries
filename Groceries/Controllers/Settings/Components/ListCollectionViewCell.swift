//
//  ListCollectionViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-07-01.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Class Properties
    
    static let reuseIdentifier = "ListCollectionViewCellReuseIdentifier"
    
    // MARK: - Properties
    
    let maxImagesCount = 3
    
    var list: List! {
        didSet {
            titleLabel.text = list.name.capitalized
            
            for view in imageContainerView.subviews {
                view.removeFromSuperview()
            }
            
            for i in 0..<min(list.involvedUsers.count, maxImagesCount) {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.backgroundColor = .flatSilver
                imageView.image = list.involvedUsers[i].image
                imageView.borderize(width: 2, color: .white)
                imageContainerView.addSubview(imageView)
            }
            
            if list.involvedUsers.count > maxImagesCount {
                let additionnalUsersCount = list.involvedUsers.count - maxImagesCount
                additionnalUserLabel.text = String(additionnalUsersCount) + "+"
                imageContainerView.addSubview(additionnalUserView)
            }
            
            dateLabel.text = "19 juin 2017"
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .flatMidnightBlue
        label.textAlignment = .center
        label.text = " "
        label.sizeToFit()
        return label
    }()

    var imageContainerView: UIView = UIView()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .flatGrey
        label.textAlignment = .center
        label.text = " "
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var additionnalUserView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatSilver
        view.borderize(width: 2, color: .white)
        return view
    }()
    
    fileprivate lazy var additionnalUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = " "
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageContainerView)
        contentView.addSubview(dateLabel)
        
        additionnalUserView.addSubview(additionnalUserLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 20
        
        contentView.layer.cornerRadius = CGFloat.formFieldRadius
        
        titleLabel.frame.size.width = contentView.bounds.width - 2*padding
        titleLabel.center.x = contentView.bounds.width/2
        titleLabel.frame.origin.y = padding
        
        let imageDimension: CGFloat = 50
        
        for i in 0..<imageContainerView.subviews.count {
            imageContainerView.subviews[i].frame.size = CGSize(width: imageDimension, height: imageDimension)
            imageContainerView.subviews[i].frame.origin.x = CGFloat(i) * 18
            imageContainerView.subviews[i].layer.cornerRadius = imageContainerView.subviews[i].frame.height/2
        }
        
        additionnalUserView.frame.size = CGSize(width: imageDimension, height: imageDimension)
        additionnalUserView.frame.origin.x = CGFloat(maxImagesCount) * 18
        additionnalUserView.layer.cornerRadius = additionnalUserView.frame.height/2
        
        additionnalUserLabel.frame.size.width = additionnalUserView.bounds.width
        additionnalUserLabel.center.x = additionnalUserView.bounds.width/2
        additionnalUserLabel.center.y = additionnalUserView.bounds.height/2
        
        if imageContainerView.subviews.count > 0 {
            imageContainerView.frame.size.width = imageContainerView.subviews[imageContainerView.subviews.count - 1].frame.maxX
        } else {
            imageContainerView.frame.size.width = 0
        }
        imageContainerView.frame.size.height = imageDimension
        imageContainerView.center.x = contentView.bounds.width/2
        imageContainerView.center.y = contentView.bounds.height/2
        
        dateLabel.frame.size.width = titleLabel.frame.width
        dateLabel.center.x = titleLabel.center.x
        dateLabel.frame.origin.y = contentView.bounds.height - dateLabel.frame.height - padding
    }
    
    // MARK: 
    
}
