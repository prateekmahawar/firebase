//
//  ProfileVC.swift
//  animatable
//
//  Created by Prateek Mahawar on 25/07/16.
//  Copyright © 2016 Prateek Mahawar. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUserName()
        getMessages()
        
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
    var messages = [Message]()
    
    func getMessages() {
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            print(snapshot)
            
            if let dict = snapshot.value as? [String:AnyObject] {
                let message = Message()
                message.setValuesForKeysWithDictionary(dict)
                self.messages.append(message)
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                
            }
            
            }, withCancelBlock: nil)
        
    }
    
    
    func showChatVC() {
        performSegueWithIdentifier("ShowChatVC", sender: nil)
    }
    
    @IBAction func newMessagePressed(sender: AnyObject) {
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
       let message = messages[indexPath.row]
        cell?.textLabel?.text = message.text
        
        return cell!
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
