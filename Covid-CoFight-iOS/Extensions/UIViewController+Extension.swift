//
//  UIViewController+Extension.swift
//  CovidGuard
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {
    func openInAppWebsite(urlString:String) {
        if let url = URL(string: urlString){
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func popUpOptionDialog(_ title: String? = nil, content: String, cancelButtonText: String? = nil, okButtonText: String = "OK", onCompletion: ((_ okActionSelected: Bool) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        if let cancelText = cancelButtonText {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel) { (action) in
                onCompletion?(false)
            }
            alertController.addAction(cancelAction)
        }
        
        let okAction = UIAlertAction(title: okButtonText, style: .default) { (action) in
            onCompletion?(true)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
}
