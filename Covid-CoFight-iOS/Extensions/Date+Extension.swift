//
//  Date+Extension.swift
//  Covid-CoFight-iOS
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
extension Date {
    var secondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    mutating func changeSeconds(by seconds: Int) {
        self = Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
}
