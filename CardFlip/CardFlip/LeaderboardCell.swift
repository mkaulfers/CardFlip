//
//  LeaderboardCell.swift
//  CardFlip
//
//  Created by Matthew Kaulfers on 2/1/20.
//  Copyright © 2020 Matthew Kaulfers. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {

    @IBOutlet var cellBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        cellBorder.layer.cornerRadius = 15
        cellBorder.clipsToBounds = true
        
        cellBorder.layer.shadowColor = UIColor.black.cgColor
        cellBorder.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    //MARK: - Variables
    @IBOutlet weak var highScoreName: UILabel!
    @IBOutlet weak var highScoreTime: UILabel!
    @IBOutlet weak var highScoreMatches: UILabel!
    @IBOutlet weak var highScoreAttempts: UILabel!
}
