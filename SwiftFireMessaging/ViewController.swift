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
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    // This is the reference to the database
    let rootRef = FIRDatabase.database().reference()

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

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
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text, let userName = self.usernameTextField.text else {
            UIAlertController.showSimpleMessage(viewController: self, title: "Enter all fields", message: nil)
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email , password: password) {
            (user, error) in
            // Now let's go and login with the created user
            // Regardless, if this email / password already has an account, let's log them in
            self.login(userName: userName, email: email, password: password)
        }
    }
    
    func login(userName: String, email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) {
            (user, error) in
            if error != nil {
                // TODO: Show an alert view saying invalid login
                let title = "Invalid Login"
                UIAlertController.showSimpleMessage(viewController: self, title: title, message: nil)
            } else {
                // You have successfully signed in!
                let newUser = User(username: userName, email: email)
                self.storeUserInDatabase(user: user!, userStruct: newUser)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func storeUserInDatabase(user: FIRUser, userStruct: User) {
        let userID = user.uid
        let userRef = self.rootRef.child(UserKeys.Users.rawValue)
        let uniqueIDRef = userRef.child(userID)
        uniqueIDRef.updateChildValues(userStruct.JSONFormat())
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

