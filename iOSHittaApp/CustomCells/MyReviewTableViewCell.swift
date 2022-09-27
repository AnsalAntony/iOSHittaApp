//
//  MyReviewTableViewCell.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 23/09/22.
//

import UIKit
import Cosmos

class MyReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDscribeExperience: UIButton!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewStarRating: CosmosView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewProfile: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewProfile.layer.cornerRadius = self.viewProfile.frame.height/2
        self.viewProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func dscribeExperienceClicked(_ sender: Any) {
    }
}
