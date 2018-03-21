//
//  Extension.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 21/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //Show alert for validation of signUp and signIn process
    func showAlert(withTitle title: String, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
}
