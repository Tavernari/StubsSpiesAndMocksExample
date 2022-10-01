//
//  UINavigationControllerSpy.swift
//  SpiesAndStubsTests
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import Foundation
import UIKit

@testable import iOSGlobalSummity22

class UINavigationControllerSpy: UINavigationController {
    
    var presentedAlertTitle: String?
    var presentedAlertMessage: String?
    
    var pushProductDetailsById: String?
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        
        if let alertController = viewControllerToPresent as? UIAlertController {
            
            self.presentedAlertTitle = alertController.title
            self.presentedAlertMessage = alertController.message
        }
        
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if let productDetails = viewController as? ProductDetailsViewController {
            
            self.pushProductDetailsById = productDetails.productId
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}
