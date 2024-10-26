//
//  WiFiNetwork.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation

struct WiFiNetwork: Codable {
    let name: String
    let IP: String
    let isOk: Bool
    let connectionType: String
    let MACAddress: String
    let hostname: String
}
