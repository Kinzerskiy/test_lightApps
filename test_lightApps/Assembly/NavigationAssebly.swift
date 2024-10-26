//
//  NavigationAssebly.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation
import UIKit

protocol CommonNavigationAssemblyProtocol {
    func assemblyNavigationController(with item: UIViewController) -> UINavigationController
}

protocol MainNavigationAssemblyProtocol {
    func assemblyMainViewController(with router: MainRouting) -> MainViewController
    func assemblyMagneticDetectionViewController(with router: MainRouting) -> MagneticDetectionViewController
    func assemblyScanViewController(with router: MainRouting) -> ScanViewController
    func assemblyInfratedViewController(with router: MainRouting) -> InfratedDetectionViewController
    func assemblyBluetoothViewController(with router: MainRouting) -> BluetoothDetectionViewController
    func assemblyAntispyTipshViewController(with router: MainRouting) -> AntispyTipsViewController
    func assemblySetupViewController(with router: MainRouting) -> SetupViewController
    func assemblyResultViewController(with router: MainRouting) -> ResultViewController
    func assemblyDetailsViewController(with router: MainRouting) -> DeviceDetailsViewController
}

protocol NavigationAssemblyProtocol: CommonNavigationAssemblyProtocol,
                                     MainNavigationAssemblyProtocol
{
    
}

class NavigationAssembly: BaseAssembly, NavigationAssemblyProtocol {
    
    // MARK: - Common
    
    func assemblyNavigationController(with item: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: item)
    }
    
    func assemblyAlertController(with title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    // MARK: Main
    
    func assemblyMainViewController(with router: MainRouting) -> MainViewController {
        let viewController = MainViewController()
        viewController.router = router
        return viewController
    }
    
    func assemblyMagneticDetectionViewController(with router: MainRouting) -> MagneticDetectionViewController {
        let viewController = MagneticDetectionViewController()
        viewController.router = router
        return viewController
    }
    
    func assemblyScanViewController(with router: MainRouting) -> ScanViewController {
        let viewController = ScanViewController()
        viewController.router = router
        return viewController
    }
    
    func assemblyInfratedViewController(with router: MainRouting) -> InfratedDetectionViewController {
        let viewController = InfratedDetectionViewController()
        viewController.router = router
        return viewController
    }
    
    func assemblyBluetoothViewController(with router: MainRouting) -> BluetoothDetectionViewController {
        let viewController = BluetoothDetectionViewController()
        viewController.router = router
        return viewController
    }
    
    func assemblyAntispyTipshViewController(with router: MainRouting) -> AntispyTipsViewController {
        let viewController = AntispyTipsViewController()
        viewController.router = router
        return viewController
    }
    
    func assemblySetupViewController(with router: MainRouting) -> SetupViewController {
        let viewController = SetupViewController()
        viewController.router = router
        return viewController
    }
    
    func assemblyResultViewController(with router: MainRouting) -> ResultViewController {
        let viewController = ResultViewController()
        viewController.router = router
        return viewController
    }
    
    func assemblyDetailsViewController(with router: MainRouting) -> DeviceDetailsViewController {
        let viewController = DeviceDetailsViewController()
        viewController.router = router
        return viewController
    }
}
