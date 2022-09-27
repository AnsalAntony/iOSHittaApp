//
//  APIConstants.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 26/09/22.
//

import Foundation


struct APIConstants {
    static let baseUrl = "https://api.hitta.se/"
    static let baseUrlPostReview = "https://test.hitta.se/"

    struct Endpoints {
        static let getReviews = "search/v7/app/company/"
        static let postReview = "reviews/v1/company"
    }
}
