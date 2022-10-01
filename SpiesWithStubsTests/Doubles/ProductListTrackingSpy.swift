//
//  ProductListTrackingSpy.swift
//  SpiesAndStubsTests
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import Foundation

@testable import iOSGlobalSummity22

class ProductListTrackingSpy: ProductListTracking {
    
    var didCallShowProduct: Bool = false
    var didCallScreenDidAppear: Bool = false
    
    func showProduct(id: String) {
        
        self.didCallShowProduct = true
    }
    
    func screenDidAppear() {
        
        self.didCallScreenDidAppear = true
    }
}
