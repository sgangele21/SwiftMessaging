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

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var loginView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        self.loginView.layer.cornerRadius = 3.0
        self.emailSignInButton.layer.cornerRadius = 3.0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("There was an error")
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                print("There was an error in credentials")
                // ...
                return
            }
        }
    }
    
    
    @IBAction func loginWithEmail(_ sender: Any) {
        print(self.emailTextField.text!)
        print(self.passwordTextField.text!)
        // First create a user, then login
        FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text! , password: self.passwordTextField.text!) {
            (user, error) in
            // TODO: Check for edge cases
            self.login()
        }
    }
    
    func login() {
        FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {
            (user, error) in
            if error != nil {
                // TODO: Show an alert view saying invalid login
                print("Invalid login")
            } else {
                // You have successfully signed in!
                print("You have successfully logged in")
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }


}

