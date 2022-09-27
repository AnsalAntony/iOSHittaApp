//
//  AddReviewViewController.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 23/09/22.
//

import UIKit
import Cosmos

protocol  starRatingDelegate  {
    func getStarRatingValue(ratingValue: Int,ratingName: String, ratingDec: String)
}

class AddReviewViewController: UIViewController {
    
    @IBOutlet weak var textRatingDec: UITextView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var lblRatingText: UILabel!
    @IBOutlet weak var textViewMoreDetails: UITextView!
    @IBOutlet weak var ratingViewcosmo: CosmosView!
    var placeholderLabel : UILabel!
    var ratingValue = 1
    var delegateStarRating : starRatingDelegate?
    var takeRateName = ""
    var takeRateDec = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textName.text = self.takeRateName
        self.textRatingDec.text = self.takeRateDec
        self.setupStarView()
        self.setupPlaceHolder()
        self.setRatingText()
    }
    
    func setupStarView(){
        self.ratingViewcosmo.rating = Double(self.ratingValue)
        self.ratingViewcosmo.settings.fillMode = .full
        self.ratingViewcosmo.didFinishTouchingCosmos = {
            rating in
            print(Int(rating))
            self.ratingValue = Int(rating)
            self.setRatingText()
        }
    }
    
    func setupPlaceHolder(){
        self.textViewMoreDetails.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = AppConstants.addReviewPlaceHolder
        placeholderLabel.font = .systemFont(ofSize: (self.textViewMoreDetails.font?.pointSize)!)
        
        placeholderLabel.sizeToFit()
        self.textViewMoreDetails.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.textViewMoreDetails.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !self.textViewMoreDetails.text.isEmpty
    }
    
    func setRatingText(){
        switch self.ratingValue  {
        case 1:
            self.lblRatingText.text = AppConstants.oneStar
        case 2:
            self.lblRatingText.text = AppConstants.twoStars
        case 3:
            self.lblRatingText.text = AppConstants.threeStars
        case 4:
            self.lblRatingText.text = AppConstants.fourStars
        default:
            self.lblRatingText.text = AppConstants.fiveStars
        }
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        ProgressiveLoader.sharedInstance.showLoader(target: self, title: AppConstants.PleaseWait)
        HittaAPI.sharedInstance.postReview(comment: self.textRatingDec.text ?? "", name: self.textName.text ?? "", score: self.ratingValue) { [weak self] reviews, error in
            if error == nil {
                DispatchQueue.main.sync {
                    ProgressiveLoader.sharedInstance.dismissLoader(target: self!)
                    let alertController = UIAlertController(title: AppConstants.saveReviewAlertTitle , message: AppConstants.saveReviewAlertDec, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: AppConstants.ok, style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self?.delegateStarRating?.getStarRatingValue(ratingValue: self?.ratingValue ?? 0, ratingName: self?.textName.text ?? "", ratingDec: self?.textRatingDec.text ?? "")
                        self?.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
                
            } else {
                ProgressiveLoader.sharedInstance.dismissLoader(target: self!)
                self!.alertPresent(title: AppConstants.error, message: AppConstants.wrong)
            }
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddReviewViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
