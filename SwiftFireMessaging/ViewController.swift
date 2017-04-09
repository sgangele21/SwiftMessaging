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
import FirebaseStorage

class ViewController: UIViewController  {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    // Remember, self is not initialized in phase, so you have to make this a lazy loader
    lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    // This is the reference to the database
    let rootRef = FIRDatabase.database().reference()
    // Reference to storage
    let storageRef = FIRStorage.storage().reference()

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
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
    
    // It is accidentally storing the default image as well, so check that
    func login(userName: String, email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) {
            (user, error) in
            if error != nil {
                // TODO: Show an alert view saying invalid login
                let title = "Invalid Login"
                UIAlertController.showSimpleMessage(viewController: self, title: title, message: nil)
            } else {
                let uniqueString = UUID().uuidString
                let childStorageRef = self.storageRef.child("profileImages").child(uniqueString)
                if let imageToUpload = self.userImage.image, let uploadData = UIImagePNGRepresentation(imageToUpload) {
                   childStorageRef.put(uploadData, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        print(error)
                    }
                    // You have successfully signed in!
                    // Now we have everything we need, let's go and store this user in the database
                    let newUser = User(username: userName, email: email, imageURL: (metaData?.downloadURL())!)
                    self.storeUserInDatabase(user: user!, userStruct: newUser)
                    self.dismiss(animated: true, completion: nil)
                   })
                }
            }
        }
    }
    
    func storeUserInDatabase(user: FIRUser, userStruct: User) {
        let userID = user.uid
        let userRef = self.rootRef.child(UserKeys.Users.rawValue)
        // Each user is identified by it's UID
        let uniqueIDRef = userRef.child(userID)
        // Add the values to the newly created UID by the user
        uniqueIDRef.updateChildValues(userStruct.JSONFormat())
    }
    
    @IBAction func tappedImageSelector(_ sender: UITapGestureRecognizer) {
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    

}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get's image from imagePicker
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return}
        DispatchQueue.main.async {
            self.userImage.image = image
        }
        self.imagePickerController.dismiss(animated: true, completion: nil)
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

