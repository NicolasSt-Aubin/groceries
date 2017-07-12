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
    
    var isClearable: Bool = true
    
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
    
    fileprivate lazy var clearImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .flatMidnightBlue
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.clearIcon.image.withRenderingMode(.alwaysTemplate)
        return imageView
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
        
        rightViewMode = .always
        rightView = UIView()
        rightView!.clipsToBounds = true
        rightView!.alpha = 0
        rightView!.addSubview(clearImageView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clearText))
        rightView!.addGestureRecognizer(tapGestureRecognizer)
        
        backgroundColor = .white
        borderize(width: 1, color: .flatSilver)
        textColor = .flatMidnightBlue
        textAlignment = .left
        tintColor = .flatBelizeHole
        
        addTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
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
        
        rightView!.frame.size = isClearable ? leftView!.frame.size : .zero
        
        clearImageView.frame.size = CGSize(width: 20, height: 20)
        clearImageView.center.x = rightView!.frame.width/2
        clearImageView.center.y = rightView!.frame.height/2
    }

    // MARK: - Selector Methods
    
    func editingChanged() {
        UIView.animate(withDuration: 0.2) {
            self.iconImageView.tintColor = self.text != nil && self.text != "" ? .flatMidnightBlue : .flatSilver
            self.activityIndicatorView.color = self.text != nil && self.text != "" ? .flatMidnightBlue : .flatSilver
            self.rightView!.alpha = self.text != nil && self.text != "" ?  1 : 0
        }
    }
    
    func clearText() {
        text = ""
        editingChanged()
        sendActions(for: .editingChanged)
    }
    
}
