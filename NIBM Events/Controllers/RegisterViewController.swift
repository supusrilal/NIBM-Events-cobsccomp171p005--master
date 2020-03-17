//
//  RegisterViewController.swift
//  NIBM Events
//
//  Created by Supun Srilal on 2/26/20.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Photos

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var btnAddAvatar: UIButton!
    @IBOutlet weak var nameLB: UITextField!
    @IBOutlet weak var phoneNumberLB: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signPassword: UITextField!
    @IBOutlet weak var confirmPasswordLB: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //Form Date
    var name: String?
    var phoneNumber: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    
    //MARK:- Variables
    var keyField: String?
    var messageError: String?
    var imagePicker:UIImagePickerController!
    var dbReference: DatabaseReference!
    var downloadImageUrl: String = ""
    var imageOriginal: String = ""
    var userarr: [User] = []
    
    //Property Observer
    var imagUrlSet = 0 {
        didSet{
            print("Did Set Setted : \(downloadImageUrl)")
            
            self.signup()
        }
    }
    //End Property Oberver
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpImagePicker()
    }
    
    func setupUI(){
        self.avatarImg.layer.cornerRadius = self.avatarImg.bounds.height / 2
        self.btnRegister.layer.cornerRadius = 5
    }
    
    func signUpWithVlidation() {
        if validateFormData() {
            if validateValue(with: .password) && validateValue(with: .email) {
                self.uploadImage()
            } else {
                loadingStop()
            }
        } else {
            loadingStop()
        }
    }
    
    func getFormData(){
        //Assign form data
        self.name = self.nameLB.text
        self.phoneNumber = self.phoneNumberLB.text
        self.email = self.signEmail.text
        self.password = self.signPassword.text
        self.confirmPassword = self.confirmPasswordLB.text
        
    }
    
    func validateFormData()-> Bool {
        
        guard self.name != nil else {
            self.messageError = "Missing Name"
            showAlert(title: "Warning", message: self.messageError ?? "", action: .init(title: "OK"))
            return false
        }
        
        guard self.email != nil else {
            self.messageError = "Missing Email"
            showAlert(title: "Warning", message: self.messageError ?? "", action: .init(title: "OK"))
            return false
        }
        
        guard self.phoneNumber != nil else {
            self.messageError = "Missing Phone Number"
            showAlert(title: "Warning", message: self.messageError ?? "", action: .init(title: "OK"))
            return false
        }
        
        guard self.password != nil else {
            self.messageError = "Missing Password"
            showAlert(title: "Warning", message: self.messageError ?? "", action: .init(title: "OK"))
            return false
        }
        
        guard self.confirmPasswordLB != nil else {
            self.messageError = "Missing Confirm Password"
            showAlert(title: "Warning", message: self.messageError ?? "", action: .init(title: "OK"))
            return false
        }
        
        return true
    }
    
   func showAlert(title: String?, message: String, action: AlertAction) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func validateValue(with key: keyType) -> Bool{
        
        switch key {
            case .email:
                if email?.contains("@") ?? false { return true } else {
                    showAlert(title: "Warning", message: "Invalid email", action: .init(title: "OK"))
                }
            case .password:
                if password == confirmPassword { return true } else {
                    showAlert(title: "Warning", message: "Invalid Password", action: .init(title: "OK"))
                }
        }
        
        return true
        
    }
    
    //Start Save Data
    func signup(){
        
        let userdata = User(uName: self.name ?? "", uPhone: self.phoneNumber ?? "", uProfImgUrl: self.downloadImageUrl , uEmail: self.email ?? "" , uPassword: self.password ?? "")
        
        
        self.userarr.append(userdata)
        
        Auth.auth().createUser(withEmail: self.email ?? "", password: self.password ?? "") { authResult, error in
            // ...
            
            if error == nil && authResult != nil {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                self.dbReference = Database.database().reference().child("user/profile/\(uid)")
                
                let user = [
                    "uName": self.userarr[0].uName as String,
                    "uEmail": self.userarr[0].uEmail as String,
                    "uPhone": self.userarr[0].uPhone as String,
                    "uProfileImage": self.userarr[0].uProfImgUrl as String
                    ] as [String: Any]
                
                
                self.dbReference!.setValue(user){errorsave, ref in
                    
                    if errorsave != nil{
                        
                        self.loadingStop()
                        let alert = UIAlertController(title: "Sign Up Error!", message: errorsave?.localizedDescription, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                    }else{
                        self.loadingStop()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            } else {
                if error != nil{
                    let alert = UIAlertController(title: "Sign Up Error!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
             
        }
        
    }
    //End Save Data
    
    func loadingStart(){
        self.btnRegister.isHidden = true
        self.loading.startAnimating()
    }
    
    func loadingStop(){
        self.btnRegister.isHidden = false
        self.loading.stopAnimating()
    }
    //Start Upload Image
    func uploadImage(){
        
        let storageRef = Storage.storage().reference()
        
        // Data in memory
        guard let data = self.avatarImg.image?.jpegData(compressionQuality: 0.75) else {return}
        let image: UIImage = self.avatarImg.image!
        print("Image Data : \(image)")
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/user/\(imageOriginal)")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            print("Meta Data : \(metadata)")
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            let url = riversRef.downloadURL { (url, error) in
                
                guard let downloadURL = url else {
                    
                    print("Error Img :\(error)")
                    return
                }
                
                self.downloadImageUrl = downloadURL.absoluteString
                
                if self.downloadImageUrl != "" {self.imagUrlSet = 1}
                print("Download URL \(self.downloadImageUrl)")
                
            }
            
            print("URL : \(self.downloadImageUrl)")
        }
        
    }
    //End Upload Image
    
    @IBAction func register(_ sender: UIButton) {
        loadingStart()
        getFormData()
        signUpWithVlidation()
    }
        
//        if let email = signEmail.text, let password = signPassword.text{
//
//            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                if let e = error{
//                    print(e.localizedDescription)
//
//                } else {
//                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
//                }
//            }
//        }
//    }
    
    func setUpImagePicker(){
        //Add image picker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        //end adding image picker
        
        //image View Config
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        avatarImg.isUserInteractionEnabled = true
        avatarImg.addGestureRecognizer(imageTap)
        btnAddAvatar.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        //end Image View Config
    }
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnAvatarSet(_ sender: Any) { }
    
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            print("Image Name : \(imgName)")
            self.imageOriginal = imgName
            let imgExtension = imgUrl.pathExtension
            print("Image Type : \(imgExtension)")
        }
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.avatarImg.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

struct AlertAction {
    var title: String?
    var style: UIAlertAction.Style
    
    init(title: String, style: UIAlertAction.Style = .default) {
        self.title = title
        self.style = style
    }
}

enum keyType: String {
    case email
    case password
}
