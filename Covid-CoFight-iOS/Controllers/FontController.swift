//
//  FontController.swift
//  CovidGuard
//
//  Created by "" on 25/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import UIKit

enum FontWeight: String{
    case bold = "Bold"
    case semibold = "Semibold"
    case regular = "Regular"
}


class ProjectFonts{
    class func defaultFont(_ size:CGFloat,weight:FontWeight)->UIFont {
        return UIFont(descriptor: UIFontDescriptor(name: "SFProDisplay-\(weight.rawValue)", size: size), size: size)
    }
}

