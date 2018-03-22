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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var mapContainerView: UIView!
    
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
