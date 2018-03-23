//
//  ProfileViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var numberOfUnstartedIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfInProgressIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfIncompleteIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfCompleteIdea: UILabel!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadDetails()
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let image = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }
    
    func loadDetails() {
        if let uid = Auth.auth().currentUser?.uid {
            
            ref.child("users/\(uid)").observe(.value, with: { (snapshot) in
                
                if let userDict = snapshot.value as? [String : Any],
                    let email = userDict["email"] as? String,
                    let firstName = userDict["firstName"] as? String,
                    let lastName = userDict["lastName"] as? String,
                    let profilePicURL = userDict["profilePicURL"] as? String {
                    
                    DispatchQueue.main.async {
                        self.emailLabel.text = email
                        self.nameLabel.text = "\(firstName) \(lastName)"
                        self.getImage(profilePicURL, self.imageView)
                    }
                    
                    
                }
                
            })
            
        }
    }


}
