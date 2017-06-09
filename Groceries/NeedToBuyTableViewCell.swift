//
//  NeedToBuyTableViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-09.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class NeedToBuyTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let reuseIdentifier = "NeedToBuyTableViewCellReuseIdentifier"
    static let height: CGFloat = 70
    
    // MARK: - UI Elements
    
    fileprivate lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatPeterRiver
        return view
    }()
    
    fileprivate lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.dairy.image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.85
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font  = .boldSystemFont(ofSize: 16)
        label.textColor = .flatBlack
        label.text = "Chicken"
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font  = .systemFont(ofSize: 10)
        label.textColor = .flatSilver
        label.text = "15.00$"
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font  = UIFont.systemFont(ofSize: 14)
        label.textColor = .flatSilver
        label.text = " "
        label.sizeToFit()
        return label
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatCloud
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(categoryImageView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(separatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame.size.width = bounds.width 
        contentView.frame.size.height = bounds.height
        contentView.center.x = bounds.width/2
        
        let cellPadding: CGFloat = 20
        let cellMargin: CGFloat = 25
        
        imageContainerView.frame.size = CGSize(width: 40, height: 40)
        imageContainerView.layer.cornerRadius = imageContainerView.frame.height/2
        imageContainerView.frame.origin.x = cellPadding
        imageContainerView.center.y = contentView.bounds.height/2
        
        categoryImageView.frame.size = CGSize(width: 30, height: 30)
        categoryImageView.center.x = imageContainerView.bounds.width/2
        categoryImageView.frame.origin.y = 10
        
        dateLabel.frame.origin.x = contentView.bounds.width - dateLabel.frame.width - cellPadding
        dateLabel.center.y = imageContainerView.center.y
        
        titleLabel.frame.size.width = dateLabel.frame.minX - imageContainerView.frame.maxX - 2 * cellMargin
        titleLabel.frame.origin.x = imageContainerView.frame.maxX + cellMargin
        titleLabel.center.y = imageContainerView.center.y - dateLabel.frame.height/2
        
        priceLabel.frame.size.width = contentView.bounds.width - imageContainerView.frame.maxX - 2 * cellMargin
        priceLabel.frame.origin.x = titleLabel.frame.origin.x
        priceLabel.frame.origin.y = titleLabel.frame.maxY + 5
        
        separatorView.frame.size.width = contentView.bounds.width
        separatorView.frame.size.height = 1
        separatorView.frame.origin.y = contentView.bounds.height - separatorView.frame.height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        separatorView.isHidden = false
    }

}
