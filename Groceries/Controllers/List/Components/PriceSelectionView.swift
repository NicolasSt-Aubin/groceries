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
    
    var value: Double = 0 {
        didSet {
            value = round(value)
            priceLabel.text = String(format: "%.2f$", value)
        }
    }
    var minValue: Double = 0
    var maxValue: Double = 20
    var gradCount: Int = 20
    
    // MARK: - UI Elements
    
    fileprivate lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .flatSilver
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = L10n.selectPrice.uppercased()
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatSilver
        return view
    }()
    
    fileprivate lazy var verticalLineViews: [UIView] = {
        var views: [UIView] = []
        
        for i in 0..<self.gradCount+1 {
            let view = UIView()
            view.backgroundColor = .flatSilver
            views.append(view)
        }
        
        return views
    }()
    
    fileprivate lazy var gradLabels: [UILabel] = {
        var labels: [UILabel] = []
        
        for i in 0..<(self.gradCount/2)+1 {
            let label = UILabel()
            label.textColor = .flatSilver
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
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .flatBlack
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0.00$"
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        borderize()
        addSubview(instructionLabel)
        addSubview(priceLabel)
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
        
        priceLabel.frame.size.width = instructionLabel.frame.width
        priceLabel.frame.origin.x = instructionLabel.frame.origin.x
        priceLabel.frame.origin.y = instructionLabel.frame.maxY + CGFloat.formMargin
        
        circleView.frame.size.width = CGFloat.pageMargin*3
        circleView.frame.size.height = circleView.frame.width
        circleView.layer.cornerRadius = circleView.frame.height/2
        
        horizontalLineView.frame.size.width = bounds.width - CGFloat.pageMargin*6
        horizontalLineView.frame.size.height = 1
        horizontalLineView.center.x = bounds.width/2
        horizontalLineView.frame.origin.y = priceLabel.frame.maxY + circleView.frame.size.height/2 + CGFloat.formMargin
        
        for i in 0..<verticalLineViews.count {
            verticalLineViews[i].frame.size.width = 1
            verticalLineViews[i].frame.size.height = i%2 == 0 ? 8 : 4
            verticalLineViews[i].center.x = horizontalLineView.frame.origin.x + CGFloat(i) * horizontalLineView.frame.width / CGFloat(verticalLineViews.count-1)
            verticalLineViews[i].frame.origin.y = horizontalLineView.frame.origin.y
        }
        
        circleView.center.y = horizontalLineView.center.y
        circleView.center.x = horizontalLineView.frame.minX
        
        for i in 0..<gradLabels.count {
            gradLabels[i].center.x = horizontalLineView.frame.origin.x + CGFloat(i) * horizontalLineView.frame.width / CGFloat(gradLabels.count-1)
            gradLabels[i].frame.origin.y = circleView.frame.maxY + CGFloat.formMargin
        }
    }
    
    // MARK: - Selector Methods
    
    var initialPanPosition: CGFloat = CGFloat.pageMargin
    
    var minX: CGFloat { return horizontalLineView.frame.minX }
    var maxX: CGFloat { return horizontalLineView.frame.maxX }
    
    func didPanCircleView(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            initialPanPosition = circleView.center.x
        }
        
        let xTranslation = gestureRecognizer.translation(in: self).x
        
        var newPos = initialPanPosition + xTranslation
        if newPos < minX { newPos = minX }
        if newPos > maxX { newPos = maxX }
        
        circleView.center.x = newPos
        
        let ratioValue = (newPos - minX) / (maxX - minX)
        value = ( Double(ratioValue) * (maxValue - minValue) ) + minValue
    }
    
    // MARK: - Private Methods
    
    fileprivate func updatePos() {
        let ratioPos = (value - minValue) / (maxValue - minValue)
        circleView.center.x = ( CGFloat(ratioPos) * (maxX - minX) ) + minX
    }
    
}
