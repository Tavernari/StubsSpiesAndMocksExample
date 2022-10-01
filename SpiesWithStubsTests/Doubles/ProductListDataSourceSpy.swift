//
//  ProductListDataSourceSpy.swift
//  SpiesAndStubsTests
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import Foundation
import Combine

@testable import iOSGlobalSummity22

class ProductListDataSourceSpy: ProductListDataSource {
    
    var totalCalledProducts = 0
    var totalCalledTitle = 0
    
    private let stub: ProductListDataSource
    
    init(stub: ProductListDataSource) {
        
        self.stub = stub
    }
    
    func products(from listId: String) -> Future<[ProductListItemModel], ProductListDataSourceError> {
    
        self.totalCalledProducts += 1
        
        return self.stub.products(from: listId)
    }
    
    func title(by listId: String) -> Future<Title, ProductListDataSourceError> {
        
        self.totalCalledTitle += 1
        
        return self.stub.title(by: listId)
    }
}
