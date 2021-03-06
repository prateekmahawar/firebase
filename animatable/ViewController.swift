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
   
    @IBOutlet weak var registerComplete: UIActivityIndicatorView!
    @IBOutlet weak var userField: AnimatableTextField!
    @IBOutlet weak var passField: AnimatableTextField!
   
    override func viewDidAppear(animated: Bool) {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            print("User already logged in")
            self.moveToProfile()
        } else {
           
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerComplete.hidden = true
    }
    
    @IBAction func signInPressed(sender: AnyObject) {
        registerComplete.hidden = false
        registerComplete.startAnimating()
        view.userInteractionEnabled = false
        
        guard let email = userField.text , pass = passField.text else { return }
        
        FIRAuth.auth()?.signInWithEmail(email, password: pass, completion: { (user, error) in
            if error != nil {
                print(error)
                self.registerComplete.hidden = true
                self.registerComplete.stopAnimating()
                self.view.userInteractionEnabled = true
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
        registerComplete.hidden = true
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