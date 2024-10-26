//
//  ApplicationAssembly.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation

protocol ApplicationAssemblyProtocol {
    var sharedNavigationAssembly: NavigationAssemblyProtocol { get }
}

class ApplicationAssembly: BaseAssembly, ApplicationAssemblyProtocol {
    
    private var navigationAssembly: NavigationAssemblyProtocol
    
    static func defaultAssembly() -> ApplicationAssembly {
       
        let navigationAssembly = NavigationAssembly()
        
        return self.init(with: navigationAssembly)
    }
    
    required init(with navigationAssembly: NavigationAssemblyProtocol) {
        
        self.navigationAssembly = navigationAssembly
    }
    
    // MARK: - ApplicationAssemblyProtocol
    
    var sharedNavigationAssembly: NavigationAssemblyProtocol {
        return navigationAssembly
    }
}
