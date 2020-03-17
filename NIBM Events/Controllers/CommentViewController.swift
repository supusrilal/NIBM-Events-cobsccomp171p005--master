//
//  CommentViewController.swift
//  NIBM Events
//
//  Created by Supun Srilal on 3/1/20.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import UIKit
import CoreData
import Firebase
//import FirebaseFirestore

class CommentViewController: UIViewController{
    


    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
      let db = Firestore.firestore()
    
    var messages: [Message] = [
    Message(sender: "abc@gmail.com", body: "hey"),
     Message(sender: "xyz@gmail.com", body: "hi"),
     Message(sender: "xyzg@gmail.com", body: "hfdfi"),
        Message(sender: "xyzg@gmail.com", body: "hfdfi"),
        Message(sender: "xyzg@gmail.com", body: "hfdfi"),
        Message(sender: "xyzg@gmail.com", body: "hfdfi"),
        Message(sender: "xyzg@gmail.com", body: "hfdfi"),
        Message(sender: "xyzg@gmail.com", body: "hfdfi"),
        Message(sender: "xyzg@gmail.com", body: "hfdfi"),
        Message(sender: "xyzg@gmail.com", body: "hfdfi"),
        Message(sender: "xyzg@gmail.com", body: "hfdfi")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
    func loadMessages(){
        
        
        db.collection(K.FStore.collectionName).addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error{
                print("have error \(e)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                            let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendPressed(_ sender: Any) {
        
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email{
            
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody
            ]) { (error) in
                if let e = error{
                    
                    print("there is error \(e)")
                }
                else{
                    print("data save")
                }
            }
            
        }
        
        
    }
    
    
}
extension CommentViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.lable.text = messages[indexPath.row].body
        return cell
    }
    
    
    
    
}

