//
//  AddRatingTableViewCell.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 23/09/22.
//

import UIKit
import Cosmos

class AddRatingTableViewCell: UITableViewCell {

    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewStarRating: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewProfile.layer.cornerRadius = self.viewProfile.frame.height/2
        self.viewProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
