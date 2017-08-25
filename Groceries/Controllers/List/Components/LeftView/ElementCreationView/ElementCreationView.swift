//
//  ElementCreationView.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-08-24.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

protocol ElementCreationViewDelegate {
    func elementCreationViewShouldCloseView()
}

class ElementCreationView: UIScrollView {
    
    // MARK: - Class Properties
    
    var elementCreationDelegate: ElementCreationViewDelegate? = nil
    
    // MARK: - UI Elements
    
    lazy var nameTextField: GRTextField = {
        let textField = GRTextField(icon: Asset.addIcon.image)
        textField.delegate = self
        textField.returnKeyType = .done
        textField.placeholder = L10n.name
        textField.clearButtonMode = .always
        return textField
    }()
    
    fileprivate lazy var categorySelectionView: CategorySelectionView = {
        let categorySelectionView = CategorySelectionView()
        categorySelectionView.delegate = self
        return categorySelectionView
    }()
    
    fileprivate lazy var priceSelectionView: PriceSelectionView = {
        let priceSelectionView = PriceSelectionView()
        priceSelectionView.sizeToFit()
        priceSelectionView.delegate = self
        return priceSelectionView
    }()
    
    fileprivate lazy var quantityIndicatorSelectionView: QuantityIndicatorSelectionView = {
        let quantityIndicatorSelectionView = QuantityIndicatorSelectionView()
        quantityIndicatorSelectionView.sizeToFit()
        quantityIndicatorSelectionView.delegate = self
        return quantityIndicatorSelectionView
    }()
    
    fileprivate lazy var cancelButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.cancel, for: .normal)
        button.backgroundColor = .flatSilver
        button.addTarget(self, action: #selector(self.didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var addButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.add, for: .normal)
        button.addTarget(self, action: #selector(self.didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .flatCloud
        
        addSubview(nameTextField)
        addSubview(categorySelectionView)
        addSubview(priceSelectionView)
        addSubview(quantityIndicatorSelectionView)
        addSubview(addButton)
        addSubview(cancelButton)
        
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameTextField.frame.size.width = bounds.width - CGFloat.pageMargin*2
        nameTextField.frame.size.height = CGFloat.formFieldHeight
        nameTextField.center.x = bounds.width/2
        nameTextField.frame.origin.y = CGFloat.pageMargin
        
        categorySelectionView.frame.size.width = bounds.width
        categorySelectionView.frame.size.height = 100
        categorySelectionView.frame.origin.y = nameTextField.frame.maxY + 20
        
        priceSelectionView.frame.size.width = bounds.width
        priceSelectionView.frame.origin.y = categorySelectionView.frame.maxY + 20
        
        quantityIndicatorSelectionView.frame.size.width = bounds.width
        quantityIndicatorSelectionView.frame.origin.y = priceSelectionView.frame.maxY + 20
        
        let dualFormAvailableWidth: CGFloat = bounds.width - 2 * CGFloat.pageMargin - CGFloat.formMargin
        
        cancelButton.frame.size.width = dualFormAvailableWidth/2
        cancelButton.frame.size.height = CGFloat.formFieldHeight
        cancelButton.layer.cornerRadius = CGFloat.formFieldRadius
        cancelButton.frame.origin.x = CGFloat.pageMargin
        cancelButton.frame.origin.y = quantityIndicatorSelectionView.frame.maxY + 40
        
        addButton.frame.size = cancelButton.frame.size
        addButton.layer.cornerRadius = CGFloat.formFieldRadius
        addButton.frame.origin.x = cancelButton.frame.maxX + CGFloat.formMargin
        addButton.frame.origin.y = cancelButton.frame.origin.y
        
        contentSize.height = addButton.frame.maxY + CGFloat.pageMargin
    }
    
    // MARK: - Public methods
    
    func reset() {
        nameTextField.clearText()
        categorySelectionView.reset()
        priceSelectionView.reset()
        quantityIndicatorSelectionView.didTapUnitButton()
    }
    
    // MARK: - Selector mthods
    
    func didTapAddButton() {
        reset()
    }
    
    func didTapCancelButton() {
        elementCreationDelegate?.elementCreationViewShouldCloseView()
    }
    
}

// MARK: - UITextFieldDelegate

extension ElementCreationView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
    }
    
}

// MARK: - CategorySelectionViewDelegate

extension ElementCreationView: CategorySelectionViewDelegate {
    
    func categorySelectionViewDidChangeValue() {
        nameTextField.resignFirstResponder()
    }
    
}

// MARK: - PriceSelectionViewDelate

extension ElementCreationView: PriceSelectionViewDelate {
    
    func priceSelectionViewDidChangeValue() {
        nameTextField.resignFirstResponder()
    }
    
}

// MARK: - QuantityIndicatorSelectionViewDelegate

extension ElementCreationView: QuantityIndicatorSelectionViewDelegate {
    
    func quantityIndicatorSelectionViewDidChangeValue() {
        nameTextField.resignFirstResponder()
    }
    
}
