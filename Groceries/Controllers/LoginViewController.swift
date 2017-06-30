//
//  ViewController.swift
//  saptest
//
//  Created by Nicolas St-Aubin on 2017-06-01.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: BaseViewController {

    // MARK: - Properties
    
    fileprivate var keyboardHeight: CGFloat = 0
    
    // MARK: - UI Elements
    
    fileprivate lazy var welcomeLabel: UILabel = {
        let label = UILabel.generateTitleLabel()
        label.text = L10n.welcome
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var emailTextField: GRTextField = {
        let textField = GRTextField(icon: Asset.emailIcon.image)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.textContentType = UITextContentType.emailAddress
        textField.placeholder = L10n.email
        textField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .allEditingEvents)
        return textField
    }()
    
    fileprivate lazy var passwordTextField: GRTextField = {
        let textField = GRTextField(icon: Asset.passwordIcon.image)
        textField.delegate = self
        textField.returnKeyType = .go
        textField.placeholder = L10n.password
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .allEditingEvents)
        return textField
    }()
    
    fileprivate lazy var loginButton: GRButton = {
        let button = GRButton()
        button.setTitle(L10n.login, for: .normal)
        button.addTarget(self, action: #selector(self.login), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        welcomeLabel.frame.origin.y = CGFloat.topTitleMargin
        welcomeLabel.frame.origin.x = CGFloat.pageMargin
        
        let textFieldSize = CGSize(width: view.bounds.width - CGFloat.pageMargin*2, height: CGFloat.formFieldHeight)
        
        emailTextField.frame.size = textFieldSize
        emailTextField.layer.cornerRadius = CGFloat.formFieldRadius
        emailTextField.frame.origin.y = welcomeLabel.frame.maxY + 20
        emailTextField.center.x = view.bounds.width/2
        
        passwordTextField.frame.size = textFieldSize
        passwordTextField.layer.cornerRadius = CGFloat.formFieldRadius
        passwordTextField.frame.origin.y = emailTextField.frame.maxY + CGFloat.formMargin
        passwordTextField.center.x = view.bounds.width/2
        
        loginButton.frame.size = textFieldSize
        loginButton.center.x = view.bounds.width/2
        loginButton.frame.origin.y = view.bounds.height - CGFloat.pageMargin - keyboardHeight - loginButton.frame.height
        loginButton.layer.cornerRadius = CGFloat.formFieldRadius
    }
    
    // MARK: - Selector Methods
    
    func keyboardWillChangeFrame(_ notification: NSNotification) {
        
        if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = frame.height
            UIView.animate(withDuration: 0.5) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = 0
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func textFieldValueChanged() {
        loginButton.isEnabled = emailTextField.text != nil && emailTextField.text != "" && passwordTextField.text != nil && passwordTextField.text != ""
    }
    
    func login() {
        guard let email = emailTextField.text else {
            HUD.flash(.error)
            return
        }
        
        guard email != "" else {
            HUD.flash(.error)
            return
        }
        
        guard let password = passwordTextField.text else {
            HUD.flash(.error)
            return
        }
        
        guard password != "" else {
            HUD.flash(.error)
            return
        }

        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isLoading = true
        
        APIService.login(email: email, password: password, success: {
            HUD.flash(.success)
            (UIApplication.shared.delegate as! AppDelegate).goToMainAppContent()
        }, failure: { error in
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.loginButton.isLoading = false
            self.presentError(error)
        })
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            login()
        }
        return true
    }
    
}

