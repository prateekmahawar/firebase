//
//  ChatVC.swift
//  animatable
//
//  Created by Prateek Mahawar on 26/07/16.
//  Copyright © 2016 Prateek Mahawar. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController {
    
    var receiverName:User!

    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = receiverName.name
        
    }
    
    @IBOutlet weak var messageField: AnimatableTextField!

    
    @IBAction func sendBtnPressed(sender: AnyObject) {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = receiverName!.id!
        let fromId = String(FIRAuth.auth()?.currentUser?.uid)
        print(fromId)
        let timeStamp:NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text": messageField.text!, "toId": toId , "fromId": fromId , "timeStamp":timeStamp]
        childRef.updateChildValues(values)
        
    }
    @IBAction func cancelBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
