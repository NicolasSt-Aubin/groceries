//
//  QuantityIndicatorView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-16.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class QuantityIndicatorSelectionView: UIView {

    // MARK: - Properties
    
    var selectedQuantityIndicator: QuantityIndicator = .unit {
        didSet {
            print("allo coucou")
            UIView.animate(withDuration: 0.2) {
                self.updateSelectionLayout()
            }
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .flatGrey
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = L10n.selectQuantityIndicator.uppercased()
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var unitButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .white
        button.borderize(width: 1, color: .flatSilver)
        button.setTitleColor(.flatGrey, for: .normal)
        button.setTitle(" /" + QuantityIndicator.unit.title, for: .normal)
        button.addTarget(self, action: #selector(self.didTapUnitButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var kgButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .white
        button.borderize(width: 1, color: .flatSilver)
        button.setTitleColor(.flatGrey, for: .normal)
        button.setTitle(" /" + QuantityIndicator.kg.title, for: .normal)
        button.addTarget(self, action: #selector(self.didTapKgButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var lbsButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .white
        button.borderize(width: 1, color: .flatSilver)
        button.setTitleColor(.flatGrey, for: .normal)
        button.setTitle(" /" + QuantityIndicator.lbs.title, for: .normal)
        button.addTarget(self, action: #selector(self.didTapLbsButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        addSubview(instructionLabel)
        addSubview(unitButton)
        addSubview(kgButton)
        addSubview(lbsButton)
        
        updateSelectionLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        instructionLabel.frame.size.width = bounds.width - CGFloat.pageMargin*2
        instructionLabel.frame.origin.x = CGFloat.pageMargin
        
        let buttonWidth = (bounds.width - CGFloat.pageMargin*2 - CGFloat.formMargin*2)/3
        let buttonSize = CGSize(width: buttonWidth, height:35)
        
        unitButton.frame.size = buttonSize
        unitButton.frame.origin.x = instructionLabel.frame.origin.x
        unitButton.frame.origin.y = instructionLabel.frame.maxY + CGFloat.formMargin
        
        kgButton.frame.size = buttonSize
        kgButton.frame.origin.x = unitButton.frame.maxX + CGFloat.formMargin
        kgButton.frame.origin.y = unitButton.frame.origin.y
        
        lbsButton.frame.size = buttonSize
        lbsButton.frame.origin.x = kgButton.frame.maxX + CGFloat.formMargin
        lbsButton.frame.origin.y = unitButton.frame.origin.y
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
        frame.size.height = unitButton.frame.maxY
    }
    
    // MARK: - Selector Methods
    
    func didTapUnitButton() {
        selectedQuantityIndicator = .unit
    }
    
    func didTapKgButton() {
        selectedQuantityIndicator = .kg
        print("asdkjfhaslkjh")
    }
    
    func didTapLbsButton() {
        selectedQuantityIndicator = .lbs
    }
    
    // MARK: - Private Methods

    fileprivate func updateSelectionLayout() {
        unitButton.layer.borderColor = selectedQuantityIndicator == .unit ? UIColor.flatBelizeHole.cgColor : UIColor.flatSilver.cgColor
        unitButton.backgroundColor = selectedQuantityIndicator == .unit ? .flatBelizeHole : .white
        let unitTitleColor: UIColor = selectedQuantityIndicator == .unit ? .white : .flatSilver
        unitButton.setTitleColor(unitTitleColor, for: .normal)
        
        kgButton.layer.borderColor = selectedQuantityIndicator == .kg ? UIColor.flatBelizeHole.cgColor : UIColor.flatSilver.cgColor
        kgButton.backgroundColor = selectedQuantityIndicator == .kg ? .flatBelizeHole : .white
        let kgTitleColor: UIColor = selectedQuantityIndicator == .kg ? .white : .flatSilver
        kgButton.setTitleColor(kgTitleColor, for: .normal)
        
        lbsButton.layer.borderColor = selectedQuantityIndicator == .lbs ? UIColor.flatBelizeHole.cgColor : UIColor.flatSilver.cgColor
        lbsButton.backgroundColor = selectedQuantityIndicator == .lbs ? .flatBelizeHole : .white
        let lbsTitleColor: UIColor = selectedQuantityIndicator == .lbs ? .white : .flatSilver
        lbsButton.setTitleColor(lbsTitleColor, for: .normal)
    }
    
}
