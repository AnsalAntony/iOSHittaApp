//
//  NetworkManager.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 26/09/22.
//

import Foundation
import UIKit

/**
  Responsible for executing URLRequest objects and handles undelying URLSession
 */
final class NetworkManager: NetworkService {
    /**

         A shared instance of `NetworkManager`, used to perform URLRequests
     */
    static let sharedInstance = NetworkManager()
    private var sessionManager: URLSession?

    private init() {}

    func executeRequest(_ request: URLRequest, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        if sessionManager == nil {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            sessionManager = URLSession(configuration: configuration)
        }

        let urlSessionTask = sessionManager?.dataTask(with: request) { data, _, error in
            completion(data, error)
        }
        urlSessionTask?.resume()
    }

    func cancelAllRequests() {
        sessionManager?.invalidateAndCancel()
    }
}
