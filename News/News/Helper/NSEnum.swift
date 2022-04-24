//
//  NSEnum.swift
//  NEWS
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation

enum NSArticles {
    case bitcoin
    
    var type: String {
        switch self {
        case .bitcoin:
            return "bitcoin"
        }
    }
}
