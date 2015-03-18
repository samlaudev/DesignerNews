//
//  LoginViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/12/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidLogin(controller: LoginViewController)
}

class LoginViewController: UIViewController {

    // MARK: - UI properties
    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var emailImageView: SpringImageView!
    @IBOutlet weak var passwordImageView: SpringImageView!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    // MARK: - Delegate
    weak var delegate: LoginViewControllerDelegate?
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup text field delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        DesignerNewsService.loginWithEmail(emailTextField.text, password: passwordTextField.text){
          (token) -> () in
            if let token = token {
                LocalStore.saveToken(token)
                self.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.loginViewControllerDidLogin(self)
            }else {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
                
            }
        }
    }
    
    // MARK: - Respond to action
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        dialogView.animation = "zoomOut"
        dialogView.animate()
    }
}

// MARK: - TextField delegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailTextField {
            emailImageView.image = UIImage(named: "icon-mail-active")
            emailImageView.animate()
        }else if textField == passwordTextField {
            passwordImageView.image = UIImage(named: "icon-password-active")
            passwordImageView.animate()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        emailImageView.image = UIImage(named: "icon-mail")
        passwordImageView.image = UIImage(named: "icon-password")
    }
}
