//
//  MagneticDetectionViewController.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import UIKit


class MagneticDetectionViewController: UIViewController {
    var router: MainRouting?
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let magneticView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
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
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let overlayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgColor
        titleImageView.image = UIImage(named: "bgMagnetic")
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleImageView)
        
        view.addSubview(magneticView)
        magneticView.translatesAutoresizingMaskIntoConstraints = false
        
      
        setupMagneticView()
        
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
        startButton.addTarget(self, action: #selector(startDetectionTapped), for: .touchUpInside)
    }
    
    private func setupMagneticView() {
        backgroundImageView.image = UIImage(named: "magnetic")
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        magneticView.addSubview(backgroundImageView)
        
      
        overlayImageView.image = UIImage(named: "arrow")
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        magneticView.addSubview(overlayImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: magneticView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: magneticView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: magneticView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: magneticView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overlayImageView.leadingAnchor.constraint(equalTo: magneticView.leadingAnchor, constant: 90),
            overlayImageView.bottomAnchor.constraint(equalTo: magneticView.bottomAnchor, constant: 30),
            overlayImageView.widthAnchor.constraint(equalToConstant: 100),
            overlayImageView.heightAnchor.constraint(equalToConstant: 100)
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
//        animateArrow()
    }
}
