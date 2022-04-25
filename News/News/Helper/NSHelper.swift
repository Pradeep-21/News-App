//
//  NSHelper.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation

class NSHelper: NSObject {
    
    // Convert the date formate
    class func convertToUTC(dateToConvert:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        let convertedDate = formatter.date(from: dateToConvert)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: convertedDate!)
    }
    
}
