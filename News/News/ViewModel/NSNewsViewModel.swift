//
//  NSNEWSListViewModel.swift
//  NEWS
//
//  Created by Pradeep Selvaraj on 24/04/22.
//

import Foundation
import UIKit

protocol NSReloadProtocol {
    var isReloadView: Observable<Bool> { get }
}

protocol NSNewsListViewModelProtocol: NSReloadProtocol {}

class NSNewsViewModel: NSNewsListViewModelProtocol {
    
    var isReloadView: Observable<Bool> = Observable(false)
    private let model: NSNewsModelProtocol
    var dataSource: NewsList?
    
    // MARK: - Init methods
    
    init(model: NSNewsModelProtocol) {
        self.model = model
    }
    
    // MARK: - Custom methods
    
    func fetchNewsData() {
        model.fetchNewsDetails { [weak self] newsData in
            guard let self = self else { return }
            self.dataSource = newsData
            self.isReloadView.value = true
        } failureBlock: { withResponse, failureStatus in
            // Handling the failure case
        }
    }
    
    
    
}
