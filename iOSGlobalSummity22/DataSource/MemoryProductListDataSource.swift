//
//  MemoryProductListDataSource.swift
//  iOSGlobalSummity22
//
//  Created by Victor C Tavernari on 24/09/2022.
//

import Foundation
import Combine

class MemoryProductListDataSource: ProductListDataSource {
    
    func products(from listId: String) -> Future<[ProductListItemModel], ProductListDataSourceError> {
        
        Future { promise in
            
            promise(.success([
                ProductListItemModel(id: "1", name: "Product 1", price: "$1.00"),
                ProductListItemModel(id: "2", name: "Product 2", price: "$2.00"),
                ProductListItemModel(id: "3", name: "Product 3", price: "$3.00"),
                ProductListItemModel(id: "4", name: "Product 4", price: "$4.00"),
                ProductListItemModel(id: "5", name: "Product 5", price: "$5.00"),
            ]))
        }
    }
    
    func title(by listId: String) -> Future<Title, ProductListDataSourceError> {
        
        Future { promise in
            
            promise(.success("Memory Product List"))
        }
    }
}
