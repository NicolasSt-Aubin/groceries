//
//  QuantitySelectionView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-19.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol QuantitySelectionViewDelegate {
    func didUpdateQuantity()
}

class QuantitySelectionView: UIView {

    // MARK: - Properties
    
    let minValue: Int = 1
    
    var delegate: QuantitySelectionViewDelegate? = nil
    
    var quantity: Int = 1 {
        didSet {
            if quantity < minValue {
                quantity = minValue
            }
            minusButton.isEnabled = quantity > minValue
            quantityLabel.text = String(quantity)
            //TO DO find a way to reset timer
        }
    }
    
    var isVertical: Bool { return frame.height > frame.width }
    
    // MARK: - UI Elements
    
    fileprivate lazy var minusButton: GRButton = {
        let button = GRButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.flatGrey, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 0
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.didTapMinusButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var leftSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatSilver
        return view
    }()
    
    fileprivate lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.text = String(self.quantity)
        label.textColor = .flatGrey
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var rightSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatSilver
        return view
    }()
    
    fileprivate lazy var plusButton: GRButton = {
        let button = GRButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.flatGrey, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(self.didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        borderize(width: 1, color: .flatSilver)
        backgroundColor = .white
        
        addSubview(minusButton)
        addSubview(leftSeparatorView)
        addSubview(quantityLabel)
        addSubview(rightSeparatorView)
        addSubview(plusButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = CGFloat.formFieldRadius
        
        minusButton.frame.size.width = isVertical ? bounds.width : bounds.width/3
        minusButton.frame.size.height = isVertical ? bounds.height/3 : bounds.height
        minusButton.frame.origin = .zero
        
        leftSeparatorView.frame.size.width = isVertical ? bounds.width : 1
        leftSeparatorView.frame.size.height = isVertical ? 1 : bounds.height
        leftSeparatorView.frame.origin.x = isVertical ? 0 : minusButton.frame.maxX - leftSeparatorView.frame.width/2
        leftSeparatorView.frame.origin.y = isVertical ? minusButton.frame.maxY - leftSeparatorView.frame.height/2 : 0
        
        quantityLabel.frame.size = minusButton.frame.size
        quantityLabel.frame.origin.x = isVertical ? 0 : minusButton.frame.maxX
        quantityLabel.frame.origin.y = isVertical ? minusButton.frame.maxY : 0
        
        rightSeparatorView.frame.size = leftSeparatorView.frame.size
        rightSeparatorView.frame.origin.x = isVertical ? 0 : quantityLabel.frame.maxX - leftSeparatorView.frame.width/2
        rightSeparatorView.frame.origin.y = isVertical ? quantityLabel.frame.maxY - leftSeparatorView.frame.height/2 : 0
        
        plusButton.frame.size = minusButton.frame.size
        plusButton.frame.origin.x = isVertical ? 0 : quantityLabel.frame.maxX
        plusButton.frame.origin.y = isVertical ? quantityLabel.frame.maxY : 0
    }
    
    // MARK: - Selector Methods
    
    func didTapMinusButton() {
        quantity -= 1
        delegate?.didUpdateQuantity()
    }
    
    func didTapPlusButton() {
        quantity += 1
        delegate?.didUpdateQuantity()
    }

}
