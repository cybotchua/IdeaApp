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

class MasterViewController: UIViewController {
    
    //--------------------------------Outlets------------------------------------------------//
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 20.0)!, forKey: NSAttributedStringKey.font as NSCopying)
            segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
            
            segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
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
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var signUpContainerView: UIView!
    
    //--------------------------------Global Variables-------------------------------------------//
    
    var ref : DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
    }
    
    //--------------------------------Functions------------------------------------------------//
    
    @objc func indexChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            containerView.isHidden = true
        case 1:
            containerView.isHidden = false
        default:
            break
        }
    }
    
    
    
}



