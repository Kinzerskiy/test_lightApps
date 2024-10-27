//
//  MainViewController.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import UIKit

class MainViewController: UIViewController {
    var router: MainRouting?
    
    private let viewModel = ViewModel.shared
    private let currentLabel = UILabel()
    private let currentWIFILabel = UILabel()
    private let scanLabel = UILabel()
    private let scanButton = UIButton(type: .system)
    private var hasSetCurrentWIFI = false
    private let labelTexts = [
        "Infrared Detection",
        "Bluetooth Detection",
        "Magnetic Detection",
        "Antispy\n Tips"
    ]
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainSecondaryColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var currentWIFI: String? {
        didSet {
            updateWiFiLabel()
        }
    }
    
    private func updateWiFiLabel() {
        currentWIFILabel.text = currentWIFI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasSetCurrentWIFI = true
        setupUI()
        
        viewModel.currentWIFIUpdateHandler = { [weak self] wifiName in
            self?.currentWIFILabel.text = wifiName
        }
        viewModel.updateWiFiName()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgColor
        configureNavigationBar()
        configureStackView()
        configureContainerView()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        let setupImage = UIImage(named: "filter")
        let setupButton = UIBarButtonItem(image: setupImage, style: .plain, target: self, action: #selector(didTapSetupButton))
        setupButton.tintColor = .white
        navigationItem.rightBarButtonItem = setupButton
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(containerView)
        
        titleImageView.image = UIImage(named: "bgMain")
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleImageView)
        
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.topAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleImageView.heightAnchor.constraint(equalToConstant: Constants.titleImageHeight)
        ])
        
        stackView.addArrangedSubview(containerView)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.stackViewAncorHeight),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureContainerView() {
      
        containerView.heightAnchor.constraint(equalToConstant: Constants.containerViewHeight).isActive = true
        
        
        currentLabel.text = "Current Wi-Fi"
        currentLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        currentLabel.textColor = .white
        currentLabel.textAlignment = .center
        
        currentWIFILabel.text = currentWIFI
        currentWIFILabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        currentWIFILabel.textColor = .buttonColor
        currentWIFILabel.textAlignment = .center
        
        currentWIFILabel.layer.shadowColor = UIColor.buttonColor.cgColor
        currentWIFILabel.layer.shadowOpacity = 0.5
        currentWIFILabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        currentWIFILabel.layer.shadowRadius = 5
        
        
        scanLabel.text = "Ready to Scan this network"
        currentLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        scanLabel.textColor = .mainGrayColor
        scanLabel.textAlignment = .center
        
        
        scanButton.setTitle("Scan current network", for: .normal)
        scanButton.backgroundColor = .buttonColor
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = Constants.mainButtonHeight / 2
        scanButton.addTarget(self, action: #selector(startScanTapped), for: .touchUpInside)
        
        containerView.addSubview(currentLabel)
        containerView.addSubview(currentWIFILabel)
        containerView.addSubview(scanLabel)
        containerView.addSubview(scanButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        currentLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWIFILabel.translatesAutoresizingMaskIntoConstraints = false
        scanLabel.translatesAutoresizingMaskIntoConstraints = false
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            
            currentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            currentLabel.heightAnchor.constraint(equalToConstant: 15),
            currentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            currentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            currentWIFILabel.topAnchor.constraint(equalTo:         currentLabel.bottomAnchor, constant: 16),
            currentWIFILabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            currentWIFILabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            scanLabel.topAnchor.constraint(equalTo:         currentWIFILabel.bottomAnchor, constant: 5),
            scanLabel.heightAnchor.constraint(equalToConstant: 20),
            scanLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scanLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            scanButton.topAnchor.constraint(equalTo:     scanLabel.bottomAnchor, constant: 16),
            scanButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            scanButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            scanButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            scanButton.heightAnchor.constraint(equalToConstant: Constants.mainButtonHeight)
        ])
    }
    
    private func configureCollectionView() {
        stackView.addArrangedSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 36),
            collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -36),
            collectionView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -1)
        ])
    }
    
    @objc private func didTapSetupButton() {
        router?.showSetup(viewController: self, animated: true)
    }
    
    @objc private func startScanTapped() {
        router?.showScan(viewController: self, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier, for: indexPath) as! MainCell
        let imageName = "icon-\(indexPath.item)"
        let labelText = labelTexts[indexPath.item]
        
        cell.configure(with: UIImage(named: imageName), labelText: labelText)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            switchToInfraredDetection()
        case 1:
            switchToBluetoothDetection()
        case 2:
            switchToMagneticDetection()
        case 3:
            switchToAntispyTips()
        default:
            break
        }
    }
    
    private func switchToInfraredDetection() {
        router?.showInfratedDetection(viewController: self, animated: true)
    }
    
    private func switchToBluetoothDetection() {
        router?.showBluetoothDetection(viewController: self, animated: true)
    }
    
    private func switchToMagneticDetection() {
        router?.showMagneticDetection(viewController: self, animated: true)
    }
    
    private func switchToAntispyTips() {
        router?.showAntispyTips(viewController: self, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = CGFloat(15)
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
