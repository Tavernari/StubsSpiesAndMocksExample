//
//  ProductListTrackingMock.swift
//  MockTests
//
//  Created by Victor C Tavernari on 14/09/2022.
//

import Foundation
import SimpleMock

@testable import iOSGlobalSummity22

class ProductListTrackingMock: ProductListTracking, Mock {
    
    enum Methods: Hashable {
        
        case showProduct(id: String)
        case screenDidAppear
    }
    
    var methodsExpected: [[Methods]] = []
    var methodsResolvers: [[Methods] : Resolver] = [:]
    var methodsRegistered: [[Methods]] = []
    
    func showProduct(id: String) {
        
        return try! self.resolve(method: .showProduct(id: id))
    }
    
    func screenDidAppear() {
        
        return try! self.resolve(method: .screenDidAppear)
    }
}
