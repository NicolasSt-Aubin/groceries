//
//  UserTableViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-08-22.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let reuseIdentifier = "UserTableViewCellReuseIdentifier"
    static let height: CGFloat = 70
    
    // MARK: - Properties
    
    var user: User {
        didSet {
            nameLabel.text = user.name
            emailLabel.text = user.email
        }
    }
    
    // MARK: - UI Elements
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .flatSilver
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font  = .boldSystemFont(ofSize: 14)
        label.textColor = .flatBlack
        label.text = "Mr T."
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font  = .systemFont(ofSize: 10)
        label.textColor = .flatSilver
        label.text = "15.00$"
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
        
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
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
        
        let cellPadding: CGFloat = 30
        let cellMargin: CGFloat = 10
        
        userImageView.frame.size = CGSize(width: 40, height: 40)
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.frame.origin.x = cellPadding
        userImageView.center.y = contentView.bounds.height/2
        
        nameLabel.frame.size.width = contentView.bounds.width - userImageView.frame.maxX - cellMargin
        nameLabel.frame.origin.x = userImageView.frame.maxX + cellMargin
        nameLabel.center.y = userImageView.center.y - nameLabel.frame.height/3
        
        emailLabel.frame.size.width = emailLabel.frame.width
        emailLabel.frame.origin.x = emailLabel.frame.origin.x
        emailLabel.frame.origin.y = emailLabel.frame.maxY + 3
        
        separatorView.frame.size.width = contentView.bounds.width
        separatorView.frame.size.height = 1
        separatorView.frame.origin.y = contentView.bounds.height - separatorView.frame.height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        separatorView.isHidden = false
    }

}
