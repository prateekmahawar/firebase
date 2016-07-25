//
//  ViewController.swift
//  animatable
//
//  Created by Prateek Mahawar on 23/07/16.
//  Copyright © 2016 Prateek Mahawar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController{
    var isSuccess : Bool = false
    
    @IBOutlet weak var userField: AnimatableTextField!
    @IBOutlet weak var passField: AnimatableTextField!
   
    override func viewDidAppear(animated: Bool) {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            print("User already logged in")
            self.moveToProfile()
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInPressed(sender: AnyObject) {
        guard let email = userField.text , pass = passField.text else { return }
        
        FIRAuth.auth()?.signInWithEmail(email, password: pass, completion: { (user, error) in
            if error != nil {
                print(error)
            } else {
                
                print("First Login Complete")
                self.moveToProfile()
            }
        })
        
        }
    func moveToProfile() {
        print("In Function")
        performSegueWithIdentifier("profileVC", sender: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        userField.text = nil
        passField.text = nil
    }
    
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if (nextResponder != nil ) {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}