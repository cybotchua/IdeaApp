//
//  ContainerImageViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ContainerImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadImage(notification:)), name: NSNotification.Name(rawValue: "Pass Selected Idea"), object: nil)
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
    
    @objc func loadImage(notification: NSNotification) {
        guard let selectedIdea = notification.userInfo?["Selected Idea"] as? Idea else {return}
        
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users/\(uid)/ideas/\(selectedIdea.ideaID)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String : Any],
                    let imageURL = dict["imageURL"] as? String {
                    
                    self.getImage(imageURL, self.imageView)
                }
            })
        }
    }

}
