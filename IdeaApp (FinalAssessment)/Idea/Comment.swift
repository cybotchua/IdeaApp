//
//  Comment.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 23/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import Foundation

class Comment {
    var commenterFirstName : String = ""
    var commenterLastName : String = ""
    var comment : String = ""
    var commentID : String = ""
    var commenterID : String = ""
    var timeStamp : NSNumber = 0
    var commenterPhotoURL : String = ""
    
    init() {
        
    }
    
    init(commentID: String, dict: [String : Any]) {
        
        self.commentID = commentID
        self.comment = dict["comment"] as? String ?? ""
        self.commenterFirstName = dict["commenterFirstName"] as? String ?? ""
        self.commenterLastName = dict["commenterLastName"] as? String ?? ""
        self.commenterID = dict["commenterID"] as? String ?? ""
        self.timeStamp = dict["timeStamp"] as? NSNumber ?? 0
        self.commenterPhotoURL = dict["commenterPhotoURL"] as? String ?? ""
    }
    
    
}
