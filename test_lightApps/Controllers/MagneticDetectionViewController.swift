//
//  MagneticDetectionViewController.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import UIKit

class MagneticDetectionViewController: UIViewController {
    var router: MainRouting?
    
    private var isDetectionActive = false
    private var currentMagneticValue: CGFloat = 0
    private var timer: Timer?
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let magneticView: MagneticView = {
        let view = MagneticView(frame: .zero, maxMagnetic: 300, backgroundImage: UIImage(named: "magnetic"))
        return view
    }()
    
    private let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .red
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search checking"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Detection", for: .normal)
        button.backgroundColor = .buttonColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.mainButtonHeight / 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgColor
        startButton.addTarget(self, action: #selector(startDetectionTapped), for: .touchUpInside)
        configureNavigationBar()
        configureView()
    }
    
    func configureView() {
        titleImageView.image = UIImage(named: "bgMagnetic")
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleImageView)
        
        view.addSubview(magneticView)
        magneticView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(searchLabel)
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.topAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            magneticView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 20),
            magneticView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            magneticView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            magneticView.heightAnchor.constraint(equalToConstant: 180),
            
            searchLabel.topAnchor.constraint(equalTo: magneticView.bottomAnchor, constant: 16),
            searchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureNavigationBar() {
        self.title = "Magnetic Detection"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.buttonColor
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("Main", for: .normal)
        backButton.setTitleColor(UIColor.buttonColor, for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = UIColor.buttonColor
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        backButton.sizeToFit()
        backButton.contentHorizontalAlignment = .leading
        backButton.semanticContentAttribute = .forceLeftToRight
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
     @objc func backButtonTapped() {
        router?.dissmiss(viewController: self, animated: true, completion: {})
    }
    
    
     @objc func startDetectionTapped() {
        if isDetectionActive {
            stopDetection()
        } else {
            let incomingValue: CGFloat = CGFloat(arc4random_uniform(100)) / 100 * 140
            startDetection(with: incomingValue)
        }
    }
    
   private func startDetection(with magneticValue: CGFloat) {
        guard !isDetectionActive else { return }
        isDetectionActive = true
        startButton.setTitle("Stop", for: .normal)
        
        currentMagneticValue = magneticValue
        self.magneticView.setMagnetic(currentMagneticValue)
        self.magneticView.startAccelerating()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let targetMagneticValue: CGFloat = CGFloat(arc4random_uniform(100)) / 100 * 140
            
            self.currentMagneticValue += (targetMagneticValue - self.currentMagneticValue) * 0.1
            self.magneticView.setMagnetic(self.currentMagneticValue)
        }
    }
    
    private func stopDetection() {
        isDetectionActive = false
        startButton.setTitle("Start Detection", for: .normal)
        
        timer?.invalidate()
        timer = nil
        
        self.magneticView.endAccelerating()
    }
}
