//
//  newMessageVC.swift
//  animatable
//
//  Created by Prateek Mahawar on 26/07/16.
//  Copyright © 2016 Prateek Mahawar. All rights reserved.
//

import UIKit
import Firebase


class newMessageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchUser()
        
    }
    func fetchUser() {
        FIRDatabase.database().reference().child("Users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject] {
                let user = User()
//                user.setValuesForKeysWithDictionary(dict)
                user.name = dict["name"] as? String
                user.email = dict["email"] as? String
                user.age = dict["age"] as? Int
                user.dob = dict["dob"] as? String
                user.mobile = dict["mobile"] as? Int
                user.profileImageUrl = dict["profileImageUrl"] as? String
                
                self.users.append(user)
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
            }
            
            
//            print("User Founds")
//            print(snapshot)
        
            }, withCancelBlock: nil)
    
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? contactListTVC {
        let user = users[indexPath.row]
        cell.ConfigureCell(user)
            
            return cell
        } else {
         return UITableViewCell()
        }
        
    }
   
    @IBAction func cancelBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
