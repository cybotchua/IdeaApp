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
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var editImageView: UIImageView! {
        didSet {
            editImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(editImageViewTapped))
            editImageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var numberOfUnstartedIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfInProgressIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfIncompleteIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfCompleteIdeaLabel: UILabel!
    
    var ref : DatabaseReference!
    
    var numberOfUnstartedIdea : Int = 0
    var numberOfInProgressIdea : Int = 0
    var numberOfIncompleteIdea : Int = 0
    var numberOfCompleteIdea : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadDetails()
        loadStatusNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editImageView.isHidden = false
        firstNameLabel.isHidden = false
        lastNameLabel.isHidden = false
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @objc func cancelButtonTapped() {
        editImageView.isHidden = false
        firstNameLabel.isHidden = false
        lastNameLabel.isHidden = false
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @objc func doneButtonTapped() {
        editImageView.isHidden = false
        firstNameLabel.isHidden = false
        lastNameLabel.isHidden = false
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
        
        guard let newFirstName = firstNameTextField.text,
            let newLastName = lastNameTextField.text else {return}
        if firstNameLabel.text != firstNameTextField.text || lastNameLabel.text != lastNameTextField.text {
            showAlert(withTitle: "Name Change Successful", message: "Current name changed to: \(newFirstName) \(newLastName)")
        }
        firstNameLabel.text = newFirstName
        lastNameLabel.text = newLastName
        
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users/\(uid)").updateChildValues(["firstName" : newFirstName, "lastName" : newLastName])
        }
    }
    
    @objc func editImageViewTapped() {
        editImageView.isHidden = true
        firstNameLabel.isHidden = true
        lastNameLabel.isHidden = true
        firstNameTextField.isHidden = false
        lastNameTextField.isHidden = false
        doneButton.isHidden = false
        cancelButton.isHidden = false
        firstNameTextField.text = firstNameLabel.text
        lastNameTextField.text = lastNameLabel.text
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
    
    func loadStatusNumber() {
        
        
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users/\(uid)/ideas").observe(.value, with: { (snapshot) in
                
                self.numberOfCompleteIdea = 0
                self.numberOfInProgressIdea = 0
                self.numberOfUnstartedIdea = 0
                self.numberOfIncompleteIdea = 0

                if let ideaDict = snapshot.value as? [String : [String:Any]] {
                    for (_, v) in ideaDict {
                        if let status = v["status"] as? String {
                            switch status {
                            case "Not Started":
                                self.numberOfUnstartedIdea += 1
                                self.numberOfUnstartedIdeaLabel.text = "Number Of Unstarted Idea: \(self.numberOfUnstartedIdea)"
                            case "In Progress":
                                self.numberOfInProgressIdea += 1
                                self.numberOfInProgressIdeaLabel.text = "Number Of In Progress Idea: \(self.numberOfInProgressIdea)"
                            case "Completed":
                                self.numberOfCompleteIdea += 1
                                self.numberOfCompleteIdeaLabel.text = "Number Of Complete Idea: \(self.numberOfCompleteIdea)"
                            case "Not Completed":
                                self.numberOfIncompleteIdea += 1
                                self.numberOfIncompleteIdeaLabel.text = "Number Of Incomplete Idea: \(self.numberOfIncompleteIdea)"
                            default:
                                break
                            }
                            
                            
                        }
                    }
                    
                }
                
            })
        }
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
                        self.firstNameLabel.text = firstName
                        self.lastNameLabel.text = lastName
                        self.getImage(profilePicURL, self.imageView)
                    }
                    
                    
                }
                
            })
            
        }
    }
    
    
}
