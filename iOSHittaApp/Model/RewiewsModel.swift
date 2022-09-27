//
//  RewiewsModel.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 26/09/22.
//

import Foundation

// MARK: - CanadaBaseModel
struct RewiewsModel: Codable {
    let result: Result?
}

struct Result: Codable {
    let companies: Companies?
}

struct Companies: Codable {
    
    let total: Int?
    let included: Int?
    var company: [Company]
    
    enum CodingKeys: String, CodingKey {
        case total
        case included
        case company = "company"
    }
    
}

struct Company: Codable {
    
    let id: String?
    let displayName: String?
    let legalName: String?
    let orgno: String?
    let suffix: String?
    let allowReviews: Bool?
    let reviews: Reviews?
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case legalName
        case orgno
        case suffix
        case allowReviews
        case reviews
    }
    
}

struct Reviews: Codable {
    
    let score: Double?
    let count: Int?
    
    enum CodingKeys: String, CodingKey {
        case score
        case count
    }
}
