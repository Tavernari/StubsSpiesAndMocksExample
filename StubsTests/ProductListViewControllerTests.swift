//
//  SpiesAndStubsTests.swift
//  SpiesAndStubsTests
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import XCTest

@testable import iOSGlobalSummity22

class ProductListViewControllerTests: XCTestCase {
    
    lazy var trackingDummy = ProductListTrackingDumy()

    func testWhenDataSourceReturnProducts() throws {

        let products = [
            ProductListItemModel(id: "1", name: "Product 1", price: "$10.00"),
            ProductListItemModel(id: "2", name: "Product 2", price: "$2.00"),
            ProductListItemModel(id: "3", name: "Product 3", price: "$0.30")
        ]
        
        let dataSourceStub = ProductListDataSourceStubs(products: products,
                                                        title: "Test Products")

        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceStub,
                                                                  tracking: trackingDummy)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertEqual(productListViewController.products, products)
        XCTAssertEqual(productListViewController.title, "Test Products")
    }
    
    func testWhenDataSourceReturnProductsButFailReturnTitle() throws {

        let products = [
            ProductListItemModel(id: "34", name: "Product 34", price: "$5.50")
        ]
        
        let dataSourceStub = ProductListDataSourceStubs(products: products,
                                                        titleError: .titleNotFound)
        
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceStub,
                                                                  tracking: trackingDummy)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertEqual(productListViewController.products, products)
        XCTAssertEqual(productListViewController.title, "Products")
    }
    
    func testWhenDataSourceWhenProductsWasNotFound() throws {
        
        let dataSourceStub = ProductListDataSourceStubs(productsError: .productsNotFound,
                                                        titleError: .networkError)
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceStub,
                                                                  tracking: trackingDummy)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertTrue(productListViewController.products.isEmpty)
        XCTAssertNil(productListViewController.title)
    }
    
    func testWhenDataSourceWhenTimeOut() throws {
        
        let dataSourceStub = ProductListDataSourceStubs(productsError: .networkError,
                                                        titleError: .networkError)
        
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceStub,
                                                                  tracking: trackingDummy)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: true)
        
        XCTAssertTrue(productListViewController.products.isEmpty)
        XCTAssertNil(productListViewController.title)
    }
    
    func testWhenSelectAProduct() throws {

        let products = [
            ProductListItemModel(id: "1", name: "Product 1", price: "$10.00"),
            ProductListItemModel(id: "2", name: "Product 2", price: "$2.00"),
            ProductListItemModel(id: "3", name: "Product 3", price: "$0.30")
        ]
        
        let dataSourceStub = ProductListDataSourceStubs(products: products,
                                                        title: "Test Products")
        let productListViewController = ProductListViewController(listId: "list test",
                                                                  dataSource: dataSourceStub,
                                                                  tracking: trackingDummy)
        
        let navigationController = UINavigationController(rootViewController: productListViewController)
        
        productListViewController.loadView()
        productListViewController.viewDidLoad()
        productListViewController.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(productListViewController.products, products)
        XCTAssertEqual(productListViewController.title, "Test Products")
        
        if let tableView = productListViewController.tableView {
            
            let indexPath = IndexPath(row: 2, section: 0)
            productListViewController.tableView(tableView, didSelectRowAt: indexPath)
            UIView.setAnimationsEnabled(false)
        }
        
        let checkViewControllerExpectation = XCTestExpectation(description: "Waiting for ProductDetailsViewController")
        
        DispatchQueue.main.async {
            
            do {
                
                let topViewController = try XCTUnwrap(navigationController.topViewController)
                print(type(of: topViewController))
                
                if let productDetailsViewController = topViewController as? ProductDetailsViewController {
                    
                    XCTAssertEqual(productDetailsViewController.productId, "3")
                    checkViewControllerExpectation.fulfill()
                }
                
            } catch {
                
                XCTFail(error.localizedDescription)
            }
        }
        
        self.wait(for: [checkViewControllerExpectation], timeout: 0.1)
    }
}
