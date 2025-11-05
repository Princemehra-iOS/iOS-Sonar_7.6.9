//
//  ConnectionManager.swift
//  Zoetis -Feathers
//
//  Created by MobileProgramming on 27/04/22.
//
import Foundation
import Reachability

class ConnectionManager {

    static let shared = ConnectionManager()
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            case .none:
                return false
            }
        } catch {
            return false
        }
    }
}
