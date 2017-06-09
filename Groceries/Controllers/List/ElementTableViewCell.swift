//
//  ElementTableViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class ElementTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let reuseIdentifier = "ElementTableViewCellReuseIdentifier"
    static let height: CGFloat = 80
    
    // MARK: - UI Elements
    
    fileprivate lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image
        return imageView
    }()

    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .white
        
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}
