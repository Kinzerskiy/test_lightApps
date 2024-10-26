//
//  ApplicationRouter.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation
import UIKit

class ApplicationRouter {
    
    private var applicationAssembly: ApplicationAssemblyProtocol
    private var mainRouter: MainRouter?
    
    private var navigationController: UINavigationController
    
    required init(with assembly: ApplicationAssemblyProtocol) {
        applicationAssembly = assembly
        navigationController = UINavigationController()
        setupRouters()
    }
    
    private func setupRouters() {
        mainRouter = assemblyMainRouter()
    }
    
    // MARK: - BaseRouting
    
    func initialViewController() -> UIViewController {
        return (mainRouter?.initialViewController())!
    }
    
    // MARK: - Assembly
    
    func navigationAssembly() -> NavigationAssemblyProtocol {
        return applicationAssembly.sharedNavigationAssembly
    }
    
    func assemblyMainRouter() -> MainRouter {
        let router = MainRouter(with: navigationAssembly())
        
        return router
    }
}
