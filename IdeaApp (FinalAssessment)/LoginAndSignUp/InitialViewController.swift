//
//  InitialViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 21/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {

    var timer = Timer()
    
    var firstTimeChecker : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(goToMainScreen), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(goToMainScreen), userInfo: nil, repeats: true)

    }
    
    @objc func goToMainScreen() {
        timer.invalidate()
        
        if Auth.auth().currentUser != nil {
            
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {return}
            
            present(vc, animated: true, completion: nil)
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
            
            present(vc, animated: true, completion: nil)
        }
        
        
    }

}
