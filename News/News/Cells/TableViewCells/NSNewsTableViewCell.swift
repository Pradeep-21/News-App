//
//  NewsTableViewCell.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import UIKit
import Alamofire

class NSNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var likeButton: NSLikeButton!
    @IBOutlet weak var newsImageView: UIImageView!
    
    static let identifierForCell = "NSNewsTableViewCell"
    
    var delegate: LikeButtonDelegate?
    var newsImage: UIImage?
    var viewModel: NSNewsViewModel?
    var currentIndexPath: IndexPath?
    let activityIndicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customise()
    }
    
    private func customise() {
        newsImageView.layer.cornerRadius = 5
        activityIndicator.frame = newsImageView.frame
        activityIndicator.backgroundColor = UIColor(named: "paleGray")
    }
    
    @IBAction func likeButtonDidPressed(_ sender: Any) {
        if let indexPath = currentIndexPath {
            delegate?.likeButtonTapped(at: indexPath)
        }
    }
    
    func updateCell(with news: Article?) {
        startLoading()
        guard let remoteImageURL = URL(string: news?.urlToImage ?? "") else {
            return
        }
        AF.request(remoteImageURL).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    DispatchQueue.main.async {
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
        newsTitle.text = article?.title
        dateTitle.text = NSHelper.convertToUTC(dateToConvert: article?.publishedAt ?? "")
        if article?.isLiked == true {
            likeButton.liked()
        } else {
            likeButton.unLiked()
        }
    }
    
}
