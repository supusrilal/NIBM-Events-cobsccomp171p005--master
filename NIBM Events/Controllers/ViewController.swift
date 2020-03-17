//
//  ViewController.swift
//  NIBM Events
//
//  Created by Supun Srilal on 2/25/20.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Apptempdata.userHandle = Auth.auth().addStateDidChangeListener {(auth, user) in
                   
                   if user != nil {
                       self.performSegue(withIdentifier: "home", sender: nil)
                       
                   }
          }
        
        
      titleLable.text = ""
        let titleText = "NIBM EVENTS"
        var charIndex: Double = 0

                for letter in titleText{
                    print(0.1 * charIndex)

                    print(letter)
                    Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) {
                        (timer) in
                        self.titleLable.text?.append(letter)

                    }
                    charIndex += 1

                }
        
        
        
    }
    
    //Check User Siged In?
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    //End of Checking User Siged In?
    
   


}

