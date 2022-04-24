//
//  NewsListViewController.swift
//  News
//
//  Created by Anbusekar Murugesan on 05/04/2022.
//

import UIKit

class NSNewsListViewController: NSViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: NSNewsViewModel = NSNewsViewModel(model: NSNewsModel())
    
    // MARK: - View Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()   
    }
    
    // MARK: - Custom methods
    
    override func customiseUI() {
        super.customiseUI()
        registerCells()
        getNewsList()
    }
    
    override func addBinding() {
        viewModel.isReloadView.bind { [weak self] isReload in
            if isReload == true {
                self?.passDatatoGridView()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: String(describing: NewsTableViewCell.self), bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identifierForCell)
    }
    
    private func getNewsList() {
        viewModel.fetchNewsData()
    }
    
    private func passDatatoGridView() {
        let secondTab = self.tabBarController?.viewControllers?[1] as? NSGridViewController
        secondTab?.model = viewModel
    }
    
}

extension NSNewsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifierForCell, for: indexPath) as? NewsTableViewCell {
            cell.updateCell(with: self.viewModel.dataSource?.articles[indexPath.row])
            cell.viewModel = viewModel
            cell.currentIndexPath = indexPath
            cell.delegate = self
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc  = storyBoard.instantiateViewController(withIdentifier: String(describing: NSDetailNewsViewController.self)) as? NSDetailNewsViewController {
            vc.modalPresentationStyle = .popover
            vc.article = viewModel.dataSource?.articles[indexPath.row]
            vc.delegate = self
            vc.selectedIndexPath = indexPath
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension NSNewsListViewController: NewsTableViewCellDelegate, DetailNewsViewControllerDelegate {
    
    func likeButtonTapped(at: IndexPath) {
        if let isLiked = viewModel.dataSource?.articles[at.row].isLiked {
            viewModel.dataSource?.articles[at.row].isLiked = !isLiked
        } else {
            viewModel.dataSource?.articles[at.row].isLiked = true
        }
        tableView.reloadRows(at: [at], with: .none)
    }
    
}

