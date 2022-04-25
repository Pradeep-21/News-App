//
//  NewsCollectionViewCell.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import UIKit
import Alamofire

class NewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsPublishedDateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var likeButton: NSLikeButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifierForCell = "NSNewsCollectionViewCell"
    
    private var news: Article?
    private var newsImage: UIImage?
    var currentIndexPath: IndexPath?
    var delegate: LikeButtonDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 5
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func likeButtonDidPressed(_ sender: Any) {
        if let data = currentIndexPath {
            delegate?.likeButtonTapped(at: data)
        }
    }
    
    func updateCell(with news: Article?) {
        startLoading()
        guard let remoteImageURL = URL(string: news?.urlToImage ?? "") else { return }
        AF.request(remoteImageURL).responseData { (response) in
            self.stopLoading()
            if response.error == nil {
                if let data = response.data {
                    DispatchQueue.main.async {
                        self.newsImage = UIImage(data: data)
                        self.internalUpdate(article: news)
                    }
                }
            }
        }
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func internalUpdate(article: Article?) {
        newsImageView.image = newsImage
        newsTitleLabel.text = article?.title
        newsPublishedDateLabel.text = NSHelper.convertToUTC(dateToConvert: article?.publishedAt ?? "")
        if article?.isLiked == true {
            likeButton.liked()
        } else {
            likeButton.unLiked()
            
        }
    }
    
}
