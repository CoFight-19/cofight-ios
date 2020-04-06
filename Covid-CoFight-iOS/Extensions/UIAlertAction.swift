//
//  UIAlertAction.swift
//  CovidGuard
//
//  Created by "" on 25/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
