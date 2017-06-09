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
    
    // MARK: - Properties
    
    var checked: Bool = false 
    
    // MARK: - UI Elements
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .flatPeterRiver
        return button
    }()
    
    fileprivate lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.dairy.image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.85
        return imageView
    }()
    
    fileprivate lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.checkIcon.image
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
        
        contentView.addSubview(checkButton)
        checkButton.addSubview(categoryImageView)
        checkButton.addSubview(checkImageView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
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
        let cellMargin: CGFloat = 25
        
        checkButton.frame.size = CGSize(width: 40, height: 40)
        checkButton.layer.cornerRadius = checkButton.frame.height/2
        checkButton.frame.origin.x = contentView.bounds.width - checkButton.frame.width - cellPadding
        checkButton.center.y = contentView.bounds.height/2
        
        categoryImageView.frame.size.width = checked ? 0 : 30
        categoryImageView.frame.size.height = checked ? 0 : 30
        categoryImageView.center.x = checkButton.bounds.width/2
        categoryImageView.frame.origin.y = 10
        
        checkImageView.frame.size.width = checked ? 15 : 0
        checkImageView.frame.size.height = checked ? 15 : 0
        checkImageView.center.x = checkButton.bounds.width/2
        checkImageView.center.y = checkButton.bounds.height/2
        
        titleLabel.frame.size.width = contentView.bounds.width - checkButton.frame.width - 2 * cellPadding - cellMargin
        titleLabel.frame.origin.x = cellPadding
        titleLabel.center.y = checkButton.center.y - titleLabel.frame.height/3
        
        priceLabel.frame.size.width = titleLabel.frame.width
        priceLabel.frame.origin.x = titleLabel.frame.origin.x
        priceLabel.frame.origin.y = titleLabel.frame.maxY + 3
        
        separatorView.frame.size.width = contentView.bounds.width
        separatorView.frame.size.height = 1
        separatorView.frame.origin.y = contentView.bounds.height - separatorView.frame.height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        separatorView.isHidden = false
    }
    
    // MARK: - Public Methods
    
    func animateSelection() {

        backgroundColor = .red
        
        UIView.animate(withDuration: 0.3, animations: {
        
            self.categoryImageView.frame.size.width = 0
            self.categoryImageView.frame.size.height = 0
            
        }, completion: { completed in
            
            UIView.animate(withDuration: 0.3, animations: { 
                
                self.checkImageView.frame.size.width = 15
                self.checkImageView.frame.size.height = 15
                
            }, completion: { completed in
            
            })

        })
        
    }
    
    func animateUnselection() {
        print("shoudl animate unselection")
        if !checked {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.checkImageView.frame.size.width = 0
                self.checkImageView.frame.size.height = 0
                
            }, completion: { completed in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.categoryImageView.frame.size.width = 15
                    self.categoryImageView.frame.size.height = 15
                    
                }, completion: { completed in
                    
                })
                
            })
            
        }
        
    }

}
