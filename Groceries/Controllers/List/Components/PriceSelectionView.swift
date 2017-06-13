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
        
        for i in 0..<21 {
            let view = UIView()
            view.backgroundColor = .flatSilver
            views.append(view)
        }
        
        return views
    }()
    
    fileprivate lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBelizeHole
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didPanCircleView(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        return view
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        addSubview(instructionLabel)
        addSubview(horizontalLineView)
        for view in verticalLineViews {
            addSubview(view)
        }
        addSubview(circleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        instructionLabel.frame.size.width = bounds.width - CGFloat.pageMargin*2
        instructionLabel.frame.origin.x = CGFloat.pageMargin
        
        horizontalLineView.frame.size.width = instructionLabel.frame.width
        horizontalLineView.frame.size.height = 1
        horizontalLineView.frame.origin.x = instructionLabel.frame.origin.x
        horizontalLineView.frame.origin.y = instructionLabel.frame.maxY + 25
        
        for i in 0..<verticalLineViews.count {
            verticalLineViews[i].frame.size.width = 1
            verticalLineViews[i].frame.size.height = i%2 == 0 ? 8 : 4
            verticalLineViews[i].center.x = horizontalLineView.frame.origin.x + CGFloat(i) * horizontalLineView.frame.width / CGFloat(verticalLineViews.count-1)
            verticalLineViews[i].frame.origin.y = horizontalLineView.frame.origin.y
        }
        
        circleView.frame.size.width = 25
        circleView.frame.size.height = circleView.frame.width
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.center.y = horizontalLineView.center.y
        circleView.frame.origin.x = horizontalLineView.frame.minX
        
//        valueIndicatorView.layer.cornerRadius = CGFloat.formFieldRadius
//        valueIndicatorView.frame.size.height = 20
//        valueIndicatorView.frame.origin.y = slider.frame.minY - valueIndicatorView.frame.height - CGFloat.formMargin
    }
    
    // MARK: - Selector Methods
    
    var initialPanPosition: CGFloat = CGFloat.pageMargin
    
    func didPanCircleView(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            initialPanPosition = circleView.frame.origin.x
        }
        
        let xTranslation = gestureRecognizer.translation(in: self).x
        let newPos = initialPanPosition + xTranslation
        
        if newPos >= horizontalLineView.frame.minX && newPos <= horizontalLineView.frame.maxX - circleView.frame.width {
            circleView.frame.origin.x = newPos
        }
        
    }
    
//    func editingDidBegin() {
//        print("edit begin")
//        valueIndicatorView.center.x = CGFloat( slider.value/slider.maximumValue ) * slider.frame.width + slider.frame.origin.x
//        UIView.animate(withDuration: 0.2) {
//            self.valueIndicatorView.frame.size.width = 40
//        }
//    }
//    
//    func didDragSlider() {
//        valueIndicatorView.center.x = CGFloat( slider.value/slider.maximumValue ) * slider.frame.width + slider.frame.origin.x
//    }
//    
//    func editingDidEnd() {
//        print("edit end")
//        UIView.animate(withDuration: 0.2) {
//            self.valueIndicatorView.frame.size.width = 0
//        }
//    }
    
}
