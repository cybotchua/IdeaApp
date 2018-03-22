//
//  Idea.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import Foundation

class Idea {
    var title : String = ""
    var status : String = ""
    var date : String = ""
    var ideaID : String = ""
    var description : String = ""
    var imageURL : String = ""
    var likes : Int = 0
    var dislikes : Int = 0
    var comments : String = ""
    var location : String = ""
    
    
    init() {
        
    }
    
    init(ideaID: String, dict: [String : Any]) {
        self.ideaID = ideaID
        self.title = dict["title"] as? String ?? ""
        self.location = dict["location"] as? String ?? ""
        self.date = dict["date"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        self.imageURL = dict["imageURL"] as? String ?? ""
        self.status = dict["status"] as? String ?? "Not Started"
    }
    
    enum status : String {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case completed = "Completed"
        case incomplete = "Incomplete"
    }
    
    
    
}
