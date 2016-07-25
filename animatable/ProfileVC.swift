//
//  ProfileVC.swift
//  animatable
//
//  Created by Prateek Mahawar on 25/07/16.
//  Copyright © 2016 Prateek Mahawar. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logoutPressed(sender: AnyObject) {
        do{
            try FIRAuth.auth()?.signOut()
            print("Logout Complete")
            
        } catch let logoutError {
            print(logoutError)
        }
        
        
    }

}
