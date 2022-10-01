//
//  ProductListViewControllerTests.swift
//  MockTests
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import XCTest
import SimpleMock
import Combine

@testable import iOSGlobalSummity22

class ProductListViewControllerTests: XCTestCase {

    func testWhenDataSourceReturnProducts() throws {
        
        let products = [
            ProductListItemModel(id: "1", name: "Product 1", price: "$10.00"),
            ProductListItemModel(id: "2", name: "Product 2", price: "$2.00"),
            ProductListItemModel(id: "3", name: "Product 3", price: "$0.30")
        ]
        
        let listId = "test_product_list"
        
        let productsFuture = Future<[ProductListItemModel], ProductListDataSourceError> { promise in
            
            promise(.success(products))
        }
        
        let titleFuture = Future<ProductListDataSource.Title, ProductListDataSourceError> { promise in
            
            promise(.success("Test Products"))
        }

        let dataSource = ProductListDataSourceMock()
        let tracking = ProductListTrackingMock()
        
        let productListViewController = ProductListViewController(listId: listId,
                                                                  dataSource: dataSource,
                                                                  tracking: tracking)
        
        
        let navigationController = UINavigationControllerMock(rootViewController: productListViewController)
        
        try dataSource.expect(method: .products(listId: listId)) { productsFuture }
        try dataSource.expect(method: .title(listId: listId), after: .products(listId: listId)) { titleFuture }
        
        try tracking.expect(method: .screenDidAppear) { Void() }
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.viewWillAppear(true)
        productListViewController.viewDidAppear(true)
        
        XCTAssertEqual(productListViewController.title, "Test Products")
        
        XCTAssertNoThrow(try dataSource.verify())
        XCTAssertNoThrow(try tracking.verify())
        XCTAssertNoThrow(try navigationController.verify())
    }
    
    func testWhenDataSourceReturnProductsButFailReturnTitle() throws {
        
        let products = [
            ProductListItemModel(id: "1", name: "Product 1", price: "$10.00"),
            ProductListItemModel(id: "2", name: "Product 2", price: "$2.00"),
            ProductListItemModel(id: "3", name: "Product 3", price: "$0.30")
        ]
        
        let titleAndListId = "Test Products"
        
        let productsFuture = Future<[ProductListItemModel], ProductListDataSourceError> { promise in
            
            promise(.success(products))
        }
        
        let titleFuture = Future<ProductListDataSource.Title, ProductListDataSourceError> { promise in
            
            promise(.failure(.titleNotFound))
        }

        let dataSource = ProductListDataSourceMock()
        let tracking = ProductListTrackingMock()
        
        let productListViewController = ProductListViewController(listId: titleAndListId,
                                                                  dataSource: dataSource,
                                                                  tracking: tracking)
        
        let navigationController = UINavigationControllerMock(rootViewController: productListViewController)
        
        try dataSource.expect(method: .products(listId: titleAndListId)) { productsFuture }
        try dataSource.expect(method: .title(listId: titleAndListId), after: .products(listId: titleAndListId)) { titleFuture }
        
        try tracking.expect(method: .screenDidAppear) { Void() }
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.viewWillAppear(true)
        productListViewController.viewDidAppear(true)
        
        XCTAssertEqual(productListViewController.title, "Products")
        
        XCTAssertNoThrow(try dataSource.verify())
        XCTAssertNoThrow(try tracking.verify())
        XCTAssertNoThrow(try navigationController.verify())
        
    }
    
