//
//  LoginViewController.swift
//  NIBM Events
//
//  Created by Supun Srilal on 2/26/20.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    

    @IBAction func log(_ sender: UIButton) {
        if let email = userName.text, let password = userPass.text
               {
                   
                   Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                         
                       if let e = error{
                           print(e.localizedDescription)
                        let alert = UIAlertController(title: "Alert", message: "username or password have dought", preferredStyle: UIAlertController.Style.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                       }else{
                        self.dismiss(animated: true, completion: nil)
//                        self.performSegue(withIdentifier: K.loginSegue, sender: self)
//                        let alert = UIAlertController(title: "Alert", message: "Login is Succesfully", preferredStyle: UIAlertController.Style.alert)
//
//                                           // add an action (button)
//                                           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//
//                                           // show the alert
//                                           self.present(alert, animated: true, completion: nil)
                       }
                       
                          }
               }
    }
    
}
