//
//  SpiesAndStubsTests.swift
//  SpiesAndStubsTests
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import XCTest

@testable import iOSGlobalSummity22

class ProductListViewControllerTests: XCTestCase {

    func testWhenDataSourceReturnProducts() throws {

        let products = [
            ProductListItemModel(id: "1", name: "Product 1", price: "$10.00"),
            ProductListItemModel(id: "2", name: "Product 2", price: "$2.00"),
            ProductListItemModel(id: "3", name: "Product 3", price: "$0.30")
        ]
        
        let dataSourceStub = ProductListDataSourceStubs(products: products,
                                                        title: "Test Products")
        let dataSourceSpy = ProductListDataSourceSpy(stub: dataSourceStub)
        
        let tracking = ProductListTrackingSpy()
        
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceSpy,
                                                                  tracking: tracking)
        
        let navigationController = UINavigationControllerSpy(rootViewController: productListViewController)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertEqual(productListViewController.products, products)
        XCTAssertEqual(productListViewController.title, "Test Products")
        XCTAssertTrue(tracking.didCallScreenDidAppear)
        XCTAssertEqual(dataSourceSpy.totalCalledTitle, 1)
        XCTAssertEqual(dataSourceSpy.totalCalledProducts, 1)
        XCTAssertNil(navigationController.presentedAlertMessage)
        XCTAssertNil(navigationController.presentedAlertTitle)
        XCTAssertNil(navigationController.pushProductDetailsById)
    }
    
    func testWhenDataSourceReturnProductsButFailReturnTitle() throws {

        let products = [
            ProductListItemModel(id: "34", name: "Product 34", price: "$5.50")
        ]
        
        let dataSourceStub = ProductListDataSourceStubs(products: products,
                                                        titleError: .titleNotFound)
        let dataSourceSpy = ProductListDataSourceSpy(stub: dataSourceStub)
        
        let tracking = ProductListTrackingSpy()
        
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceSpy,
                                                                  tracking: tracking)
        
        
        let navigationController = UINavigationControllerSpy(rootViewController: productListViewController)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertEqual(productListViewController.products, products)
        XCTAssertEqual(productListViewController.title, "Products")
        XCTAssertTrue(tracking.didCallScreenDidAppear)
        XCTAssertEqual(dataSourceSpy.totalCalledTitle, 1)
        XCTAssertEqual(dataSourceSpy.totalCalledProducts, 1)
        XCTAssertNil(navigationController.presentedAlertMessage)
        XCTAssertNil(navigationController.presentedAlertTitle)
        XCTAssertNil(navigationController.pushProductDetailsById)
    }
    
    func testWhenDataSourceWhenProductsWasNotFound() throws {

        let dataSourceStub = ProductListDataSourceStubs(productsError: .productsNotFound)
        let dataSourceSpy = ProductListDataSourceSpy(stub: dataSourceStub)
        
        let tracking = ProductListTrackingSpy()
        
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceSpy,
                                                                  tracking: tracking)
        
        let navigationController = UINavigationControllerSpy(rootViewController: productListViewController)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertTrue(productListViewController.products.isEmpty)
        XCTAssertNil(productListViewController.title)
        XCTAssertTrue(tracking.didCallScreenDidAppear)
        XCTAssertEqual(dataSourceSpy.totalCalledTitle, 0)
        XCTAssertEqual(dataSourceSpy.totalCalledProducts, 1)
        XCTAssertEqual(navigationController.presentedAlertTitle, "Error")
        XCTAssertEqual(navigationController.presentedAlertMessage, "Products do not found")
    }
    
    func testWhenDataSourceWhenTimeOut() throws {

        let dataSourceStub = ProductListDataSourceStubs(productsError: .networkError)
        let dataSourceSpy = ProductListDataSourceSpy(stub: dataSourceStub)
        
        let tracking = ProductListTrackingSpy()
        
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceSpy,
                                                                  tracking: tracking)
        
        let navigationController = UINavigationControllerSpy(rootViewController: productListViewController)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertTrue(productListViewController.products.isEmpty)
        XCTAssertNil(productListViewController.title)
        XCTAssertTrue(tracking.didCallScreenDidAppear)
        XCTAssertEqual(dataSourceSpy.totalCalledTitle, 0)
        XCTAssertEqual(dataSourceSpy.totalCalledProducts, 1)
        XCTAssertEqual(navigationController.presentedAlertTitle, "Error")
        XCTAssertEqual(navigationController.presentedAlertMessage, "Something went wrong")
    }
    
    func testWhenSelectAProduct() throws {

        let products = [
            ProductListItemModel(id: "1", name: "Product 1", price: "$10.00"),
            ProductListItemModel(id: "2", name: "Product 2", price: "$2.00"),
            ProductListItemModel(id: "3", name: "Product 3", price: "$0.30")
        ]
        
        let dataSourceStub = ProductListDataSourceStubs(products: products,
                                                        title: "Test Products")
        let dataSourceSpy = ProductListDataSourceSpy(stub: dataSourceStub)
        
        let tracking = ProductListTrackingSpy()
        
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceSpy,
                                                                  tracking: tracking)
        
        let navigationController = UINavigationControllerSpy(rootViewController: productListViewController)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertEqual(productListViewController.products, products)
        XCTAssertEqual(productListViewController.title, "Test Products")
        XCTAssertTrue(tracking.didCallScreenDidAppear)
        XCTAssertEqual(dataSourceSpy.totalCalledTitle, 1)
        XCTAssertEqual(dataSourceSpy.totalCalledProducts, 1)
        XCTAssertNil(navigationController.presentedAlertMessage)
        XCTAssertNil(navigationController.presentedAlertTitle)
        
        if let tableView = productListViewController.tableView {
            
            let indexPath = IndexPath(row: 2, section: 0)
            productListViewController.tableView(tableView, didSelectRowAt: indexPath)
        }
        
        XCTAssertEqual(navigationController.pushProductDetailsById, "3")
    }
}
