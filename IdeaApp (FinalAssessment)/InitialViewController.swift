//
//  InitialViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 21/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(goToMainScreen), userInfo: nil, repeats: true)
    }
    
    @objc func goToMainScreen() {
        timer.invalidate()
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
        
        present(vc, animated: true, completion: nil)
    }

}
