//
//  NSNetworkManager.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation
import Alamofire

protocol NSResponseProtocol {
    typealias SuccessBlock = (_ withResponse: AFDataResponse<Any>?) -> Void
    typealias FailureBlock = (_ response: AFDataResponse<Any>?, _ cancelStatus: Bool?) -> Void
}

protocol NSNetworkManagerProtocol: NSResponseProtocol {
    func getRequest(url: URLConvertible, parameters: [String: Any]?, successBlock: @escaping SuccessBlock, failureBlock: @escaping FailureBlock) -> Request
}

class NSNetworkManager: NSObject, NSNetworkManagerProtocol {
    
    static var httpHeaders: HTTPHeaders = [:]
    static let shared: NSNetworkManager = NSNetworkManager()
    
    
    private func requestFromServer(url: URLConvertible, httpMethod: HTTPMethod, parameters: [String: Any]?, encoding: ParameterEncoding, headers: HTTPHeaders?, successBlock: @escaping SuccessBlock, failureBlock: @escaping FailureBlock) -> Request {
        
        return AF.request(url, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                successBlock(response)
            case .failure(_):
                // To validate failureBlock
                failureBlock(response, false)
            }
        }
    }
    
    // MARK: - Request Methods
    
    @discardableResult
    func getRequest(url: URLConvertible, parameters: [String: Any]?, successBlock: @escaping SuccessBlock, failureBlock: @escaping FailureBlock) -> Request {
        return requestFromServer(url: url, httpMethod: .get, parameters: parameters, encoding: JSONEncoding.default, headers: NSNetworkManager.httpHeaders, successBlock: successBlock, failureBlock: failureBlock)
    }
    
    // MARK: - Custom Methods
    
    class func updateAuthorizationHeaders() {
        NSNetworkManager.httpHeaders = addHeader()
    }
    
    class func addHeader() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        headers[kContentType] = NSContentType.json.type
        return headers
    }
    
}
