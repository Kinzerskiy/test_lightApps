//
//  ScanViewController.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import UIKit
import Lottie

class ScanViewController: UIViewController {
    var router: MainRouting?
    private let viewModel = ViewModel.shared
    
    private let scanAnimationView: LottieAnimationView = {
        let searchView = LottieAnimationView(name: "scanAnimation")
        searchView.contentMode = .scaleAspectFit
        searchView.loopMode = .loop
        return searchView
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop", for: .normal)
        button.backgroundColor = .buttonColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.mainButtonHeight / 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return button
    }()
    
    private let scaningLabel: UILabel = {
        let label = UILabel()
        label.text = "Scanning Your Wi-Fi"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let wifiNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .buttonColor
        return label
    }()
    
    private let devicesLabel: UILabel = {
        let label = UILabel()
        label.text = "Devices Found..."
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let devicesNumber: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .buttonColor
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        bindViewModel()
        updateUI()
        scanAnimationView.play()
        stopButton.addTarget(self, action: #selector(stopDetectionTapped), for: .touchUpInside)
        configureView()
    }
    
    private func bindViewModel() {
        viewModel.currentWIFIUpdateHandler = { [weak self] wifiName in
            self?.wifiNameLabel.text = wifiName
        }
        
        viewModel.devicesFoundUpdateHandler = { [weak self] devicesFound in
            self?.devicesNumber.text = "\(devicesFound)"
        }
        
        viewModel.percentageUpdateHandler = { [weak self] percentage in
            self?.percentageLabel.text = percentage
        }
        
        viewModel.startDeviceScanning { [weak self] in
            guard let self = self else { return }
            viewModel.loadInitialWiFiNetworks()
            
            self.router?.dissmiss(viewController: self, animated: true, completion: {
                self.router?.showResult(viewController: self, animated: true)
            })
        }
    }
    
    private func updateUI() {
        wifiNameLabel.text = viewModel.currentWIFI
    }
    
    
    func configureView() {
        self.view.backgroundColor = UIColor.bgColor
        
        view.addSubview(scaningLabel)
        view.addSubview(wifiNameLabel)
        view.addSubview(scanAnimationView)
        view.addSubview(horizontalStackView)
        view.addSubview(stopButton)
        
        horizontalStackView.addArrangedSubview(devicesNumber)
        horizontalStackView.addArrangedSubview(devicesLabel)
        
        scanAnimationView.addSubview(percentageLabel)
        
        scaningLabel.translatesAutoresizingMaskIntoConstraints = false
        wifiNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scanAnimationView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scaningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scaningLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            wifiNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wifiNameLabel.topAnchor.constraint(equalTo: scaningLabel.bottomAnchor, constant: 8),
            
            scanAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanAnimationView.topAnchor.constraint(equalTo: wifiNameLabel.bottomAnchor, constant: 20),
            scanAnimationView.heightAnchor.constraint(equalToConstant: 350),
            scanAnimationView.widthAnchor.constraint(equalToConstant: 350),
            
            percentageLabel.centerXAnchor.constraint(equalTo: scanAnimationView.centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: scanAnimationView.centerYAnchor),
            
            horizontalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: scanAnimationView.bottomAnchor, constant: 20),
            
            stopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stopButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func stopDetectionTapped() {
        viewModel.cancelLoadingWiFiNetworks()
        router?.dissmiss(viewController: self, animated: true, completion: {})
    }
}
