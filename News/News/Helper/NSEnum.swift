//
//  NSEnum.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation

// We add the Articles type in enum, if we want another type we add here and use to url path.
enum NSArticles {
    case bitcoin
    
    var type: String {
        switch self {
        case .bitcoin:
            return "bitcoin"
        }
    }
}
