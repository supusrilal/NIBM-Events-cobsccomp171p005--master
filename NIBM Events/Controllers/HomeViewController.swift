//
//  HomeViewController.swift
//  NIBM Events
//
//  Created by Supun Srilal on 2/26/20.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var ref: DatabaseReference!
    var databaseHandel: DatabaseHandle!
    
    var postData = [String]()
    var itemName: [NSManagedObject] = []
    
   
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let pdata = postData[indexPath.row]
        let alertController = UIAlertController(title: "Example", message: "example", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
            
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default){(_) in
                   
               }
        
    
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        title = "Home"
        navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        
        databaseHandel = ref?.child("r1").observe(.childAdded, with: { (snapshot) in
            
            let post = snapshot.value as? String
            if let actualPost = post {
                
                self.postData.append(actualPost)
                self.tableView.reloadData()
            }
        })
        
    }
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    @IBAction func addEvent(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: K.EventSegue, sender: self)
    }
    
    
    @IBAction func addComment(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: K.commentSegue, sender: self)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        return cell!
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        var com = String()
    //        tableView.deselectRow(at: indexPath, animated: true)
    //
    //        let com2 = itemName[indexPath.row]
    //        com = (com2.value(forKey: "title") as? String)!
    //        print(com)
    //
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let secondvc = storyboard.instantiateViewController(withIdentifier: "CommentView") as! CommentViewController
    //      // secondvc.com = com2
    //        self.present(secondvc, animated: true, completion: nil)
    //
    //    }
    
    
    
}



