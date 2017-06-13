//
//  NeedToBuyTableViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-09.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol NeedToBuyTableViewCellDelegate {
    func didSwipeCell(withElement element: Element)
}

class NeedToBuyTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let reuseIdentifier = "NeedToBuyTableViewCellReuseIdentifier"
    static let height: CGFloat = 70
    
    // MARK: - Properties
    
    var delegate: NeedToBuyTableViewCellDelegate? = nil
    
    var element: Element! {
        didSet {
            
            contentView.isHidden = false
            checkButton.element = element
            titleLabel.text = element.name
            
            if let price = element.price {
                priceLabel.text = String(format: "%.2f", price) + " $"
                titleLabel.center.y = checkButton.center.y - titleLabel.frame.height/3
            } else {
                priceLabel.text = " "
                titleLabel.center.y = checkButton.center.y
            }
            
        }
    }
    
    // MARK: - UI Elements
    
    lazy var checkButton: CheckButton = {
        let button = CheckButton(mainImage: Asset.dairy.image)
        button.backgroundColor = .flatBlack
        return button
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font  = .boldSystemFont(ofSize: 14)
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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(separatorView)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didPanContentView(_:)))
        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(panGestureRecognizer)
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
        
        titleLabel.frame.size.width = contentView.bounds.width - checkButton.frame.width - 2 * cellPadding - cellMargin
        titleLabel.frame.origin.x = cellPadding
        if let price = element.price {
            titleLabel.center.y = checkButton.center.y - titleLabel.frame.height/3
        } else {
            titleLabel.center.y = checkButton.center.y
        }
        
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
    
    // MARK: - Selector Methods
    
    var initialPanPosition: CGFloat = CGFloat.pageMargin
    
    func didPanContentView(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            initialPanPosition = contentView.frame.origin.x
        }
        
        let xTranslation = gestureRecognizer.translation(in: self).x
        let xVelocity = gestureRecognizer.velocity(in: self).x
        
        if initialPanPosition + xTranslation <= 0 {
            contentView.frame.origin.x = initialPanPosition + xTranslation
        }
        
//        let progress = contentView.frame.origin.x / bounds.width
//        instructionLabel.alpha = progress
        
        if gestureRecognizer.state == .ended {
            completeSwipeAnimation(xVelocity: xVelocity)
        }
        
    }
    
    // MARK: Private Methods
    
    func completeSwipeAnimation(xVelocity: CGFloat) {
        
        let completeSwipe = xVelocity < -500 || (contentView.frame.origin.x < bounds.width/2 && xVelocity < 0)
        
        let finalPosition: CGFloat = -(bounds.width + CGFloat.pageMargin)
        let initialPosition: CGFloat = 0
        
        var speedConefficient = 1 / (abs(xVelocity) / 200)
        
        if speedConefficient > 1 { speedConefficient = 1 }
        if speedConefficient < 1/4 { speedConefficient = 1/4 }
        
        let duration: TimeInterval = 0.3 * Double(speedConefficient)
        
        UIView.animate(withDuration: duration, animations: {
            self.contentView.frame.origin.x = completeSwipe ? finalPosition : initialPosition
//            self.instructionLabel.alpha = completeSwipe ? 1 : 0
        }, completion: { complete in
            if completeSwipe {
                self.contentView.isHidden = true
                self.delegate?.didSwipeCell(withElement: self.element)
            }
        })
        
    }

}

extension NeedToBuyTableViewCell {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            if gestureRecognizer.velocity(in: self).x > 0 {
                return false
            }
        }
        return true
    }
    
    
}
