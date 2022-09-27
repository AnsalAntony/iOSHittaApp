//
//  DataDecode.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 26/09/22.
//

import Foundation
import UIKit


extension Data {
    func decodeTo<T: Decodable>(_ type: T.Type) -> T? {
        do {
            let response = try JSONDecoder().decode(type, from: self)
            return response
        } catch let jsonError {
            print("Json Decoding Error",jsonError)
            return nil
        }
    }
}

// MARK: - alert View
extension UIViewController {
    
    func  alertPresent(title: String, message: String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppConstants.okVal, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
