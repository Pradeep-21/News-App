//
//  NSNewsListViewController.swift
//  News
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import UIKit

class NSNewsListViewController: NSViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Stored Properties
    
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
        addLongPressGuester()
    }
    
    private func addLongPressGuester() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        tableView?.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NSNewsTableViewCell.identifierForCell, for: indexPath) as? NSNewsTableViewCell else {
                    return
                }
                let image = cell.newsImageView.image
                UIPasteboard.general.image = image
            }
        }
    }
    
    override func addBinding() {
        // This closure will call when the response was success and we reload the view
        viewModel.isReloadView.bind { [weak self] isReload in
            if isReload == true {
                DispatchQueue.main.async {
                    self?.passDataToGridView()
                    self?.tableView.reloadData()
                }
            }
        }
        // This closure will call when calling failure response.
        viewModel.errorMessage.bindAndFire { message in
            if message != "" {
                // Show the alert message
            }
        }
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: String(describing: NSNewsTableViewCell.self), bundle: nil), forCellReuseIdentifier: NSNewsTableViewCell.identifierForCell)
    }
    
    private func getNewsList() {
        viewModel.fetchNewsData()
    }
    
    private func passDataToGridView() {
        let navigationController = self.tabBarController?.viewControllers?[1] as? UINavigationController
        let gridVC = navigationController?.viewControllers.first as? NSGridViewController
        gridVC?.model = viewModel
    }
    
}

// MARK: - UITableViewDataSource Methods

extension NSNewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSNewsTableViewCell.identifierForCell, for: indexPath) as? NSNewsTableViewCell else {
            return UITableViewCell()
        }
        cell.newsImageView.image = nil
        cell.updateCell(with: self.viewModel.dataSource?.articles[indexPath.row])
        cell.viewModel = viewModel
        cell.currentIndexPath = indexPath
        cell.delegate = self
        return cell
    }
 
}

// MARK: - UITableViewDelegate Methods

extension NSNewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: NSDetailNewsViewController.self)) as? NSDetailNewsViewController else {
            return
        }
        detailVC.modalPresentationStyle = .popover
        detailVC.article = viewModel.dataSource?.articles[indexPath.row]
        detailVC.delegate = self
        detailVC.selectedIndexPath = indexPath
        navigationController?.present(detailVC, animated: true)
    }
    
}

extension NSNewsListViewController: LikeButtonDelegate {
    
    func likeButtonTapped(at: IndexPath) {
        if let isLiked = viewModel.dataSource?.articles[at.row].isLiked {
            viewModel.dataSource?.articles[at.row].isLiked = !isLiked
        } else {
            viewModel.dataSource?.articles[at.row].isLiked = true
        }
        tableView.reloadRows(at: [at], with: .none)
    }
    
}

