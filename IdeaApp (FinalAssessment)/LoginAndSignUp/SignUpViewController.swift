//
//  SignUpViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 21/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailShadowView: UIView! {
        didSet {
            emailShadowView.layer.masksToBounds = false
            emailShadowView.layer.shadowColor = UIColor.white.cgColor
            emailShadowView.layer.shadowOpacity = 0.5
            emailShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
            emailShadowView.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var firstNameShadowView: UIView! {
        didSet {
            firstNameShadowView.layer.masksToBounds = false
            firstNameShadowView.layer.shadowColor = UIColor.white.cgColor
            firstNameShadowView.layer.shadowOpacity = 0.5
            firstNameShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
            firstNameShadowView.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var lastNameShadowView: UIView! {
        didSet {
            lastNameShadowView.layer.masksToBounds = false
            lastNameShadowView.layer.shadowColor = UIColor.white.cgColor
            lastNameShadowView.layer.shadowOpacity = 0.5
            lastNameShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
            lastNameShadowView.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var passwordShadowView: UIView! {
        didSet {
            passwordShadowView.layer.masksToBounds = false
            passwordShadowView.layer.shadowColor = UIColor.white.cgColor
            passwordShadowView.layer.shadowOpacity = 0.5
            passwordShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
            passwordShadowView.layer.shadowRadius = 5
            
        }
    }
    
    @IBOutlet weak var confirmPasswordShadowView: UIView! {
        didSet {
            confirmPasswordShadowView.layer.masksToBounds = false
            confirmPasswordShadowView.layer.shadowColor = UIColor.white.cgColor
            confirmPasswordShadowView.layer.shadowOpacity = 0.5
            confirmPasswordShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
            confirmPasswordShadowView.layer.shadowRadius = 5
            
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 10
            signUpButton.layer.masksToBounds = false
            signUpButton.layer.shadowColor = UIColor.white.cgColor
            signUpButton.layer.shadowOpacity = 0.5
            signUpButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            signUpButton.layer.shadowRadius = 5
            
            signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        }
    }
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Sign Up"

        
    }
    
    @objc func signUpButtonTapped() {
        guard let email = emailTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {return}
        
        //Input Validation
        if !email.contains("@") {
            showAlert(withTitle: "Invalid Email Format", message: "Please input a valid email")
        } else if password.count < 7 {
            showAlert(withTitle: "Invalid Password", message: "Password must be at least 7 characters long")
        } else if confirmPassword != password {
            showAlert(withTitle: "Passwords Do Not Match", message: "Please enter the same passwords")
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                //Error
                if let validError = error {
                    self.showAlert(withTitle: "ERROR", message: validError.localizedDescription)
                }
                
                
                //Successful Creation of New User
                if let validUser = user {
                    
                    if let image = self.profileImageView.image {
                        self.uploadToStorage(image)
                    }
                    
                    let newUser : [String : Any] = ["email" : email, "firstName" : firstName, "lastName" : lastName]
                    
                    self.ref.child("users").child(validUser.uid).setValue(newUser)
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {return}
                    
                    self.navigationController?.popToRootViewController(animated: false)
                    
                    self.present(vc, animated: false, completion: nil)
                }
            })
        }
    }
    
    @objc func imageViewTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadToStorage(_ image: UIImage) {
        let storageRef = Storage.storage().reference()
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        storageRef.child(uid).child("profilePic").putData(imageData, metadata: metaData) { (meta, error) in
            
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let downloadURL = meta?.downloadURL()?.absoluteString {
                self.ref.child("users").child(uid).child("profilePicURL").setValue(downloadURL)
            }
        }
    }
    
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        profileImageView.image = image
        
    }
    
}
