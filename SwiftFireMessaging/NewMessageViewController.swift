//
//  NewMessageViewController.swift
//  SwiftFireMessaging
//
//  Created by Sahil Gangele on 4/8/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit
import FirebaseDatabase

public class NewMessageViewController: UITableViewController {
    
    var users: [User] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    // This is the reference to the database
    let rootRef = FIRDatabase.database().reference()
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupBarButtons()
        rootRef.child(UserKeys.Users.rawValue).observeSingleEvent(of: .value, with: {(snap: FIRDataSnapshot) in
            guard let dict = snap.value as? [String: [String:String]] else {return}
            for value in dict.values {
                print(value)
                let email = value[UserKeys.email.rawValue]
                let userName = value[UserKeys.username.rawValue]
                var imageURL: URL? = nil
                if let imageURLString = value[UserKeys.imageURL.rawValue] {
                    imageURL = URL(string: imageURLString)
                }
                // TODO: Check for the force unwrapping
                let user = User(username: userName!, email: email!, imageURL: imageURL)
                self.users.append(user)
            }
        })
    
        
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCells") as! UITableViewCell
        let index = indexPath.row
        let userNameLabel = cell.viewWithTag(100) as! UILabel
        let emailLabel = cell.viewWithTag(101) as! UILabel
        userNameLabel.text = self.users[index].username
        emailLabel.text = self.users[index].email
        return cell
    }
    
    func setupBarButtons() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem = cancelButton
//        self.navigationItem.setLeftBarButton(cancelButton, animated: false)
    }
    
    func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
