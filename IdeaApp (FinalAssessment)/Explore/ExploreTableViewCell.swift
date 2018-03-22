//
//  ExploreTableViewCell.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 23/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
