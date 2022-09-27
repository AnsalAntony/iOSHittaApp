//
//  NetworkService.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 26/09/22.
//

import Foundation

/// The Protocol implemented by Netwroking classes
protocol NetworkService {
    /**
         Execute URLRequest and send response in completion block
         - parameter request: The request has to be send
         - parameter completion: The code to be executed once the request has finished.
     */
    func executeRequest(_ request: URLRequest, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
}
