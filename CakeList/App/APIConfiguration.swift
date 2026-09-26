//
//  APIConfiguration.swift
//  CakeList
//
//  Created by Eren on 26/09/2026.
//

import Foundation

enum APIConfiguration {
    // TODO: Move to a build-configuration-driven setting once there is more than one environment.
    static let baseURL = URL(string: "https://raw.githubusercontent.com/Waracle/mobile-coding-test-api/refs/heads/main")!
}
