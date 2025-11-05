//
//  NetworkManager.swift
//  EversenseDataHub
//
//  Created by Shiney Chaudhary on 16/08/24.
//  Copyright © 2024 senseonics. All rights reserved.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    weak var delegate: NetworkStatusDelegate?
    var isConnected: Bool = true {
        didSet {
            print("internet network is \(isConnected)")
            delegate?.networkStatusDidChange(isConnected: isConnected)
        }
    }
    
    private init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = (path.status == .satisfied)
            
            if self.isConnected {
                print("Connected")
            } else {
                print("Disconnected")
            }
        }
    }
}


protocol NetworkStatusDelegate: AnyObject {
    func networkStatusDidChange(isConnected: Bool)
}
