//
//  NSDecoder.swift
//  NEWS
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation

protocol NSDecodeProtocol {
    /**
     Decode the response
     
     - Parameters:
        - type: Generic type of `Any Type`
        - Data: Send the response with type of Data
     - throws:
        - `T`:  Generic type of `Decoded data`.
     - Note:
        We add the condition that Generic type of the data must be conform to the `Decodable Protocol`
     */
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

class NSDecoder: NSDecodeProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        let dateFormatter = NSDateFormatter()
        return try dateFormatter.decoder.decode(type, from: data)
    }
}
