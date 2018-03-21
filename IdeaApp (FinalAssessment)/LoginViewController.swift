//
//  LoginViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 21/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 20.0)!, forKey: NSAttributedStringKey.font as NSCopying)
            segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        }
    }
    
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
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
