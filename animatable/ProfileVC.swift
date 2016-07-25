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

    @IBOutlet weak var userNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserName()
        
    }
    
    func getUserName() {
    
    let uid = FIRAuth.auth()?.currentUser?.uid
   FIRDatabase.database().reference().child("Users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//    print(snapshot)
    if let dict = snapshot.value as? [String:AnyObject] {
        self.userNameLbl.text = dict["name"] as? String
    }
    
    }, withCancelBlock: nil)

    
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
