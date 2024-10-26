//
//  ResultViewController.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import UIKit

class ResultViewController: UIViewController {
    var router: MainRouting?
    private let viewModel = ViewModel.shared
    private var wifiNetworks: [WiFiNetwork] = []
    
    private let wifiNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .buttonColor
        return label
    }()
    
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .buttonColor
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WiFiCell.self, forCellReuseIdentifier: WiFiCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    
    private func updateUI() {
        wifiNameLabel.text = viewModel.currentWIFI
        resultCountLabel.text = ("\(String(describing: viewModel.totalDevicesFound))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        configureNavigationBar()
        setupBindings()
        viewModel.updateRandomWiFiNetworks()
    }
    
    private func setupBindings() {
        viewModel.randomWiFiNetworksUpdateHandler = { [weak self] networks in
            self?.wifiNetworks = networks
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            print("Updated WiFi Networks in ResultViewController: \(networks)")
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgColor
        
        view.addSubview(wifiNameLabel)
        view.addSubview(resultCountLabel)
        view.addSubview(tableView)
        
        wifiNameLabel.translatesAutoresizingMaskIntoConstraints = false
        resultCountLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            resultCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            wifiNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wifiNameLabel.topAnchor.constraint(equalTo: resultCountLabel.bottomAnchor, constant: 8),
            
            tableView.topAnchor.constraint(equalTo: wifiNameLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureNavigationBar() {
        self.title = "Result"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.buttonColor
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("", for: .normal)
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
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifiNetworks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WiFiCell.identifier, for: indexPath) as! WiFiCell
        let network = wifiNetworks[indexPath.row]
        cell.configure(with: network)
        return cell
    }
}
