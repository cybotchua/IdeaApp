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
    
    @IBOutlet weak var commentTableView: UITableView! {
        didSet {
            commentTableView.dataSource = self
            commentTableView.rowHeight = 100
        }
    }
    
    @IBOutlet weak var addCommentButton: UIButton! {
        didSet {
            addCommentButton.addTarget(self, action: #selector(addCommentButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var commentCancelButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    var selectedIdea : Idea = Idea()
    
    var ref : DatabaseReference!
    
    var comments : [Comment] = []
    
    var commenterPhotoURL : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadDetails()
        
        observeComments()
        
        let notification = Notification(name: Notification.Name.init("Pass Selected Idea"), object: nil, userInfo: ["Selected Idea" : selectedIdea])
        NotificationCenter.default.post(notification)
        
        commentTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

        
        customView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editImageView.isHidden = false
        statusLabel.isHidden = false
        statusTextField.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    func observeComments() {
        ref.child("ideas/\(selectedIdea.ideaID)/comments").observe(.childAdded) { (snapshot) in
            if let commentDict = snapshot.value as? [String : Any] {
                
                let aComment = Comment(commentID: snapshot.key, dict: commentDict)
                
                DispatchQueue.main.async {
                    self.comments.append(aComment)
                    let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
                    self.commentTableView.insertRows(at: [indexPath], with: .automatic)
                    self.commentTableView.reloadData()
                }
            }
            
        }
    }
    
    @objc func addCommentButtonTapped() {
        customView.isHidden = false
        
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let userDict = snapshot.value as? [String : Any],
                    let firstName = userDict["firstName"] as? String,
                    let lastName = userDict["lastName"] as? String,
                    let profilePicURL = userDict["profilePicURL"] as? String {
                    
                    self.commenterPhotoURL = profilePicURL
                    
                    DispatchQueue.main.async {
                        self.firstNameLabel.text = firstName
                        self.lastNameLabel.text = lastName
                        self.getImage(self.commenterPhotoURL, self.profileImageView)
                    }
                }
            })
        }
        
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        commentButton.layer.cornerRadius = 10
        commentButton.layer.borderWidth = 1
        
        commentCancelButton.addTarget(self, action: #selector(commentCancelButtonTapped), for: .touchUpInside)
        commentCancelButton.layer.cornerRadius = 10
        commentCancelButton.layer.borderWidth = 1
        addCommentButton.isHidden = true
        commentLabel.isHidden = true
        commentButton.isEnabled = false
    }
    
    @objc func commentCancelButtonTapped() {
        customView.isHidden = true
        addCommentButton.isHidden = false
        commentLabel.isHidden = false
    }
    
    
    
    @objc func commentButtonTapped() {
        
        if let commenterUID = Auth.auth().currentUser?.uid,
            let comment = commentTextField.text,
            let commenterFirstName = firstNameLabel.text,
            let commenterLastName = lastNameLabel.text {
            
            let timeStamp = Date().timeIntervalSince1970
                let commentDict : [String : Any] = ["comment" : comment, "commenterFirstName" : commenterFirstName, "commenterLastName" : commenterLastName, "timeStamp" : timeStamp, "commenterUID" : commenterUID, "ideaUID" : selectedIdea.ideaID, "commenterPhotoURL" : commenterPhotoURL]
            
            let path = ref.child("comments").childByAutoId()
            
            path.setValue(commentDict)
            
            ref.child("ideas/\(selectedIdea.ideaID)/comments").updateChildValues([path.key : commentDict])
            
            customView.isHidden = true
            addCommentButton.isHidden = false
            commentLabel.isHidden = false
            commentTextField.text = ""
        }
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
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard let comment = commentTextField.text,
            !comment.isEmpty
            else {
                commentButton.isEnabled = false
                return
        }
        commentButton.isEnabled = true
    }


}

extension IdeaDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CommentsTableViewCell else {return UITableViewCell()}
        
        let firstName = comments[indexPath.row].commenterFirstName
        let lastName = comments[indexPath.row].commenterLastName
        
        cell.nameLabel.text = "\(firstName) \(lastName)"
        cell.commentTextView.text = comments[indexPath.row].comment
        getImage(comments[indexPath.row].commenterPhotoURL, cell.commenterImageView)
        
        return cell
    }
    
}
