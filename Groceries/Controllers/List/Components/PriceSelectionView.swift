//
//  PriceSelectionView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-10.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class PriceSelectionView: UIView {

    // MARK: - Properties
    
    var selectedCategory: Category? = nil
    
    // MARK: - UI Elements
    
    fileprivate lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .flatSilver
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = L10n.selectPrice.uppercased()
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = UIColor.flatBelizeHole
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(self.editingDidBegin), for: .touchDown)
        slider.addTarget(self, action: #selector(self.didDragSlider), for: .touchDragInside)
        slider.addTarget(self, action: #selector(self.didDragSlider), for: .touchDragOutside)
        slider.addTarget(self, action: #selector(self.editingDidEnd), for: .touchUpInside)
        slider.addTarget(self, action: #selector(self.editingDidEnd), for: .touchUpOutside)
        slider.sizeToFit()
        return slider
    }()
    
    fileprivate lazy var valueIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.borderize(width: 1, color: .flatSilver)
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        addSubview(instructionLabel)
        addSubview(valueIndicatorView)
        addSubview(slider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        instructionLabel.frame.size.width = bounds.width - CGFloat.pageMargin*2
        instructionLabel.frame.origin.x = CGFloat.pageMargin
        
        slider.frame.size.width = instructionLabel.frame.width
        slider.frame.origin.x = instructionLabel.frame.origin.x
        slider.frame.origin.y = bounds.height - slider.frame.height
        
        valueIndicatorView.layer.cornerRadius = CGFloat.formFieldRadius
        valueIndicatorView.frame.size.height = 20
        valueIndicatorView.frame.origin.y = slider.frame.minY - valueIndicatorView.frame.height - CGFloat.formMargin
    }
    
    // MARK: - Selector Methods
    
    func editingDidBegin() {
        print("edit begin")
        valueIndicatorView.center.x = CGFloat( slider.value/slider.maximumValue ) * slider.frame.width + slider.frame.origin.x
        UIView.animate(withDuration: 0.2) {
            self.valueIndicatorView.frame.size.width = 40
        }
    }
    
    func didDragSlider() {
        valueIndicatorView.center.x = CGFloat( slider.value/slider.maximumValue ) * slider.frame.width + slider.frame.origin.x
    }
    
    func editingDidEnd() {
        print("edit end")
        UIView.animate(withDuration: 0.2) {
            self.valueIndicatorView.frame.size.width = 0
        }
    }
    
}
