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
    
    fileprivate lazy var emailTextField: UITextField = {
        let textField = UITextField.generateGRTextField()
        textField.delegate = self
        textField.returnKeyType = .next
        textField.textContentType = UITextContentType.emailAddress
        textField.placeholder = L10n.email
        return textField
    }()
    
    fileprivate lazy var passwordTextField: UITextField = {
        let textField = UITextField.generateGRTextField()
        textField.delegate = self
        textField.returnKeyType = .go
        textField.placeholder = L10n.password
        textField.isSecureTextEntry = true
        return textField
    }()
    
    fileprivate lazy var loginButton: GRButton = {
        let button = GRButton()
        button.backgroundColor = .flatBelizeHole
        button.setTitleColor(.white, for: .normal)
        button.setTitle(L10n.login, for: .normal)
        button.addTarget(self, action: #selector(self.login), for: .touchUpInside)
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
        emailTextField.frame.origin.y = welcomeLabel.frame.maxY + CGFloat.bottomTitleMargin
        emailTextField.center.x = view.bounds.width/2
        
        passwordTextField.frame.size = textFieldSize
        passwordTextField.layer.cornerRadius = CGFloat.formFieldRadius
        passwordTextField.frame.origin.y = emailTextField.frame.maxY + CGFloat.formMargin
        passwordTextField.center.x = view.bounds.width/2
        
        loginButton.frame.size = textFieldSize
        loginButton.layer.cornerRadius = CGFloat.formFieldRadius
        loginButton.center.x = view.bounds.width/2
        loginButton.frame.origin.y = view.bounds.height - CGFloat.pageMargin - keyboardHeight - loginButton.frame.height
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

        HUD.show(.progress)
        
        APIService.login(email: email, password: password, success: {
            HUD.flash(.success)
            (UIApplication.shared.delegate as! AppDelegate).goToMainAppContent()
        }, failure: { error in
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

