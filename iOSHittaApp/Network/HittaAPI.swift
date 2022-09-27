//
//  HittaAPI.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 26/09/22.
//

import CoreLocation
import Foundation
import UIKit


final class HittaAPI {
    static let sharedInstance = HittaAPI()
    
    private var networkService: NetworkService {
        NetworkManager.sharedInstance
    }
    
    private init() {}
    
    private func executeRequest(urlString: String, parameters: [String: Any]? = nil, method: RequestMethod? = .get, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let request = URLRequest.prepareURLRequest(urlString: urlString, parameters: parameters, method: method) else {
            return
        }
        
        networkService.executeRequest(request) { data, error in
            completion(data, error)
        }
    }
    
    private func executePostRequest(urlString: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil, method: RequestMethod? = .post, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let request = URLRequest.prepareURLRequest(urlString: urlString, parameters: parameters, headers: headers, method: method) else {
            return
        }
        
        networkService.executeRequest(request) { data, error in
            completion(data, error)
        }
    }
    
    
    func getReviewList(companyId: String, with completion: @escaping (RewiewsModel?, Error?) -> Void) {
        let urlString = APIConstants.baseUrl + APIConstants.Endpoints.getReviews + companyId
        executeRequest(urlString: urlString) { data, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = data else {
                    return
                }
                let response = data.decodeTo(RewiewsModel.self)
                completion(response, nil)
            }
        }
    }
    
    func postReview(comment: String, name: String, score: Int, with completion: @escaping (_ responceValue:Any?, Error?) -> Void) {
        let urlString = APIConstants.baseUrlPostReview + APIConstants.Endpoints.postReview
        executePostRequest(urlString: urlString, parameters: ["score": score, "companyId": "ctyfiintu", "comment": comment, "userName": name], headers: ["Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8","X-HITTA-DEVICE-NAME":" MOBILE_WEB", "X-HITTA-SHARED-IDENTIFIER":"15188693697264027"]) { data, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = data else {
                    return
                }
                let response = String (data: data, encoding: String.Encoding.utf8)
                completion(response, nil)
            }
        }
    }
    
}
