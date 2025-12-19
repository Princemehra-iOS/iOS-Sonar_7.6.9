//
//  ForceLogoutManager.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 17/12/25.
//

import Foundation
import UIKit


final class ForceLogoutManager {

    static let shared = ForceLogoutManager()
    private init() {}

   // private let sessionDuration: TimeInterval = 10 * 24 * 60 * 60
    private let sessionDuration: TimeInterval = 10 * 60
    private let totalWarnings = 5

    private let loginDateKey = "LoginDate"
    private let warningIndexKey = "ForceLogoutWarningIndex"

    /// Warnings 1–3
    var onWarning: ((Int, String) -> Void)?

    /// Warning 4
    var onFinalWarning: ((String) -> Void)?
    
    private func daysSinceLogin() -> Int {
        guard let loginDate = UserDefaults.standard.object(forKey: "LoginDate") as? Date else {
            return 0
        }

        let calendar = Calendar.current
        let startOfLogin = calendar.startOfDay(for: loginDate)
        let startOfToday = calendar.startOfDay(for: Date())

        let components = calendar.dateComponents([.day], from: startOfLogin, to: startOfToday)
        return components.day ?? 0
    }


    @discardableResult
    func handleForceLogoutIfNeeded() -> Bool {

        let days = daysSinceLogin()

        // Day 1–10 → nothing
        guard days >= 11 && days <= 15 else {
            return false
        }

        let warningIndex = days - 10   // Day 11 → 1, Day 15 → 5
        let message = warningMessage(for: warningIndex)

        if warningIndex == totalWarnings {
            onFinalWarning?(message)
        } else {
            onWarning?(warningIndex, message)
        }

        return true   // 🚨 Block other alerts
    }
    
    

    private func isSessionExpired() -> Bool {
        guard let loginDate = UserDefaults.standard.object(forKey: loginDateKey) as? Date else {
            return false
        }
        return Date() >= loginDate.addingTimeInterval(sessionDuration)
    }
    
    private func warningMessage(for index: Int) -> String {

        let header = "Warning \(index) of \(totalWarnings)\n\n"

        let body: String
        switch index {
        case 1:
            body = "Your session has been active for several days and contains unsynced data. Please sync your session and log out to ensure your data is saved securely."
        case 2:
            body = "Your session has been active for an extended period. We strongly recommend syncing your data and logging out to avoid potential data loss."
        case 3:
            body = "Warning: Your session will soon be forcibly logged out. Please sync all data and log out immediately to prevent loss of unsaved information."
        case 4:
            body = "Final Notice: Your session will be forcibly logged out tomorrow. Unsynced data may be lost. Please sync your session and log out now."
        case 5:
            body = "Session ended. Syncing data and logging out."
        default:
            body = ""
        }

        return header + body
    }

   /* private func messageForWarning(index: Int) -> String {
        let header = "Warning \(index) of \(totalWarnings)\n\n"

        let body: String
        
        switch index {
        case 1:
            body =  "Your session has been active for several days and contains unsynced data. Please sync your session and log out to ensure your data is saved securely."
        case 2:
            body = "Your session has been active for an extended period. We strongly recommend syncing your data and logging out to avoid potential data loss."
        case 3:
            body = "Warning: Your session will soon be forcibly logged out. Please sync all data and log out immediately to prevent loss of unsaved information."
        case 4:
            body = "Your session will be forcibly logged out tomorrow. Unsynced data may be lost. Please sync your session and log out now."
        default:
            return ""
        }
        return header + body
    }
    */

    func reset() {
        UserDefaults.standard.removeObject(forKey: warningIndexKey)
    }
}

