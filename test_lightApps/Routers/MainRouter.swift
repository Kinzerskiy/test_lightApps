//
//  MainRouter.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation
import UIKit

protocol MainRouting: BaseRouting, DismissRouting {
    func showMagneticDetection(viewController: UIViewController, animated: Bool)
    func showScan(/*wifiName: String,*/ viewController: UIViewController, animated: Bool)
    func showInfratedDetection(viewController: UIViewController, animated: Bool)
    func showBluetoothDetection(viewController: UIViewController, animated: Bool)
    func showAntispyTips(viewController: UIViewController, animated: Bool)
    func showSetup(viewController: UIViewController, animated: Bool)
    func showResult(viewController: UIViewController, animated: Bool)
    func showDetails(name: String, isOK: Bool, ip: String, connectionType: String, macAddress: String, hostname: String, viewController: UIViewController, animated: Bool)
}

class MainRouter: BaseRouter, MainRouting {
    
    private var mainViewController: MainViewController?
    private var navigationController: UINavigationController?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    init(with navigationController: UINavigationController?, assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
        
        self.navigationController = navigationController
    }
    
    // MARK: - MainRouting
    
    override func initialViewController() -> UIViewController {
        if navigationController == nil {
            let mainVC: MainViewController = assembly.assemblyMainViewController(with: self)
            navigationController = UINavigationController(rootViewController: mainVC)
            navigationController?.isNavigationBarHidden = false
        }
        return navigationController!
    }
    
    func showMagneticDetection(viewController: UIViewController, animated: Bool) {
        let vc: MagneticDetectionViewController = assembly.assemblyMagneticDetectionViewController(with: self)
        
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func showScan(/*wifiName: String, */viewController: UIViewController, animated: Bool) {
        let vc: ScanViewController = assembly.assemblyScanViewController(with: self)
        
//        navigationController?.pushViewController(vc, animated: true)
//        vc.wifiName = wifiName
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: animated, completion: nil)
    }
    
    func showInfratedDetection(viewController: UIViewController, animated: Bool) {
        let vc: InfratedDetectionViewController = assembly.assemblyInfratedViewController(with: self)
        
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func showBluetoothDetection(viewController: UIViewController, animated: Bool) {
        let vc: BluetoothDetectionViewController = assembly.assemblyBluetoothViewController(with: self)
        
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func showAntispyTips(viewController: UIViewController, animated: Bool) {
        let vc: AntispyTipsViewController = assembly.assemblyAntispyTipshViewController(with: self)
        
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func showSetup(viewController: UIViewController, animated: Bool) {
        let vc: SetupViewController = assembly.assemblySetupViewController(with: self)
        
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func showResult(viewController: UIViewController, animated: Bool) {
        let vc: ResultViewController = assembly.assemblyResultViewController(with: self)
       
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func showDetails(name: String, isOK: Bool, ip: String, connectionType: String, macAddress: String, hostname: String, viewController: UIViewController, animated: Bool) {
        let vc: DeviceDetailsViewController = assembly.assemblyDetailsViewController(with: self)
        
        vc.name = name
        vc.ip = ip
        vc.connectionType = connectionType
        vc.macAddress = macAddress
        vc.hostname = hostname
        vc.isOK = isOK
        
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func dissmiss(viewController: UIViewController, animated: Bool, completion: (() -> ())?) {
        let CompletionBlock: () -> Void = { () -> () in
            if let completion = completion {
                completion()
            }
        }
        
        if let insertedInNavigationStack = navigationController?.viewControllers.contains(viewController), !insertedInNavigationStack {
            viewController.dismiss(animated: animated, completion: completion)
            return
        }
        
        let isActiveInStack = self.navigationController?.viewControllers.last == viewController
        if !isActiveInStack {
            CompletionBlock()
            return
        }
        
        navigationController?.popViewController(animated: animated)
        
        return
    }
}
