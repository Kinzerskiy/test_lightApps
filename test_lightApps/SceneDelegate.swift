//
//  SceneDelegate.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var applicationRouter: ApplicationRouter?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let assembly = ApplicationAssembly.defaultAssembly()
        applicationRouter = ApplicationRouter(with: assembly)
        
        window.rootViewController = applicationRouter?.initialViewController()
        window.makeKeyAndVisible()
    }
}

