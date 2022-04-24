//
//  NSAlamofire.swift
//  NEWS
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation

// Type of the response's content.
enum NSContentType: String {
    case json
    
    var type: String {
        switch self {
        case .json:
            return "application/json"
        }
    }
}

// URL path and For the testing purpose we add the URL path same for three different schemes.
#if DEBUG
let kBaseURL = "https://newsapi.org"
#elseif RELEASE
let kBaseURL = "https://newsapi.org"
#else
let kBaseURL = "https://newsapi.org"
#endif

// APIs Path
enum APIs {
    case getNEWSData
    
    var urlString: String {
        switch self {
        case .getNEWSData:
            return "\(kBaseURL)\(kAPIVersion)everything"
        }
    }
    
    var url: URL {
        return URL(string: urlString)! // Force unwrap doesn't cause any impact
    }
}
