//
//  ViewController.swift
//  SwiftFireMessaging
//
//  Created by Sahil Gangele on 3/28/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailSignInButton: UIButton!
    
    @IBOutlet weak var loginView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginView.layer.cornerRadius = 3.0
        self.emailSignInButton.layer.cornerRadius = 3.0
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        // First create a user, then login
        // Login with email and password using the textfields
        if self.didUserEnterAllFields() == false {
            UIAlertController.showSimpleMessage(viewController: self, title: "Enter all fields", message: nil)
            return
        }
        FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text! , password: self.passwordTextField.text!) {
            (user, error) in
            // TODO: Check for edge cases
            // Now let's go and login with the created user
            // Regardless, if this email / password already has an account, let's log them in
            self.login()
        }
    }
    
    func didUserEnterAllFields() -> Bool {
        return !(self.usernameTextField.text == nil || self.emailTextField.text == nil || self.passwordTextField.text == nil)
    }
    
    func login() {
        FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {
            (user, error) in
            if error != nil {
                // TODO: Show an alert view saying invalid login
                let title = "Invalid Login"
                UIAlertController.showSimpleMessage(viewController: self, title: title, message: nil)
            } else {
                // You have successfully signed in!
                let title = "You have successfully logged in"
                UIAlertController.showSimpleMessage(viewController: self, title: title, message: nil)
            }
        }
    }

}

extension UIAlertController {
    static func showSimpleMessage(viewController: UIViewController, title: String?, message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        viewController.present(alertVC, animated: true, completion: nil)
    }
}

