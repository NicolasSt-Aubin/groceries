//
//  LeftListCollectionViewCell.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol LeftListCollectionViewCellDelegate {
    func userDidStartSearching()
    func userDidStopSearching()
}

class LeftListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Class Properties
    
    static let reuseIdentifier = "LeftListCollectionViewCellReuseIdentifier"
    
    // MARK: - Properties
    
    var delegate: LeftListCollectionViewCellDelegate? = nil
    
    fileprivate var keyboardHeight: CGFloat = 0 {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    fileprivate var userIsCreating: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var leftSearchView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.searchIcon.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .flatSilver
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    
    fileprivate lazy var addIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.addIcon.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .flatSilver
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
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
    
    fileprivate lazy var searchAddTextField: UITextField = {
        let textField = UITextField.generateGRTextField()
        textField.leftView = self.leftSearchView
        textField.delegate = self
        textField.returnKeyType = .done
        textField.placeholder = L10n.searchPlaceholder
        return textField
    }()
    
    fileprivate lazy var leftCategoryView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var categoryIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.categoryIcon.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .flatSilver
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    
    fileprivate lazy var categoryTextField: UITextField = {
        let textField = UITextField.generateGRTextField()
        textField.delegate = self
        textField.leftView = self.leftCategoryView
        textField.returnKeyType = .next
        textField.placeholder = L10n.category
        return textField
    }()
    
    fileprivate lazy var leftPriceView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var priceIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.priceIcon.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .flatSilver
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    
    fileprivate lazy var priceTextField: UITextField = {
        let textField = UITextField.generateGRTextField()
        textField.delegate = self
        textField.leftView = self.leftPriceView
        textField.returnKeyType = .done
        textField.placeholder = L10n.optionalIndicator
        return textField
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OverviewTableViewCell.classForCoder(), forCellReuseIdentifier: OverviewTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = false
        return tableView
    }()
    
    fileprivate lazy var addButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .flatBelizeHole
        button.setTitleColor(.white, for: .normal)
        button.setTitle(L10n.add, for: .normal)
//        button.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftSearchView.addSubview(searchIconImageView)
        leftSearchView.addSubview(addIconImageView)
        leftSearchView.addSubview(activityIndicatorView)
        leftCategoryView.addSubview(categoryIconImageView)
        leftPriceView.addSubview(priceIconImageView)
        addSubview(tableView)
        addSubview(searchAddTextField)
        addSubview(categoryTextField)
        addSubview(priceTextField)
        addSubview(addButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchAddTextField.frame.size.width = bounds.width - 2 * CGFloat.pageMargin
        searchAddTextField.frame.size.height = CGFloat.formFieldHeight
        searchAddTextField.center.x = bounds.width/2
        searchAddTextField.frame.origin.y = CGFloat.pageMargin
        searchAddTextField.layer.cornerRadius = CGFloat.formFieldRadius
        
        leftSearchView.frame.size.height = searchAddTextField.frame.size.height
        leftSearchView.frame.size.width = leftSearchView.frame.height
        
        searchIconImageView.alpha = userIsCreating ? 0 : 1
        searchIconImageView.frame.size = CGSize(width: 25, height: 25)
        searchIconImageView.center.x = leftSearchView.frame.width/2
        searchIconImageView.center.y = leftSearchView.frame.height/2
        
        addIconImageView.alpha = userIsCreating ? 1 : 0
        addIconImageView.frame.size = CGSize(width: 15, height: 15)
        addIconImageView.center = searchIconImageView.center
        
        activityIndicatorView.center = searchIconImageView.center
        
        let dualFormAvailableWidth: CGFloat = bounds.width - 2 * CGFloat.pageMargin - CGFloat.formMargin
        
        categoryTextField.alpha = userIsCreating ? 1 : 0
        categoryTextField.isEnabled = userIsCreating
        categoryTextField.frame.size.height = CGFloat.formFieldHeight
        categoryTextField.frame.size.width = dualFormAvailableWidth * 2 / 3
        categoryTextField.frame.origin.x = CGFloat.pageMargin
        categoryTextField.frame.origin.y = searchAddTextField.frame.maxY + CGFloat.formMargin
        categoryTextField.layer.cornerRadius = CGFloat.formFieldRadius
        
        leftCategoryView.frame.size.height = categoryTextField.frame.size.height
        leftCategoryView.frame.size.width = leftCategoryView.frame.height
        
        categoryIconImageView.frame.size = searchIconImageView.frame.size
        categoryIconImageView.center.x = leftCategoryView.frame.width/2
        categoryIconImageView.center.y = leftCategoryView.frame.height/2
        
        priceTextField.alpha = userIsCreating ? 1 : 0
        priceTextField.isEnabled = userIsCreating
        priceTextField.frame.size.height = CGFloat.formFieldHeight
        priceTextField.frame.size.width = dualFormAvailableWidth * 1 / 3
        priceTextField.frame.origin.x = categoryTextField.frame.maxX + CGFloat.formMargin
        priceTextField.frame.origin.y = categoryTextField.frame.origin.y
        priceTextField.layer.cornerRadius = CGFloat.formFieldRadius
        
        leftPriceView.frame.size.height = priceTextField.frame.size.height
        leftPriceView.frame.size.width = leftPriceView.frame.height
        
        priceIconImageView.frame.size = searchIconImageView.frame.size
        priceIconImageView.center.x = leftPriceView.frame.width/2
        priceIconImageView.center.y = leftPriceView.frame.height/2
        
        addButton.alpha = userIsCreating ? 1 : 0
        addButton.isUserInteractionEnabled = userIsCreating
        addButton.frame.size = searchAddTextField.frame.size
        addButton.center.x = bounds.width/2
        addButton.frame.origin.y = categoryTextField.frame.maxY + CGFloat.formMargin * 2
        addButton.layer.cornerRadius = CGFloat.formFieldRadius
        
        tableView.alpha = userIsCreating ? 0 : 1
        tableView.frame.size.width = bounds.width
        tableView.frame.size.height = bounds.height - searchAddTextField.frame.maxY - CGFloat.pageMargin - keyboardHeight
        tableView.frame.origin.y = searchAddTextField.frame.maxY + CGFloat.pageMargin
    }
    
    // MARK: - Selector Methods
    
    func keyboardWillChangeFrame(_ notification: NSNotification) {
        
        if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = frame.height
        }
        
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = 0
    }

}

extension LeftListCollectionViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userIsCreating = true
        delegate?.userDidStartSearching()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userIsCreating = false
        delegate?.userDidStopSearching()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension LeftListCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OverviewTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.reuseIdentifier, for: indexPath)
    }
    
}
