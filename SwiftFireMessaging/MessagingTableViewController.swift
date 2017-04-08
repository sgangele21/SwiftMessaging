//
//  MessagingTableViewController.swift
//  SwiftFireMessaging
//
//  Created by Sahil Gangele on 4/6/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

public class MessagingTableViewController: UITableViewController {
    
    // This is the reference to the database
    let rootRef = FIRDatabase.database().reference()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBarButtons()        
    }
    
    // Update screen based on new user being logged in
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAccordingToUser()
    }
    
    func updateAccordingToUser() {
        guard let userID = FIRAuth.auth()?.currentUser?.uid else {return}
        rootRef.child(UserKeys.Users.rawValue).observe(.value, with: {(snap: FIRDataSnapshot) in
            guard let value = snap.value as? [String: [String: Any]] else {return}
            guard let user = value[userID] as? [String:String] else {return}
            DispatchQueue.main.async {
                self.navigationItem.title = user[UserKeys.username.rawValue]
            }
        })
    }
    
    func setupNavBarButtons() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let newMessageButton = UIBarButtonItem(image: #imageLiteral(resourceName: "NewMessage"), style: .plain, target: self, action: #selector(newMessage))
        self.navigationItem.setLeftBarButton(logoutButton, animated: false)
        self.navigationItem.setRightBarButton(newMessageButton, animated: false)
    }
    
    func newMessage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newMessageVC = storyBoard.instantiateViewController(withIdentifier: "NewMessage")
        self.present(newMessageVC, animated: true, completion: nil)
    }
    
    func logout() {
        do {
         try FIRAuth.auth()?.signOut()
        } catch(let error) {
            print(error)
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginController")
        self.present(loginVC, animated: true, completion: nil)
    }
}
