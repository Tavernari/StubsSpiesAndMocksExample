//
//  ProductDetailsViewController.swift
//  iOSGlobalSummity22
//
//  Created by Victor C Tavernari on 28/08/2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    let productId: String
    init(productId: String) {
        
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .magenta
    }
}