    func testWhenDataSourceWhenProductsWasNotFound() throws {
        
        let titleAndListId = "Test Products"
        
        let productsFuture = Future<[ProductListItemModel], ProductListDataSourceError> { promise in
            
            promise(.failure(.productsNotFound))
        }

        let dataSource = ProductListDataSourceMock()
        let tracking = ProductListTrackingMock()
        
        let productListViewController = ProductListViewController(listId: titleAndListId,
                                                                  dataSource: dataSource,
                                                                  tracking: tracking)
        
        let navigationController = UINavigationControllerMock(rootViewController: productListViewController)
        
        try navigationController.expect(method: .presentAlert(title: "Error", message: "Products do not found")) { Void() }
        
        try dataSource.expect(method: .products(listId: titleAndListId)) { productsFuture }
        
        try tracking.expect(method: .screenDidAppear) { Void() }
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.viewWillAppear(true)
        productListViewController.viewDidAppear(true)
        
        XCTAssertNil(productListViewController.title)
        
        XCTAssertNoThrow(try dataSource.verify())
        XCTAssertNoThrow(try tracking.verify())
        XCTAssertNoThrow(try navigationController.verify())
    }
    
    func testWhenDataSourceWhenTimeOut() throws {
        
        let titleAndListId = "Test Products"
        
        let productsFuture = Future<[ProductListItemModel], ProductListDataSourceError> { promise in
            
            promise(.failure(.networkError))
        }

        let dataSource = ProductListDataSourceMock()
        let tracking = ProductListTrackingMock()
        
        let productListViewController = ProductListViewController(listId: titleAndListId,
                                                                  dataSource: dataSource,
                                                                  tracking: tracking)
        
        let navigationController = UINavigationControllerMock(rootViewController: productListViewController)
        
        try navigationController.expect(method: .presentAlert(title: "Error", message: "Something went wrong")) { Void() }
        
        try dataSource.expect(method: .products(listId: titleAndListId)) { productsFuture }
        
        try tracking.expect(method: .screenDidAppear) { Void() }
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.viewWillAppear(true)
        productListViewController.viewDidAppear(true)
        
        XCTAssertNil(productListViewController.title)
        
        XCTAssertNoThrow(try dataSource.verify())
        XCTAssertNoThrow(try tracking.verify())
        XCTAssertNoThrow(try navigationController.verify())
    }
    
    func testWhenSelectAProduct() throws {

        let products = [
            ProductListItemModel(id: "1", name: "Product 1", price: "$10.00"),
            ProductListItemModel(id: "2", name: "Product 2", price: "$2.00"),
            ProductListItemModel(id: "3", name: "Product 3", price: "$0.30")
        ]
        
        let titleAndListId = "Test Products"
        
        let productsFuture = Future<[ProductListItemModel], ProductListDataSourceError> { promise in
            
            promise(.success(products))
        }
        
        let titleFuture = Future<ProductListDataSource.Title, ProductListDataSourceError> { promise in
            
            promise(.success(titleAndListId))
        }

        let dataSource = ProductListDataSourceMock()
        let tracking = ProductListTrackingMock()
        
        let productListViewController = ProductListViewController(listId: titleAndListId,
                                                                  dataSource: dataSource,
                                                                  tracking: tracking)
        
        
        let navigationController = UINavigationControllerMock(rootViewController: productListViewController)
        
        try navigationController.expect(method: .pushProductDetails(productId: "3")) { Void() }
        
        try dataSource.expect(method: .products(listId: titleAndListId)) { productsFuture }
        try dataSource.expect(method: .title(listId: titleAndListId), after: .products(listId: titleAndListId)) { titleFuture }
        
        try tracking.expect(method: .screenDidAppear) { Void() }
        try tracking.expect(method: .showProduct(id: "3")) { Void() }
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.viewWillAppear(true)
        productListViewController.viewDidAppear(true)
        
        if let tableView = productListViewController.tableView {
            
            productListViewController.tableView(tableView,
                                                 didSelectRowAt: IndexPath(row: 2, section: 0))
        }
        
        XCTAssertEqual(productListViewController.title, titleAndListId)
        
        XCTAssertNoThrow(try dataSource.verify())
        XCTAssertNoThrow(try tracking.verify())
        XCTAssertNoThrow(try navigationController.verify())
    }
}
