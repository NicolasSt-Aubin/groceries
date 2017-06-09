//
//  CheckButton.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-09.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class CheckButton: UIButton {

    // MARK: - Properties
    
    var mainImage: UIImage? = nil {
        didSet {
            guard let image = mainImage else {
                return
            }
            
            mainImageView.image = image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            setNeedsLayout()
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    // MARK: - UI Elements
    
    fileprivate lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.85
        imageView.tintColor = .white
        return imageView
    }()
    
    fileprivate lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.checkIcon.image.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.85
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK: - Init
    
    init(mainImage: UIImage? = nil) {
        super.init(frame: .zero)
        
        self.mainImage = mainImage
        mainImageView.image = mainImage?.withRenderingMode(.alwaysTemplate)
        
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
        
        addSubview(mainImageView)
        addSubview(checkImageView)
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainImageView.frame.size.width = isChecked ? 0 : 30
        mainImageView.frame.size.height = isChecked ? 0 : 30
        mainImageView.center.x = bounds.width/2
        mainImageView.frame.origin.y = bounds.height - mainImageView.frame.height
        
        checkImageView.frame.size.width = isChecked ? 15 : 0
        checkImageView.frame.size.height = isChecked ? 15 : 0
        checkImageView.center.x = bounds.width/2
        checkImageView.center.y = bounds.height/2
    }

}
