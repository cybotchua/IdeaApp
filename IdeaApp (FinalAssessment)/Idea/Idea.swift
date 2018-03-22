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
    var status : status = .notStarted
    var date : String = ""
    var ideaID : String = ""
    var description : String = ""
    var imageURL : String = ""
    var likes : Int = 0
    var dislikes : Int = 0
    var comments : String = ""
    
    
    init() {
        
    }
    
    enum status : String {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case completed = "Completed"
        case incomplete = "Incomplete"
    }
    
    
    
}
