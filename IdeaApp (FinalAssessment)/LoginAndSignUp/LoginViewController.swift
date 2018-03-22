//
//  MasterViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 21/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    //--------------------------------Outlets------------------------------------------------//
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.layer.borderWidth = 1.0
            iconImageView.layer.masksToBounds = false
            iconImageView.layer.borderColor = UIColor.white.cgColor
            iconImageView.layer.cornerRadius = iconImageView.frame.size.width / 2
            iconImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowColor = UIColor.white.cgColor
            shadowView.layer.shadowOpacity = 0.5
            shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
            shadowView.layer.shadowRadius = 5
            
        }
    }
    
    @IBOutlet weak var shadowView2: UIView! {
        didSet {
            shadowView2.layer.masksToBounds = false
            shadowView2.layer.shadowColor = UIColor.white.cgColor
            shadowView2.layer.shadowOpacity = 0.5
            shadowView2.layer.shadowOffset = CGSize(width: 1, height: 1)
            shadowView2.layer.shadowRadius = 5
            
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 10
            loginButton.layer.masksToBounds = false
            loginButton.layer.shadowColor = UIColor.white.cgColor
            loginButton.layer.shadowOpacity = 0.5
            loginButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            loginButton.layer.shadowRadius = 5
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
    }
    
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
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createOneNowButton: UIButton! {
        didSet {
            createOneNowButton.addTarget(self, action: #selector(createOneNowButtonTapped), for: .touchUpInside)
        }
    }
    
    //--------------------------------Global Variables-------------------------------------------//
    
    var ref : DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Login"
        
        loginButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    //--------------------------------Functions------------------------------------------------//

    @objc func createOneNowButtonTapped() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {return}
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
            else {
                loginButton.isEnabled = false
                return
        }
        loginButton.isEnabled = true
    }
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.showAlert(withTitle: "ERROR", message: validError.localizedDescription)
            }
            
            if user != nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {return}
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func signUpButtonTapped() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {return}
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



