//
//  newsListModel.swift
//  News
//
//  Created by Anbusekar Murugesan on 05/04/2022.
//

import Foundation
import Alamofire


// MARK: - Article List
struct NewsList: Codable {
    let status: String
    var totalResults: Int
    var articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    var Newsimage: Data?
    var isLiked: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
        case Newsimage
        case isLiked
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}


// MARK: - NEWS model request and parsing the response

protocol NewsParameterProtocol {
    func getBitcoinUrl() -> String
}

protocol NSNewsModelProtocol {
    typealias NewsFailureBlock = (_ withResponse: AFError?, _ failureStatus: Bool?) -> Void
    typealias NewsSuccessBlock = (_ newsData: NewsList) -> Void
    
    func fetchNewsDetails(successBlock: @escaping NewsSuccessBlock, failureBlock: @escaping NewsFailureBlock)
}

class NSNewsModel: NSNewsModelProtocol {
    
    // MARK: - Custom methods
    
    func fetchNewsDetails(successBlock: @escaping NewsSuccessBlock, failureBlock: @escaping NewsFailureBlock) {
        let url = getBitcoinUrl()
        let _ = NSNetworkManager.shared.getRequest(url: url, parameters: nil) { withResponse in
            if let responseData = withResponse?.data {
                do {
                    let newsData = try NSDecoder().decode(NewsList.self, from: responseData)
                    successBlock(newsData)
                }
                catch {
                    failureBlock(nil, false)
                }
            } else {
                failureBlock(nil, false)
            }
        } failureBlock: { response, cancelStatus in
            failureBlock(response?.error, cancelStatus)
        }
    }

}

extension NSNewsModel: NewsParameterProtocol {
    
    func getBitcoinUrl() -> String {
        return "\(APIs.getNEWSData.urlString)?q=\(NSArticles.bitcoin.type)&apiKey=\(kAPIKey)"
    }

}
