//
//  RegisterVC.swift
//  animatable
//
//  Created by Prateek Mahawar on 23/07/16.
//  Copyright © 2016 Prateek Mahawar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterVC: UIViewController {
    
    @IBOutlet weak var registerComplete: UIActivityIndicatorView!
   
    
    @IBOutlet weak var nameField: AnimatableTextField!
    @IBOutlet weak var emailField: AnimatableTextField!
    @IBOutlet weak var dobField: AnimatableTextField!
    @IBOutlet weak var mobileField: AnimatableTextField!
    @IBOutlet weak var passField: AnimatableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerComplete.hidden = true

    }
    @IBAction func submitBtnPreseed(sender: AnyObject) {
        registerComplete.hidden = false
        registerComplete.startAnimating()
        view.userInteractionEnabled = false
        
        guard let name = nameField.text , password = passField.text , dob = dobField.text , mobile = mobileField.text , email = emailField.text else {
        return }
    
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        guard let dobprop = formatter.dateFromString(dob) else { return }
        
        if isValidEmail(email) && dobprop.age > 18 && name.characters.count > 0 && password.characters.count > 5 && mobile.characters.count > 0
        {
            FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user:FIRUser?, error) in
                guard let uid = user?.uid else {
                    return
                }
                if error != nil {
                    print(error)
                } else {
                    let ref = FIRDatabase.database().referenceFromURL("https://animatable-f00d2.firebaseio.com/")
                    let usersReference = ref.child("Users").child((uid))
                    let values = ["name":name, "email":email,"dob":dob,"mobile":mobile,"age":dobprop.age]
                    usersReference.updateChildValues(values as [NSObject : AnyObject], withCompletionBlock: {
                        (err,ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        self.registerComplete.stopAnimating()
                        print("Saved to Database")
                        self.registerComplete.hidden = true
                        self.goToProfile()
                    })
                }
            })
            
        } else {
            let alert = UIAlertController(title: "Incomplete Form", message: "Please fill the complete form and you must be 18 years old to access this app and passowrd should be more than 6 characters", preferredStyle: .Alert)
            let OkAction = UIAlertAction(title: "OK", style: .Default) {
                action -> () in
                
            }
            alert.addAction(OkAction)
             self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    func goToProfile() {
        
        self.performSegueWithIdentifier("profileVC", sender: nil)
    }
   
    @IBAction func backBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}

extension RegisterVC: UITextFieldDelegate {
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
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == dobField {
            if range.length > 0
            {
                return true
            }
            
            //Dont allow empty strings
            if string == " "
            {
                return false
            }
            
            
            if range.location == 10
            {
                return false
            }
            
            var originalText = textField.text
            let replacementText = string.stringByReplacingOccurrencesOfString("/", withString: "")
            
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            for char in replacementText.unicodeScalars
            {
                if !digits.longCharacterIsMember(char.value)
                {
                    return false
                }
            }
            
            if originalText!.characters.count == 2 || originalText!.characters.count == 5
            {
                originalText?.appendContentsOf("/")
                textField.text = originalText
            }
            let set = NSCharacterSet(charactersInString: notAllowedCharacters);
            let inverted = set.invertedSet
            
            let filtered = string
                .componentsSeparatedByCharactersInSet(inverted)
                .joinWithSeparator("")
            return filtered != string

            
        }
        
        if textField == mobileField {
            
            if range.location == 10
            {
                return false
            }
            
            let replacementText = string.stringByReplacingOccurrencesOfString("/", withString: "")
            
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            for char in replacementText.unicodeScalars
            {
                if !digits.longCharacterIsMember(char.value)
                {
                    return false
                }
            }
            
            let set = NSCharacterSet(charactersInString: notAllowedCharacters);
            let inverted = set.invertedSet
            
            let filtered = string
                .componentsSeparatedByCharactersInSet(inverted)
                .joinWithSeparator("")
            return filtered != string


        }
        
        
        return true
}
    
}