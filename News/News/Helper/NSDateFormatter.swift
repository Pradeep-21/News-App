//
//  NSDateFormatter.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation

class NSDateFormatter: DateFormatter {
    static let utc = "UTC"
    private var formatter = DateFormatter()
    
    /// Add the Date Formatter type which type we want.
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            self.formatter.dateFormat = kDateFormate
            if let date = self.formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }
    
    // MARK: - Init methods

    override init() {
        super.init()
        customise()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom methods

    private func customise() {
        // We will have UTC timeZone as default timezone in dateFormatter. So, We have this timezone initially.
        timeZone = TimeZone(abbreviation: NSDateFormatter.utc)
    }
}
