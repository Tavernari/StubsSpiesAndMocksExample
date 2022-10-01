//
//  ProductListDataSourceMock.swift
//  MockTests
//
//  Created by Victor C Tavernari on 14/09/2022.
//

import Foundation
import XCTest
import Combine
import SimpleMock

@testable import iOSGlobalSummity22

class ProductListDataSourceMock: ProductListDataSource, Mock {

    enum Methods: Hashable {
        
        case products(listId: String)
        case title(listId: String)
    }
    
    var methodsExpected: [[Methods]] = []
    var methodsResolvers: [[Methods] : Resolver] = [:]
    var methodsRegistered: [[Methods]] = []
    
    func products(from listId: String) -> Future<[ProductListItemModel], ProductListDataSourceError> {
        
        do {
            
            return try self.resolve(method: .products(listId: listId))
            
        } catch {
            
            XCTFail(error.localizedDescription)
            return .init { $0(.failure(ProductListDataSourceError.networkError)) }
        }
    }
    
    func title(by listId: String) -> Future<Title, ProductListDataSourceError> {
        
        do {
            
            return try self.resolve(method: .title(listId: listId))
            
        } catch {
            
            XCTFail(error.localizedDescription)
            return .init { $0(.failure(ProductListDataSourceError.networkError)) }
        }
    }
}
