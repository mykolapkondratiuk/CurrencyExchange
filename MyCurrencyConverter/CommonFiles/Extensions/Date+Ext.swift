//
//  Date+Ext.swift
//  GitHubChecker
//
//  Created by Mykola Kondratyuk on 2/14/21.
//  Copyright © 2021 Mykola Kondratyuk  All rights reserved.
//

import Foundation

extension Date {
    static var now: Date { Date() }
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date {
    func daysFromToday() -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }
}

extension Date {
    var formattedNow: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let today = Date()
        return df.string(from: today)
    }

    func toString(dateFormat format: String = "yyyy-MM-dd", inUTC: Bool = false, locale: Locale = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = locale
        if inUTC {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        }
        
        return dateFormatter.string(from: self)
    }

    func isToday() -> Bool {
        return self.toString(dateFormat: "yyyy.MM.dd") == Date().toString(dateFormat: "yyyy.MM.dd")
    }

    func isTommorow() -> Bool {
        return self.toString(dateFormat: "yyyy.MM.dd") == Date(timeIntervalSinceNow: 60 * 60 * 24).toString(dateFormat: "yyyy.MM.dd")
    }

    func isYesterday() -> Bool {
        return self.toString(dateFormat: "yyyy.MM.dd") == Date(timeIntervalSinceNow: (-1) * 60 * 60 * 24).toString(dateFormat: "yyyy.MM.dd")
    }
}
