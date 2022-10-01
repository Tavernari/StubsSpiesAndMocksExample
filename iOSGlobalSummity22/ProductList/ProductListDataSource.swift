//
//  ProductListDataSource.swift
//  iOSGlobalSummity22
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import Foundation
import Combine

enum ProductListDataSourceError: Error {
    
    case titleNotFound
    case productsNotFound
    case networkError
}

protocol ProductListDataSource {
    
    typealias Title = String
    
    func products(from listId: String) -> Future<[ProductListItemModel], ProductListDataSourceError>
    func title(by listId: String) -> Future<Title, ProductListDataSourceError>
}
