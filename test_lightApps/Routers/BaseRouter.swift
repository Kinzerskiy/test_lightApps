//
//  BaseRouter.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation
import UIKit

typealias RoutingCompletionBlock = () -> Void

protocol BaseRouting {
    func initialViewController() -> UIViewController?
}

protocol DismissRouting {
    func dissmiss(viewController: UIViewController, animated: Bool, completion: (()->())?)
}

class BaseRouter: BaseRouting {
    
    internal var assembly: NavigationAssemblyProtocol
    
    // MARK: - Memory management
    
    init(with assembly: NavigationAssemblyProtocol) {
        self.assembly = assembly
    }
    
    func initialViewController() -> UIViewController? {
        return nil
    }
}
