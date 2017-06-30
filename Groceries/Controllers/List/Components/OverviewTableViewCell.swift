//
//  ElementTableViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol OverviewTableViewCellDelegate {
    func restartActivationProcess(forElement element: Element)
    func completeActivationProcess(forElement element: Element)
}

class OverviewTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let reuseIdentifier = "OverviewTableViewCellReuseIdentifier"
    static let height: CGFloat = 90
    
    // MARK: - Properties
    
    var delegate: OverviewTableViewCellDelegate? = nil
    
    var element: Element! {
        didSet {
            imageContainerView.backgroundColor = element.category.color
            categoryImageView.image = element.category.image
            titleLabel.text = element.name
            contentView.isHidden = element.active || element.activationTimer != nil
            if let price = element.price {
                priceLabel.text = String(format: "%.2f", price) + " $"
                titleLabel.center.y = imageContainerView.center.y - dateLabel.frame.height/2
            } else {
                priceLabel.text = " "
                titleLabel.center.y = imageContainerView.center.y
            }
            quantitySelectionView.quantity = element.desiredQuantity
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var underView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var quantitySelectionView: QuantitySelectionView = {
        let quantitySelectionView = QuantitySelectionView()
        quantitySelectionView.delegate = self
        return quantitySelectionView
    }()
    
    fileprivate lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.checkIcon.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .flatGrey
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var completeSwipeButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .white
        button.borderize(width: 1, color: .flatSilver)
        button.addTarget(self, action: #selector(self.didTapCompleteSwipeButton), for: .touchUpInside)
        return button
    }()
    
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
        
        
        addSubview(underView)
        sendSubview(toBack: underView)
        underView.addSubview(quantitySelectionView)
        underView.addSubview(completeSwipeButton)
        completeSwipeButton.addSubview(checkImageView)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(categoryImageView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)
        
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
        
        quantitySelectionView.frame.size = CGSize(width: bounds.width/2, height: bounds.height/2)
        
        completeSwipeButton.frame.size = CGSize(width: quantitySelectionView.frame.height, height: quantitySelectionView.frame.height)
        completeSwipeButton.frame.origin.x = quantitySelectionView.frame.maxX + CGFloat.formMargin
        
        checkImageView.frame.size = CGSize(width: 10, height: 10)
        checkImageView.center = CGPoint(x: completeSwipeButton.bounds.width/2, y: completeSwipeButton.bounds.height/2)

        underView.frame.size.height = quantitySelectionView.frame.height
        underView.frame.size.width = completeSwipeButton.frame.maxX
        underView.center.y = bounds.height/2
        underView.center.x = bounds.width/2
        
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
    
    // MARK: - Selector Methods

    var initialPanPosition: CGFloat = CGFloat.pageMargin
    
    func didPanContentView(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            initialPanPosition = contentView.frame.origin.x
        }
        
        let xTranslation = gestureRecognizer.translation(in: self).x
        let xVelocity = gestureRecognizer.velocity(in: self).x
        
        if initialPanPosition + xTranslation >= CGFloat.pageMargin {
            contentView.frame.origin.x = initialPanPosition + xTranslation
        }
        
        let progress = contentView.frame.origin.x / bounds.width
        quantitySelectionView.alpha = progress
        
        if gestureRecognizer.state == .ended {
            completeSwipeAnimation(xVelocity: xVelocity)
        }
        
    }
    
    func didTapCompleteSwipeButton() {
        delegate?.completeActivationProcess(forElement: element)
    }
    
    // MARK: Private Methods
    
    func completeSwipeAnimation(xVelocity: CGFloat) {
        
        let completeSwipe = xVelocity > 500 || (contentView.frame.origin.x > bounds.width/2 && xVelocity > 0)
        
        let finalPosition = bounds.width + CGFloat.pageMargin
        let initialPosition = CGFloat.pageMargin
        
        var speedConefficient = 1 / (abs(xVelocity) / 200)
        
        if speedConefficient > 1 { speedConefficient = 1 }
        if speedConefficient < 1/4 { speedConefficient = 1/4 }
        
        let duration: TimeInterval = 0.3 * Double(speedConefficient)
        
        UIView.animate(withDuration: duration, animations: {
            self.contentView.frame.origin.x = completeSwipe ? finalPosition : initialPosition
            self.quantitySelectionView.alpha = completeSwipe ? 1 : 0
        }, completion: { complete in
            if completeSwipe {
                self.contentView.isHidden = true
                self.delegate?.restartActivationProcess(forElement: self.element)
            }
        })
        
    }
    
}

// MARK: - Pan Gesture Delegate

extension OverviewTableViewCell {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            if gestureRecognizer.velocity(in: self).x < 0 {
                return false
            }
            if abs(gestureRecognizer.velocity(in: self).y) > abs(gestureRecognizer.velocity(in: self).x) {
                return false
            }
        }
        return true
    }
    
}

// MARK: - QuantitySelectionViewDelegate

extension OverviewTableViewCell: QuantitySelectionViewDelegate {
    
    func didUpdateQuantity() {
        element.desiredQuantity = quantitySelectionView.quantity
        delegate?.restartActivationProcess(forElement: element)
    }
    
}
