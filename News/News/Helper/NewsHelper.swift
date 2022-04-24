//
//  NewsHelper.swift
//  News
//
//  Created by Anbusekar Murugesan on 09/04/2022.
//

import Foundation

class NewsHelper: NSObject {
    
    class func convertToUTC(dateToConvert:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        let convertedDate = formatter.date(from: dateToConvert)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: convertedDate!)
        
    }
    
}
