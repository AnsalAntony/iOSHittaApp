//
//  ReviewsViewController.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 23/09/22.
//

import UIKit

class ReviewsViewController: UIViewController, starRatingDelegate {
    
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var tableViewReviews: UITableView!
    @IBOutlet weak var lblRatingFrom: UILabel!
    @IBOutlet weak var lblTotalRating: UILabel!
    @IBOutlet weak var viewTotalRating: UIView!
    var myReviewAdded = false
    var allReviewClicked = false
    var starRatingValue = 0
    var ratingName = ""
    var ratingDec = ""
    var dateVal = Date()
    var  rewiewsList = [Any]()
    //private var rewiewsList: RewiewsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        self.setupNib()
        self.fetchReviewList()
        
    }
    
    func createReviewListArr(name: String, ratingValue: Int, dateVal: Date, ratingDec: String, profilePic: String){
        let setKeyValue: NSMutableDictionary = NSMutableDictionary()
        setKeyValue.setValue(name, forKey: "name")
        setKeyValue.setValue(ratingValue, forKey: "ratingValue")
        setKeyValue.setValue(dateVal, forKey: "date")
        setKeyValue.setValue(ratingDec, forKey: "ratingDec")
        setKeyValue.setValue(profilePic, forKey: "profilePic")
        self.rewiewsList.append(setKeyValue)
    }
    
    func setupUi(){
        self.viewTotalRating.layer.cornerRadius = 7
        self.viewTotalRating.clipsToBounds = true
    }
    func setupNib(){
        
        self.tableViewReviews.register(UINib(nibName: AppConstants.addRatingTableViewCell, bundle: nil), forCellReuseIdentifier: AppConstants.addRatingTableViewCell)
        self.tableViewReviews.register(UINib(nibName: AppConstants.myReviewTableViewCell, bundle: nil), forCellReuseIdentifier: AppConstants.myReviewTableViewCell)
        self.tableViewReviews.register(UINib(nibName: AppConstants.reviewsTableViewCell, bundle: nil), forCellReuseIdentifier: AppConstants.reviewsTableViewCell)
        self.tableViewReviews.register(UINib(nibName: AppConstants.viewAllRevieWTableViewCell, bundle: nil), forCellReuseIdentifier: AppConstants.viewAllRevieWTableViewCell)
        self.tableViewReviews.register(UINib(nibName: AppConstants.headerTableViewCell, bundle: nil), forCellReuseIdentifier: AppConstants.headerTableViewCell)
    }
    
    func fetchReviewList(){
        ProgressiveLoader.sharedInstance.showLoader(target: self, title: AppConstants.PleaseWait)
        HittaAPI.sharedInstance.getReviewList(companyId: "ctyfiintu") { [weak self] reviews, error in
            if error == nil {
                DispatchQueue.main.sync {
                    ProgressiveLoader.sharedInstance.dismissLoader(target: self!)
                    let companyArr = reviews?.result?.companies?.company
                    for arrVal in companyArr ?? []{
                        let name = arrVal.legalName ?? ""
                        self!.createReviewListArr(name: name, ratingValue: 3, dateVal: Date().addingTimeInterval(-15000), ratingDec: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", profilePic: "")
                    }
                    self?.tableViewReviews.reloadData()
                }
                
            } else {
                ProgressiveLoader.sharedInstance.dismissLoader(target: self!)
                self!.alertPresent(title: AppConstants.error, message: AppConstants.wrong)
            }
        }
        
    }
    
    
    @IBAction func viewAllReviewClicked(_ sender: Any) {
        for i in 1...20 {
            self.createReviewListArr(name: "TestName" + String(i), ratingValue: 4, dateVal: Date().addingTimeInterval(TimeInterval(-15000 + i)), ratingDec: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."+String(i), profilePic: "")
        }
        self.allReviewClicked = true
        self.btnViewAll.isHidden = true
        self.tableViewReviews.reloadData()
    }
        
}

// MARK: Table view Data source

extension ReviewsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return  1
        }else{
            if(!self.allReviewClicked){
                return  self.rewiewsList.count+1
            }else{
                return  self.rewiewsList.count
            }
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableViewReviews.dequeueReusableCell(withIdentifier: AppConstants.headerTableViewCell) as! HeaderTableViewCell
        if(section == 0){
            if(myReviewAdded){
                headerCell.labelHeaderTitle.text = AppConstants.yourReview
            }else{
                headerCell.labelHeaderTitle.text = ""
            }
        }else{
            if(self.allReviewClicked){
                headerCell.labelHeaderTitle.text = AppConstants.allReviews
            }else{
                headerCell.labelHeaderTitle.text = AppConstants.latestReviews
            }
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var values = UITableView.automaticDimension
        if(section == 0){
            if(!myReviewAdded){
                values = 0
                
            }
        }
        return values
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            if(self.myReviewAdded){
                let myRevieweCell = self.tableViewReviews.dequeueReusableCell(withIdentifier: AppConstants.myReviewTableViewCell, for: indexPath) as! MyReviewTableViewCell
                myRevieweCell.lblName.text = self.ratingName
                myRevieweCell.viewStarRating.rating = Double(self.starRatingValue)
                
                let formatter = RelativeDateTimeFormatter()
                formatter.unitsStyle = .full
                let string = formatter.localizedString(for: self.dateVal, relativeTo: Date())
                myRevieweCell.lblTime.text = string + " - hitta.se"
                if(self.ratingDec != ""){
                    myRevieweCell.lblReview.text = self.ratingDec
                    myRevieweCell.btnDscribeExperience.isHidden = true
                    myRevieweCell.lblReview.isHidden = false
                }else{
                    myRevieweCell.btnDscribeExperience.isHidden = false
                    myRevieweCell.lblReview.isHidden = true
                    myRevieweCell.btnDscribeExperience.addTarget(self, action: #selector(self.dscribeExperienceClicked), for: .touchUpInside)
                }
                return myRevieweCell
            }else{
                
                let addRatingCell = self.tableViewReviews.dequeueReusableCell(withIdentifier: AppConstants.addRatingTableViewCell, for: indexPath) as! AddRatingTableViewCell
                addRatingCell.viewStarRating.didFinishTouchingCosmos = {
                    rating in
                    print(Int(rating))
                    self.starRatingValue = Int(rating)
                    self.navigateRatingView()
                }
                return addRatingCell
            }
            
        }else{
            if(!self.allReviewClicked){
                if indexPath.row == (self.rewiewsList.count+1) - 1 {
                    let viewAllReviewCell = self.tableViewReviews.dequeueReusableCell(withIdentifier: AppConstants.viewAllRevieWTableViewCell, for: indexPath) as! ViewAllRevieWTableViewCell
                    return viewAllReviewCell
                }
            }
            
            let reviewesCell = self.tableViewReviews.dequeueReusableCell(withIdentifier: AppConstants.reviewsTableViewCell, for: indexPath) as! ReviewsTableViewCell
            let takeValues = self.rewiewsList[indexPath.row] as! NSMutableDictionary
            reviewesCell.lblName.text = takeValues["name"] as? String
            reviewesCell.lblReview.text = takeValues["ratingDec"] as? String
            let dateVal = takeValues["date"] as? Date ?? Date()
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            let string = formatter.localizedString(for: dateVal, relativeTo: Date())
            reviewesCell.lblTime.text = string + " - hitta.se"
            reviewesCell.viewStarRating.rating = takeValues["ratingValue"] as? Double ?? 0
            return reviewesCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == (self.rewiewsList.count+1) - 1 {
            for i in 1...20 {
                self.createReviewListArr(name: "TestName" + String(i), ratingValue: 4, dateVal: Date().addingTimeInterval(TimeInterval(-15000 + i)), ratingDec: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."+String(i), profilePic: "")
            }
            self.allReviewClicked = true
            self.btnViewAll.isHidden = true
            self.tableViewReviews.reloadData()
        }
    }
    
    @objc func dscribeExperienceClicked (_ sender: Any) {
        
        self.pushToRatingView()
    }
    
    func navigateRatingView(){
        self.pushToRatingView()
    }
    
    func pushToRatingView(){
        let reviewDetailVC = UIStoryboard(name:AppConstants.main, bundle:nil).instantiateViewController(withIdentifier:AppConstants.addReviewViewController) as! AddReviewViewController
        reviewDetailVC.ratingValue =  self.starRatingValue
        reviewDetailVC.takeRateName = self.ratingName
        reviewDetailVC.takeRateDec = self.ratingDec
        reviewDetailVC.delegateStarRating = self
        self.navigationController?.show(reviewDetailVC, sender: self)
    }
    func getStarRatingValue(ratingValue: Int, ratingName: String, ratingDec: String) {
        self.starRatingValue = ratingValue
        self.dateVal = Date()
        if(ratingName != "") {
            self.ratingName = ratingName
        }else{
            self.ratingName = AppConstants.anonymous
        }
        self.ratingDec = ratingDec
        self.myReviewAdded = true
        self.tableViewReviews.reloadData()
    }
    
    
}
