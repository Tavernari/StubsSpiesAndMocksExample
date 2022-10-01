//
//  ViewController.swift
//  iOSGlobalSummity22
//
//  Created by Victor C Tavernari on 19/08/2022.
//

import UIKit
import Combine

class ProductListViewController: UITableViewController {
    
    var products: [ProductListItemModel] = [] {
        
        didSet {
            
            self.tableView.reloadData()
        }
    }
    
    var cancellables: [AnyCancellable] = []
    
    private let dataSource: ProductListDataSource
    private let tracking: ProductListTracking
    private let listId: String
    
    init(listId: String,
         dataSource: ProductListDataSource,
         tracking: ProductListTracking) {
        
        self.dataSource = dataSource
        self.tracking = tracking
        self.listId = listId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentErrorAlert(message: String, onClose: (() -> Void)? ) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "Retry", style: .default, handler: { action in
            
            alertController.dismiss(animated: true, completion: onClose)
        }))
        
        self.navigationController?.present(alertController, animated: true)
    }
    
    func handleError(_ error: ProductListDataSourceError) {
        
        switch error {
            
        case .titleNotFound:
            self.title = "Products"
        case .productsNotFound:
            
            self.presentErrorAlert(message: "Products do not found") {
                
                self.navigationController?.popViewController(animated: true)
            }
            
        case .networkError:
            
            self.presentErrorAlert(message: "Something went wrong") {
                
                self.loadData()
            }
        }
    }
    
    func loadProducts(onLoaded: @escaping () -> Void) {
        
        let productsFuture = self.dataSource.products(from: self.listId).sink { completion in
            
            guard case let .failure(error) = completion else {
                
                return
            }
            
            self.handleError(error)
            
        } receiveValue: { products in
            
            self.products = products
            onLoaded()
        }
        
        self.cancellables.append(productsFuture)
    }
    
    func loadTitle() {
        
        let titleFuture = self.dataSource.title(by: self.listId).sink { completion in
            
            guard case let .failure(error) = completion else {
                
                return
            }
            
            self.handleError(error)
            
        } receiveValue: { title in
            
            self.title = title
        }
        
        self.cancellables.append(titleFuture)
    }
    
    func loadData() {
 
        self.loadProducts(onLoaded: self.loadTitle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tracking.screenDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cancellables.forEach { $0.cancel() }
    }
}

extension ProductListViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return self.products.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let product = self.products[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = product.name
        content.secondaryText = product.price
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let product = self.products[indexPath.row]
        self.tracking.showProduct(id: product.id)
        
        let productDetail = ProductDetailsViewController(productId: product.id)
        self.navigationController?.pushViewController(productDetail, animated: true)
    }
}

