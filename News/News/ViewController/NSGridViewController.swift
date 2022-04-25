//
//  NSGridViewController.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import UIKit

class NSGridViewController: NSViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Stored Properties
    
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
        let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController
        let listVC = navigationController?.viewControllers.first as? NSNewsListViewController
        if let data = model {
            listVC?.viewModel = data
        }
    }

}

// MARK: - UICollectionViewDataSource Methods

extension NSGridViewController :  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.dataSource?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifierForCell, for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.newsImageView.image = nil
        cell.updateCell(with: model?.dataSource?.articles[indexPath.row] )
        cell.delegate = self
        cell.currentIndexPath = indexPath
        return cell
    }

}

//MARK: - UICollectionView Delegate Methods

extension NSGridViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 2 , height: self.collectionView.frame.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: NSDetailNewsViewController.self)) as? NSDetailNewsViewController else {
            return
        }
        detailVC.modalPresentationStyle = .popover
        detailVC.article = model?.dataSource?.articles[indexPath.row]
        detailVC.delegate = self
        detailVC.selectedIndexPath = indexPath
        navigationController?.present(detailVC, animated: true)
    }
    
}

extension NSGridViewController: LikeButtonDelegate {
    
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
