//
//  ViewController.swift
//  SwiftFireMessaging
//
//  Created by Sahil Gangele on 3/28/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginView.layer.cornerRadius = 5.0
        self.registerButton.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

