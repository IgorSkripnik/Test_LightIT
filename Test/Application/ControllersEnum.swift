//
//  ControllersEnum.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import UIKit

enum ControllerType: String {
    case registerViewController = "RegisterViewProtocol"
    case productsViewController = "ProductsViewController"
    case detailViewController = "DetailViewController"
    case reviewViewController = "ReviewViewController"
    
    func instantiateViewController() -> UIViewController {
        let _storyboard = UIStoryboard(name: storyboardIdentifire, bundle: Bundle.main)
        return _storyboard.instantiateViewController(withIdentifier: self.rawValue)
    }
}
