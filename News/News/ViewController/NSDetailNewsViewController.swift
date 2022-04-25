//
//  NSDetailNewsViewController.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import UIKit
import Alamofire

protocol LikeButtonDelegate {
    func likeButtonTapped(at: IndexPath)
}

class NSDetailNewsViewController: NSViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var likeButton: NSLikeButton!
    
    // MARK: - Stored Properties
    
    var article: Article?
    var delegate: LikeButtonDelegate?
    var selectedIndexPath: IndexPath?
    
    // MARK: - View Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail View"
    }
    
    // MARK: - Custom Methods
    
    @IBAction func likeButtonDidPressed(_ sender: Any) {
        if article?.isLiked == true {
            article?.isLiked = false
            likeButton.unLiked()
        } else {
            article?.isLiked = true
            likeButton.liked()
        }
        if let path = selectedIndexPath {
            delegate?.likeButtonTapped(at: path)
        }
    }
    
    override func customiseUI() {
        super.customiseUI()
        fetchImage()
        newsTitle.text = article?.title
        newsDescription.text = article?.articleDescription
        if let pubAt = article?.publishedAt {
            publishedAtLabel.text = "Published At: \(NSHelper.convertToUTC(dateToConvert: pubAt))"
        }
        if article?.isLiked == true {
            likeButton.liked()
        } else {
            likeButton.unLiked()
        }
    }
    
    
    private func fetchImage() {
        if let remoteImageURL = URL(string: article?.urlToImage ?? "") {
            AF.request(remoteImageURL).responseData { [weak self] (response) in
                if response.error == nil {
                    if let data = response.data {
                        self?.newsImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
}
