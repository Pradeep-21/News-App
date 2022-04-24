//
//  NewsGridViewController.swift
//  News
//
//  Created by Anbusekar Murugesan on 05/04/2022.
//

import UIKit

class NSGridViewController: NSViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    
    var model: NSNewsViewModel?
    
    // MARK: - View Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - Custom Methods
    
    override func customiseUI() {
        super.customiseUI()
        registerCells()
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: String(describing: NewsCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: NewsCollectionViewCell.identifierForCell)
    }
    
    private func updateDataToListView() {
        let newsListVc = self.tabBarController?.viewControllers?[0] as? NSNewsListViewController
        if let data = model {
            newsListVc?.viewModel = data
        }
    }

}


extension NSGridViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.dataSource?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifierForCell, for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.updateCell(with: model?.dataSource?.articles[indexPath.row] )
        cell.delegate = self
        cell.currentIndexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 2 , height: self.collectionView.frame.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc  = storyBoard.instantiateViewController(withIdentifier: String(describing: NSDetailNewsViewController.self)) as? NSDetailNewsViewController {
            vc.modalPresentationStyle = .popover
            vc.article = model?.dataSource?.articles[indexPath.row]
            vc.delegate = self
            vc.selectedIndexPath = indexPath
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension NSGridViewController: NewsCollectionViewCellDelegate, DetailNewsViewControllerDelegate {
    
    func likeButtonTapped(at: IndexPath) {
        if let isLiked = model?.dataSource?.articles[at.row].isLiked {
            model?.dataSource?.articles[at.row].isLiked = !isLiked
        } else {
            model?.dataSource?.articles[at.row].isLiked = true
        }
        collectionView.reloadItems(at: [at])
        updateDataToListView()
    }
    
}
