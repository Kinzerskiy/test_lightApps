//
//  DeviceDetailsViewController.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import UIKit

class DeviceDetailsViewController: UIViewController {
    var router: MainRouting?
    
    var name: String?
    var ip: String?
    var connectionType: String?
    var macAddress: String?
    var hostname: String?
    var isOK: Bool? {
        didSet {
            updateNameLabelColor()
        }
    }
    
    private let connectionTypeLabel = UILabel()
    private let macAddressLabel = UILabel()
    private let hostnameLabel = UILabel()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainSecondaryColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(DetailsCell.self, forCellReuseIdentifier: DetailsCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        configureNavigationBar()
        configureView()
        setupContainerView()
        updateNameLabelColor()
    }
    
    func configureView() {
        titleImageView.image = isOK ?? false ? UIImage(named: "bgWifiSuccess") : UIImage(named: "bgWifiFail")
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleImageView)
        
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.topAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func configureNavigationBar() {
        self.title = "Device Details"
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
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(ipLabel)
        containerView.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            ipLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            ipLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: ipLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        nameLabel.text = name ?? "Unknown Device"
        ipLabel.text = ip ?? "No IP Address"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateNameLabelColor() {
        nameLabel.textColor = (isOK == true) ? .buttonColor : .redColor
    }
}

extension DeviceDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.identifier, for: indexPath) as! DetailsCell
        let titles = ["Connection Type", "IP Address", "MAC Address", "Hostname"]
        let data = [connectionType ?? "N/A", ip ?? "N/A", macAddress ?? "N/A", hostname ?? "N/A"]
        
        cell.titleLabel.text = titles[indexPath.row]
        cell.detailLabel.text = data[indexPath.row]
        
        return cell
    }
    
}
