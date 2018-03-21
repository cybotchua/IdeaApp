//
//  LoginViewController.swift
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
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createOneNowButton: UIButton!
    
    //--------------------------------Global Variables-------------------------------------------//

    var ref : DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
    }
    
    //--------------------------------Functions------------------------------------------------//
    
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

}


