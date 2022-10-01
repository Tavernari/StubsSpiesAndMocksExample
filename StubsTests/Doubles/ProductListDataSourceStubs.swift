//
//  ProductListDataSourceStubs.swift
//  SpiesAndStubsTests
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import XCTest
import Combine

@testable import iOSGlobalSummity22

class ProductListDataSourceStubs: ProductListDataSource {

    private let products: [ProductListItemModel]?
    private let title: String?
    private let productsError: ProductListDataSourceError?
    private let titleError: ProductListDataSourceError?
    
    init(products: [ProductListItemModel]? = nil,
         title: String? = nil,
         productsError: ProductListDataSourceError? = nil,
         titleError: ProductListDataSourceError? = nil) {
        
        self.products = products
        self.title = title
        self.productsError = productsError
        self.titleError = titleError
    }
    
    func products(from listId: String) -> Future<[ProductListItemModel], ProductListDataSourceError> {
        
        Future { [self] promise in
            
            if let productsError = productsError {
                
                promise(.failure(productsError))
                return
            }
            
            if let products = products {
                
                promise(.success(products))
                return
            }
            
            XCTFail("It needs an error or a list of products")
        }
    }
    
    func title(by listId: String) -> Future<Title, ProductListDataSourceError> {
        
        
        Future { [self] promise in
            
            if let titleError = titleError {
                
                promise(.failure(titleError))
                return
            }
            
            if let title = title {
                
                promise(.success(title))
                return
            }
            
            XCTFail("It needs an error or a title")
        }
    }
}
