//
//  STButton.swift
//  saptest
//
//  Created by Nicolas St-Aubin on 2017-06-02.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class GRButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }
    
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

}
