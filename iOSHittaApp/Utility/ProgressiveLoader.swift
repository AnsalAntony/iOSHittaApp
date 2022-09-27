//
//  ProgressiveLoader.swift
//  iOSHittaApp
//
//  Created by Ansal Antony on 26/09/22.
//

import Foundation
import UIKit
import MBProgressHUD

class ProgressiveLoader: NSObject {

    static let sharedInstance = ProgressiveLoader()

    // MARK: - SHOW/HIDE Loader

    func showLoader(target : UIViewController, title : String?) -> Void {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: target.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.label.text = title
            hud.isUserInteractionEnabled = false
            target.isEditing = false
            target.view.isUserInteractionEnabled = false
        }
    }

    func dismissLoader(target : UIViewController) -> Void {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: (target as AnyObject).view, animated: true)
            target.isEditing = true
            target.view.isUserInteractionEnabled = true
        }
    }

}

