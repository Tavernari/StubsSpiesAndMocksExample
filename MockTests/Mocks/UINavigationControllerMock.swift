//
//  UINavigationControllerMock.swift
//  MockTests
//
//  Created by Victor C Tavernari on 14/09/2022.
//

import Foundation
import XCTest
import SimpleMock
import UIKit

@testable import iOSGlobalSummity22

class UINavigationControllerMock: UINavigationController, Mock {
    
    enum Methods: Hashable {
        
        case presentAlert(title: String?, message: String?)
        case pushProductDetails(productId: String)
    }
    
    var methodsExpected: [[Methods]] = []
    var methodsResolvers: [[Methods] : Resolver] = [:]
    var methodsRegistered: [[Methods]] = []
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        
        if let alertController = viewControllerToPresent as? UIAlertController {
            
            do {
                
                return try self.resolve(method: .presentAlert(title: alertController.title,
                                                              message: alertController.message))
                
            } catch {
                
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        super.pushViewController(viewController, animated: animated)
        
        if let productDetails = viewController as? ProductDetailsViewController {
            
            return try! self.resolve(method: .pushProductDetails(productId: productDetails.productId))
        }
    }
}
