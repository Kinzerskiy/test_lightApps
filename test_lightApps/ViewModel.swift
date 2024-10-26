//
//  ViewModel.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation

class ViewModel {
    
    static let shared = ViewModel()
    
    private init() { }
    
    var devicesFoundUpdateHandler: ((Int) -> Void)?
    var percentageUpdateHandler: ((String) -> Void)?
    var currentWIFIUpdateHandler: ((String?) -> Void)?
    var randomWiFiNetworksUpdateHandler: (([WiFiNetwork]) -> Void)?
    
    private var allWiFiNetworks: [WiFiNetwork] = []
    
    var currentWIFI: String? {
        didSet {
            currentWIFIUpdateHandler?(currentWIFI)
        }
    }
    
    var totalDevicesFound: Int = 0 {
        didSet {
            devicesFoundUpdateHandler?(totalDevicesFound)
        }
    }
    
    var elapsedTime: Int = 0 {
        didSet {
            percentageUpdateHandler?(calculatePercentage())
        }
    }
    
    
    
    private func loadWiFiNetworks() {
        if let url = Bundle.main.url(forResource: "wifi_networks", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                allWiFiNetworks = try JSONDecoder().decode([WiFiNetwork].self, from: data)
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func updateRandomWiFiNetworks() {
        guard totalDevicesFound > 0 else { return }
        
        let randomCount = min(totalDevicesFound, allWiFiNetworks.count)
        let randomWiFiNetworks = allWiFiNetworks.shuffled().prefix(randomCount)
        
        randomWiFiNetworksUpdateHandler?(Array(randomWiFiNetworks))
    }
    
    func updateWiFiName() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentWIFI = "WIFI_Name"
        }
    }
    
    func startDeviceScanning(completion: @escaping () -> Void) {
        totalDevicesFound = 0
        elapsedTime = 0
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.elapsedTime += 1
            
            let randomDevices = Int.random(in: 1...8)
            self.totalDevicesFound += randomDevices
            
            if self.elapsedTime >= 5 {
                self.loadWiFiNetworks()
                timer.invalidate()
                completion()
            }
        }
    }
    
    private func calculatePercentage() -> String {
        let percentage = min(100, elapsedTime * 20)
        return "\(percentage)%"
    }
}
