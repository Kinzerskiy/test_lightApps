//
//  WiFiwCell.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import UIKit

class WiFiCell: UITableViewCell {
    
    static let identifier = "WiFiCell"
    
    private let wifiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let ipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var didSelect: ((WiFiNetwork) -> Void)?
    private var network: WiFiNetwork?
    
    private func setupUI() {
        self.selectionStyle = .default
        
        contentView.backgroundColor = .mainInfoColor
        contentView.addSubview(wifiImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ipLabel)
        contentView.addSubview(arrowImageView)
        
        wifiImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ipLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wifiImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            wifiImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            wifiImageView.widthAnchor.constraint(equalToConstant: 40),
            wifiImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: wifiImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            ipLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ipLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            ipLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ipLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with network: WiFiNetwork) {
        self.network = network
        nameLabel.text = network.name
        ipLabel.text = network.IP
        wifiImageView.image = network.isOk ? UIImage(named: "wifi") : UIImage(named: "wifi-error")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func cellTapped() {
        if let network = network {
            didSelect?(network)
        }
    }
}
