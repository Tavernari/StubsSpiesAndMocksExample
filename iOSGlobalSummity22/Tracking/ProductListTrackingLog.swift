//
//  ProductListTrackingLog.swift
//  iOSGlobalSummity22
//
//  Created by Victor C Tavernari on 24/09/2022.
//

import Foundation

class ProductListTrackingLog: ProductListTracking {
    
    func showProduct(id: String) { print("[ProductListTrackingLog]", "showProduct id", id) }
    
    func screenDidAppear() { print("[ProductListTrackingLog]", "screenDidAppear") }
}
