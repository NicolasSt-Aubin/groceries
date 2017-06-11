//
//  ElementTableViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let reuseIdentifier = "OverviewTableViewCellReuseIdentifier"
    static let height: CGFloat = 90
    
    // MARK: - Properties
    
    var element: Element! {
        didSet {
            imageContainerView.backgroundColor = element.category.color
            categoryImageView.image = element.category.image
            titleLabel.text = element.name
            if let price = element.price {
                priceLabel.text = String(format: "%.2f", price) + " $"
                titleLabel.center.y = imageContainerView.center.y - dateLabel.frame.height/2
            } else {
                priceLabel.text = " "
                titleLabel.center.y = imageContainerView.center.y
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
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font  = .boldSystemFont(ofSize: 16)
        label.textColor = .flatBlack
        label.text = " "
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font  = .systemFont(ofSize: 10)
        label.textColor = .flatSilver
        label.text = " "
        label.sizeToFit()
        return label
    }()

    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font  = UIFont.systemFont(ofSize: 14)
        label.textColor = .flatSilver
        label.text = "11 jun"
        label.sizeToFit()
        return label
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame.size.width = bounds.width - CGFloat.pageMargin*2
        contentView.frame.size.height = bounds.height - CGFloat.pageMargin
        contentView.center.x = bounds.width/2
        contentView.layer.cornerRadius = CGFloat.formFieldRadius
        
        let cellPadding: CGFloat = 20
        let cellMargin: CGFloat = 25
        
        imageContainerView.frame.size = CGSize(width: 50, height: 50)
        imageContainerView.layer.cornerRadius = imageContainerView.frame.height/2
        imageContainerView.frame.origin.x = cellPadding
        imageContainerView.center.y = contentView.bounds.height/2
        
        categoryImageView.frame.size = CGSize(width: 40, height: 40)
        categoryImageView.center.x = imageContainerView.bounds.width/2
        categoryImageView.frame.origin.y = imageContainerView.bounds.height - categoryImageView.frame.height + 5
        
        dateLabel.frame.origin.x = contentView.bounds.width - dateLabel.frame.width - cellPadding
        dateLabel.center.y = imageContainerView.center.y
        
        titleLabel.frame.size.width = dateLabel.frame.minX - imageContainerView.frame.maxX - 2 * cellMargin
        titleLabel.frame.origin.x = imageContainerView.frame.maxX + cellMargin
        if element.price != nil {
            titleLabel.center.y = imageContainerView.center.y - dateLabel.frame.height/2
        } else {
            titleLabel.center.y = imageContainerView.center.y
        }
        
        priceLabel.frame.size.width = contentView.bounds.width - imageContainerView.frame.maxX - 2 * cellMargin
        priceLabel.frame.origin.x = titleLabel.frame.origin.x
        priceLabel.frame.origin.y = titleLabel.frame.maxY + 5

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}
