//
//  STButton.swift
//  saptest
//
//  Created by Nicolas St-Aubin on 2017-06-02.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class GRButton: UIButton {

    // MARK: - Properties
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isEnabled = !isLoading
            activityIndicatorView.alpha = isLoading ? 1 : 0
            titleLabel!.alpha = isLoading ? 0 : 1
        }
    }
    
    // MARK: - UI Elements 
    
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .flatSilver
        activityIndicatorView.startAnimating()
        activityIndicatorView.alpha = 0
        activityIndicatorView.sizeToFit()
        return activityIndicatorView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = .flatBelizeHole
        setTitleColor(.white, for: .normal)
        
        addSubview(activityIndicatorView)
        
        addTarget(self, action: #selector(self.startedTouchingButton), for: .touchDown)
        addTarget(self, action: #selector(self.stoppedTouchingButton), for: .touchCancel)
        addTarget(self, action: #selector(self.stoppedTouchingButton), for: .touchUpInside)
        addTarget(self, action: #selector(self.stoppedTouchingButton), for: .touchUpOutside)
    }
    
    // MARK: - Selector methods
    
    func startedTouchingButton() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.7
        }
    }
    
    func stoppedTouchingButton() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
    }

    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicatorView.center.x = bounds.width/2
        activityIndicatorView.center.y = bounds.height/2
    }
    
}
