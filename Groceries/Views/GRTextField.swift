//
//  GRTextField.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-09.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class GRTextField: UITextField {

    // MARK: - Properties
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isEnabled = !isLoading
            iconImageView.alpha = isLoading ? 0 : 1
            activityIndicatorView.alpha = isLoading ? 1 : 0
        }
    }
    
    var iconImage: UIImage? = nil {
        didSet {
            iconImageView.image = iconImage?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    // MARK: - UI Elements
    

    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .flatSilver
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .flatSilver
        activityIndicatorView.startAnimating()
        activityIndicatorView.alpha = 0
        activityIndicatorView.sizeToFit()
        return activityIndicatorView
    }()

    // MARK: - Init
    
    init(icon: UIImage? = nil) {
        super.init(frame: .zero)
        
        iconImage = icon
        iconImageView.image = iconImage?.withRenderingMode(.alwaysTemplate)
        
        leftViewMode = .always
        leftView = UIView()
        leftView!.addSubview(iconImageView)
        leftView!.addSubview(activityIndicatorView)
        
        backgroundColor = .white
        borderize(width: 1, color: .flatSilver)
        textColor = .flatMidnightBlue
        textAlignment = .left
        tintColor = .flatBelizeHole
        
        addTarget(self, action: #selector(self.textDidChange), for: .allEditingEvents)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = CGFloat.formFieldRadius
        
        leftView!.frame.size.height = bounds.height
        leftView!.frame.size.width = bounds.height
        
        iconImageView.frame.size = CGSize(width: 20, height: 20)
        iconImageView.center.x = leftView!.frame.width/2
        iconImageView.center.y = leftView!.frame.height/2
        
        activityIndicatorView.center = iconImageView.center
    }

    // MARK: - Selector Methods
    
    func textDidChange() {
        iconImageView.tintColor = text != nil && text != "" ? .flatMidnightBlue : .flatSilver
        activityIndicatorView.color = text != nil && text != "" ? .flatMidnightBlue : .flatSilver
    }
    
}
