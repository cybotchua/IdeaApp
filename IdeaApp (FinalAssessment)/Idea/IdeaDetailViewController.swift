//
//  IdeaDetailViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class IdeaDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, forKey: NSAttributedStringKey.font as NSCopying)
            segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
            
            segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
            
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    @IBOutlet weak var imageContainerView: UIView! {
        didSet {
            imageContainerView.isHidden = true
        }
    }
    
    @IBOutlet weak var mapContainerView: UIView! {
        didSet {
            mapContainerView.isHidden = false
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var statusTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var editImageView: UIImageView! {
        didSet {
            editImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(editImageViewTapped))
            editImageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var dislikeButton: UIButton! {
        didSet {
            dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var dislikesLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    
    var selectedIdea : Idea = Idea()
    
    var ref : DatabaseReference!
    
//    var likesCount : Int = 0
//
//    var dislikesCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadDetails()
        
        let notification = Notification(name: Notification.Name.init("Pass Selected Idea"), object: nil, userInfo: ["Selected Idea" : selectedIdea])
        NotificationCenter.default.post(notification)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editImageView.isHidden = false
        statusLabel.isHidden = false
        statusTextField.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @objc func likeButtonTapped() {
        likeButton.isEnabled = false
        dislikeButton.isEnabled = true
        
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users/\(uid)/ideas/\(selectedIdea.ideaID)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let ideaDict = snapshot.value as? [String : Any],
                    var likesCount = ideaDict["numberOfLikes"] as? Int {
                    likesCount += 1
                    
                    let likeDict = ["numberOfLikes" : likesCount]
                    self.ref.child("users/\(uid)/ideas/\(self.selectedIdea.ideaID)").updateChildValues(likeDict)
                    
                    self.likesLabel.text = "\(likesCount) likes"
                }
            })
        }
    }
    
    @objc func dislikeButtonTapped() {
        dislikeButton.isEnabled = false
        likeButton.isEnabled = true
        
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users/\(uid)/ideas/\(selectedIdea.ideaID)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let ideaDict = snapshot.value as? [String : Any],
                    var dislikesCount = ideaDict["numberOfDislikes"] as? Int {
                    dislikesCount += 1
                    
                    let dislikeDict = ["numberOfDislikes" : dislikesCount]
                    self.ref.child("users/\(uid)/ideas/\(self.selectedIdea.ideaID)").updateChildValues(dislikeDict)
                    
                    self.dislikesLabel.text = "\(dislikesCount) dislikes"
                }
            })
        }
    }
    
    @objc func cancelButtonTapped() {
        editImageView.isHidden = false
        statusLabel.isHidden = false
        statusTextField.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @objc func doneButtonTapped() {
        editImageView.isHidden = false
        statusLabel.isHidden = false
        statusTextField.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
        
        guard let newStatus = statusTextField.text else {return}
        if statusLabel.text != statusTextField.text {
            showAlert(withTitle: "Status Change Successful", message: "Current status changed to: \(newStatus)")
        }
        statusLabel.text = newStatus
        
        if let uid = Auth.auth().currentUser?.uid {
        ref.child("users/\(uid)/ideas/\(selectedIdea.ideaID)").updateChildValues(["status" : newStatus])
        
        ref.child("ideas/\(selectedIdea.ideaID)/").updateChildValues(["status" : newStatus])
            
        }
    }
    
    @objc func editImageViewTapped() {
        editImageView.isHidden = true
        statusLabel.isHidden = true
        statusTextField.isHidden = false
        doneButton.isHidden = false
        cancelButton.isHidden = false
        statusTextField.text = statusLabel.text
    }
    
    @objc func indexChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            imageContainerView.isHidden = true
            mapContainerView.isHidden = false
        case 1:
            mapContainerView.isHidden = true
            imageContainerView.isHidden = false
        default:
            break
        }
    }
    
    func loadDetails() {
        titleLabel.text = selectedIdea.title
        descriptionTextView.text = selectedIdea.description
        dateLabel.text = selectedIdea.date
        statusLabel.text = selectedIdea.status.rawValue
        likesLabel.text = "\(selectedIdea.likes) likes"
        dislikesLabel.text = "\(selectedIdea.dislikes) dislikes"
        
    }


}
