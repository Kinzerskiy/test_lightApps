//
//  ViewModel.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation

class DeviceScanner {
    var onDeviceFound: ((Int) -> Void)?
    var onScanningCompleted: (() -> Void)?
    
    private var timer: Timer?
    private var elapsedTime = 0
    
    func startScanning() {
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.elapsedTime += 1
            
            let randomDevices = Int.random(in: 1...8)
            self.onDeviceFound?(randomDevices)
            
            if self.elapsedTime >= 5 {
                self.stopScanning()
                self.onScanningCompleted?()
            }
        }
    }
    
    func stopScanning() {
        timer?.invalidate()
        timer = nil
    }
}

class WiFiNetworkLoader {
    private var currentTask: URLSessionDataTask?
    
    func loadWiFiNetworks(completion: @escaping (Result<[WiFiNetwork], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "wifi_networks", withExtension: "json") else {
            completion(.failure(NSError(domain: "FileNotFound", code: 404, userInfo: nil)))
            return
        }
        
        currentTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let networks = try JSONDecoder().decode([WiFiNetwork].self, from: data)
                completion(.success(networks))
            } catch {
                completion(.failure(error))
            }
        }
        
        currentTask?.resume()
    }
    
    func cancelLoading() {
        currentTask?.cancel()
        currentTask = nil
    }
}

class ViewModel {
    static let shared = ViewModel()
    
    private init() {  }
    
    private let deviceScanner = DeviceScanner()
    private let wifiNetworkLoader = WiFiNetworkLoader()
    private var allWiFiNetworks: [WiFiNetwork] = []
    private var isLoadingNetworks = false
    
    var devicesFoundUpdateHandler: ((Int) -> Void)?
    var percentageUpdateHandler: ((String) -> Void)?
    var currentWIFIUpdateHandler: ((String?) -> Void)?
    var randomWiFiNetworksUpdateHandler: (([WiFiNetwork]) -> Void)?
    
    var currentWIFI: String? {
        didSet { currentWIFIUpdateHandler?(currentWIFI) }
    }
    
    var totalDevicesFound: Int = 0 {
        didSet { devicesFoundUpdateHandler?(totalDevicesFound) }
    }
    
    var elapsedTime: Int = 0 {
        didSet { percentageUpdateHandler?(calculatePercentage()) }
    }
    
    func loadInitialWiFiNetworks() {
        guard !isLoadingNetworks else { return }
        isLoadingNetworks = true
        
        wifiNetworkLoader.loadWiFiNetworks { [weak self] result in
            self?.isLoadingNetworks = false
            switch result {
            case .success(let networks):
                self?.allWiFiNetworks = networks
            case .failure(let error):
                print("Error loading WiFi networks: \(error)")
            }
        }
    }
    
    func cancelLoadingWiFiNetworks() {
        deviceScanner.stopScanning()
        wifiNetworkLoader.cancelLoading()
        isLoadingNetworks = false
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
        
        deviceScanner.onDeviceFound = { [weak self] foundDevices in
            guard let self = self else { return }
            self.totalDevicesFound += foundDevices
            self.elapsedTime += 1
        }
        
        deviceScanner.onScanningCompleted = { [weak self] in
            self?.updateRandomWiFiNetworks()
            completion()
        }
        
        deviceScanner.startScanning()
    }
    
    private func calculatePercentage() -> String {
        let percentage = min(100, elapsedTime * 20)
        return "\(percentage)%"
    }
}
