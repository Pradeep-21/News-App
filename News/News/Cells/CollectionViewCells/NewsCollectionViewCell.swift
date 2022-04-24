//
//  NewsCollectionViewCell.swift
//  News
//
//  Created by Anbusekar Murugesan on 07/04/2022.
//

import UIKit
import Alamofire

protocol NewsCollectionViewCellDelegate {
    func likeButtonTapped(at: IndexPath)
}

class NewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsPublishedDateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var likeButton: NSLikeButton!
    
    static let identifierForCell = "NewsCollectionViewCell"
    let activityIndicator = UIActivityIndicatorView()
    var news: Article?
    var newsImage: UIImage?
    var currentIndexPath: IndexPath?
    var delegate: NewsCollectionViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.frame = contentView.frame
        newsImageView.layer.cornerRadius = 5
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        if let data = currentIndexPath {
            delegate?.likeButtonTapped(at: data)
        }
    }
    
    func updateCell(with news: Article?) {
        startLoading()
        if let remoteImageURL = URL(string: news?.urlToImage ?? "") {
            AF.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    if let data = response.data {
                        self.stopLoading()
                        self.newsImage = UIImage(data: data)
                        self.internalUpdate(article: news)
                    }
                }
            }
        }
    }
    
    private func startLoading() {
        contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.startAnimating()
        activityIndicator.removeFromSuperview()
    }
    

    private func internalUpdate(article: Article?) {
        newsImageView.image = newsImage
        newsTitleLabel.text = article?.title
        newsPublishedDateLabel.text = NewsHelper.convertToUTC(dateToConvert: article?.publishedAt ?? "")
        if article?.isLiked == true {
            likeButton.liked()
        } else {
            likeButton.unLiked()
            
        }
    }
    
}
