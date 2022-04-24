//
//  NewsTableViewCell.swift
//  News
//
//  Created by Anbusekar Murugesan on 05/04/2022.
//

import UIKit
import Alamofire

protocol NewsTableViewCellDelegate {
    func likeButtonTapped(at: IndexPath)
}

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var NewsTitle: UILabel!
    @IBOutlet weak var likeButton: NSLikeButton!
    @IBOutlet weak var NewsImageView: UIImageView!
    
    static let identifierForCell = "NewsTableViewCell"
    
    var delegate: NewsTableViewCellDelegate?
    var newsImage: UIImage?
    var viewModel: NSNewsViewModel?
    var currentIndexPath: IndexPath?
    let activityIndicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NewsImageView.layer.cornerRadius = 5
        activityIndicator.frame = NewsImageView.frame
        activityIndicator.backgroundColor = .loaderWhiteBackgroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        if let indexPath = currentIndexPath {
            delegate?.likeButtonTapped(at: indexPath)
        }
    }
    
    func updateCell(with news: Article?) {
        startLoading()
     
            if  let remoteImageURL = URL(string: news?.urlToImage ?? "") {
                AF.request(remoteImageURL).responseData { (response) in
                    if response.error == nil {
                        print(response.result)
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
        NewsImageView.image = newsImage
        NewsTitle.text = article?.title
        dateTitle.text = NewsHelper.convertToUTC(dateToConvert: article?.publishedAt ?? "")
        if article?.isLiked == true {
            likeButton.liked()
        } else {
            likeButton.unLiked()
            
        }
        
    }
    
}


extension UIColor {
    class var loaderWhiteBackgroundColor: UIColor {
        return UIColor(red: 0.0/250.0, green: 0.0/250.0, blue: 0.0/250.0, alpha: 0.2)
    }
}
