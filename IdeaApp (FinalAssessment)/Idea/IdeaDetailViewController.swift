//
//  IdeaDetailViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var dislikesLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    
    var selectedIdea : Idea = Idea()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
        
        let notification = Notification(name: Notification.Name.init("Pass Selected Idea"), object: nil, userInfo: ["Selected Idea" : selectedIdea])
        NotificationCenter.default.post(notification)

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
        statusLabel.text = selectedIdea.status
        likesLabel.text = "\(selectedIdea.likes) likes"
        dislikesLabel.text = "\(selectedIdea.dislikes) dislikes"
        
    }


}
