//
//  NeedToBuyTableHeaderView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-09.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class NeedToBuyTableHeaderView: UITableViewHeaderFooterView {

    // MARKL - Class Properties
    
    static let reuseIdentifier: String = "NeedToBuyTableHeaderViewReuseIdentifier"
    static let height: CGFloat = 40
    
    // MARK: - Properties
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .flatBlack
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = " "
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatCloud
        return view
    }()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        
        let padding: CGFloat = 20
        
        titleLabel.frame.size.width = contentView.bounds.width - 2 * padding
        titleLabel.frame.origin.x = padding
        titleLabel.center.y = contentView.bounds.height/2
        
        separatorView.frame.size.width = contentView.bounds.width
        separatorView.frame.size.height = 1
        separatorView.frame.origin.y = contentView.bounds.height - separatorView.frame.height
    }
    
}
