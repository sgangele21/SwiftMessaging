//
//  MessagingTableViewController.swift
//  SwiftFireMessaging
//
//  Created by Sahil Gangele on 4/6/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit

public class MessagingTableViewController: UITableViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let buttonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.setLeftBarButton(buttonItem, animated: false)
    }
    
    func logout() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginController")
        loginVC.modalPresentationStyle = .overCurrentContext
        self.present(loginVC, animated: true, completion: nil)
    }
}
