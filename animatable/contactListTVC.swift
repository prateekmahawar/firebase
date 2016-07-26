//
//  contactListTVC.swift
//  animatable
//
//  Created by Prateek Mahawar on 26/07/16.
//  Copyright © 2016 Prateek Mahawar. All rights reserved.
//

import UIKit

class contactListTVC: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        imgView.layer.masksToBounds = true
    }

    @IBOutlet weak var imgView: UIImageView!
 
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    func ConfigureCell(user:User) {
        emailLbl.text = user.email
        ageLbl.text = "Age: \(user.age!)"
        dobLbl.text = user.dob
        nameLbl.text = user.name
        if let profileImageUrl = user.profileImageUrl {
            let url = NSURL(string: profileImageUrl)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    self.imgView.image = UIImage(data: data!)
                })
                
            }).resume()
        }
        
    }
    
}
