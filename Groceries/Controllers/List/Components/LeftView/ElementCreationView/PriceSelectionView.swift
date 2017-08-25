//
//  PriceSelectionView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-10.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol PriceSelectionViewDelate {
    func priceSelectionViewDidChangeValue()
}

class PriceSelectionView: UIView {

    // MARK: - Properties
    
    var delegate: PriceSelectionViewDelate? = nil
    
    var value: Double = 0 {
        didSet {
            value = round(value)
            priceLabel.text = String(format: "%.2f$", value)
            delegate?.priceSelectionViewDidChangeValue()
        }
    }
    var minValue: Double = 0
    var maxValue: Double = 20
    var gradCount: Int = 20
    
    var initialPanPosition: CGFloat = CGFloat.pageMargin
    
    var minX: CGFloat { return horizontalLineView.frame.minX }
    var maxX: CGFloat { return horizontalLineView.frame.maxX }
    
    // MARK: - UI Elements
    
    fileprivate lazy var instructionLabel: UILabel = {
        let label = UILabel.generateInstructionLabel()
        label.text = L10n.selectPrice.uppercased()
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatGrey
        return view
    }()
    
    fileprivate lazy var verticalLineViews: [UIView] = {
        var views: [UIView] = []
        
        for i in 0..<self.gradCount+1 {
            let view = UIView()
            view.backgroundColor = .flatGrey
            views.append(view)
        }
        
        return views
    }()
    
    fileprivate lazy var gradLabels: [UILabel] = {
        var labels: [UILabel] = []
        
        for i in 0..<(self.gradCount/2)+1 {
            let label = UILabel()
            label.textColor = .flatGrey
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = String(i*2)
            label.sizeToFit()
            labels.append(label)
        }
        
        return labels
    }()
    
    fileprivate lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBelizeHole
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didPanCircleView(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        return view
    }()
    
    fileprivate lazy var priceIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.borderize(width: 1, color: .flatSilver)
        return view
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .flatGrey
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "0.00$"
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        addSubview(instructionLabel)
        addSubview(priceIndicatorView)
        priceIndicatorView.addSubview(priceLabel)
        addSubview(horizontalLineView)
        for view in verticalLineViews {
            addSubview(view)
        }
        addSubview(circleView)
        for view in gradLabels {
            addSubview(view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        instructionLabel.frame.size.width = bounds.width - CGFloat.pageMargin*2
        instructionLabel.frame.origin.x = CGFloat.pageMargin
        
        priceIndicatorView.layer.cornerRadius = CGFloat.formFieldRadius
        priceIndicatorView.frame.size.height = priceLabel.frame.height + CGFloat.formMargin*2
        priceIndicatorView.frame.size.width = priceLabel.frame.width + CGFloat.formMargin*2
        priceIndicatorView.frame.origin.y = instructionLabel.frame.maxY + CGFloat.formMargin
        
        priceLabel.frame.size.width = priceIndicatorView.frame.width
        priceLabel.center.x = priceIndicatorView.frame.width/2
        priceLabel.center.y = priceIndicatorView.frame.height/2

        circleView.frame.size.width = CGFloat.pageMargin*3
        circleView.frame.size.height = circleView.frame.width
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.frame.origin.y = priceIndicatorView.frame.maxY + CGFloat.formMargin
        
        horizontalLineView.frame.size.width = bounds.width - CGFloat.pageMargin*6
        horizontalLineView.frame.size.height = 1
        horizontalLineView.center.x = bounds.width/2
        horizontalLineView.center.y = circleView.center.y
        
        for i in 0..<verticalLineViews.count {
            verticalLineViews[i].frame.size.width = 1
            verticalLineViews[i].frame.size.height = i%2 == 0 ? 8 : 4
            verticalLineViews[i].center.x = horizontalLineView.frame.origin.x + CGFloat(i) * horizontalLineView.frame.width / CGFloat(verticalLineViews.count-1)
            verticalLineViews[i].frame.origin.y = horizontalLineView.frame.origin.y
        }
        
        circleView.center.x = horizontalLineView.frame.minX
        
        positionPriceIndicator()
        
        for i in 0..<gradLabels.count {
            gradLabels[i].center.x = horizontalLineView.frame.origin.x + CGFloat(i) * horizontalLineView.frame.width / CGFloat(gradLabels.count-1)
            gradLabels[i].frame.origin.y = circleView.frame.maxY + CGFloat.formMargin
        }
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        
        setNeedsLayout()
        layoutIfNeeded()
        frame.size.height = gradLabels[0].frame.maxY
    }
    
    // MARK: - Selector Methods
    
    func didPanCircleView(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            initialPanPosition = circleView.center.x
        }
        
        let xTranslation = gestureRecognizer.translation(in: self).x
        
        var newPos = initialPanPosition + xTranslation
        if newPos < minX { newPos = minX }
        if newPos > maxX { newPos = maxX }
        
        circleView.center.x = newPos
        priceIndicatorView.center.x = circleView.center.x
        positionPriceIndicator()
        
        let ratioValue = (newPos - minX) / (maxX - minX)
        value = ( Double(ratioValue) * (maxValue - minValue) ) + minValue
    }
    
    // MARK: - Public Methods
    
    func reset() {
        value = 0
        updatePos()
    }
    
    func updatePos() {
        let ratioPos = (value - minValue) / (maxValue - minValue)
        circleView.center.x = ( CGFloat(ratioPos) * (maxX - minX) ) + minX
        positionPriceIndicator()
    }
    
    // MARK: - Private Methods
    
    fileprivate func positionPriceIndicator() {
        priceIndicatorView.center.x = circleView.center.x
        
        if priceIndicatorView.frame.minX < instructionLabel.frame.minX {
            priceIndicatorView.frame.origin.x = instructionLabel.frame.origin.x
        }
        
        if priceIndicatorView.frame.maxX > instructionLabel.frame.maxX {
            priceIndicatorView.frame.origin.x = instructionLabel.frame.maxX - priceIndicatorView.frame.width
        }
    }
    
}
