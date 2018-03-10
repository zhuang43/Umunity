//
//  WelcomeViewController.swift
//  UCSCForum
//
//  Created by MacDouble on 3/3/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import UIKit
import Firebase
class WelcomeViewController: UIViewController {

    
    var name : String?
    var bio : String?
    var profileImageUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        if Auth.auth().currentUser != nil{
        let uid = Auth.auth().currentUser?.uid
        var ref = Database.database().reference().child("users").child(uid!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.name = value!["name"] as! String
            self.bio = value!["about"] as! String
            self.profileImageUrl = value!["profileImageUrl"] as! String
            
            
            UserDefaults.standard.setValuesForKeys(["name": self.name])
            UserDefaults.standard.setValuesForKeys(["bio": self.bio])
            UserDefaults.standard.setValuesForKeys(["profileImageUrl": self.profileImageUrl])
            
        })
        }
        var timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(viewTransfer), userInfo: nil, repeats: true)

    }

    @objc func viewTransfer(){
          self.performSegue(withIdentifier: "showAppSegue", sender: self)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
