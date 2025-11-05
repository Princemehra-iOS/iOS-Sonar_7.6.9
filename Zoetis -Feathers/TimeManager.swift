//
//  TimerViewController.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 12/05/25.
//

import Foundation
import UIKit
import CoreData

class TimeManager {
    static let shared = TimeManager()
    private init() {}

    private let sessionDuration: TimeInterval = 10 * 24 * 60 * 60 // 10 days
 //   private let sessionDuration: TimeInterval = 2 * 60 * 60
 //   private let sessionDuration: TimeInterval = 10 * 60
    private var timer: Timer?
    private var didShowTwoDayWarning = false

    var onTick: ((String) -> Void)?       // Update UI
    var onSessionExpired: (() -> Void)?   // Handle logout
    var onTwoDayWarning: (() -> Void)?    // Optional: 2-day left alert

    func startSession() {
        // Only set login date if it's not already saved
        if UserDefaults.standard.object(forKey: "LoginDate") == nil {
            UserDefaults.standard.set(Date(), forKey: "LoginDate")
        }
        didShowTwoDayWarning = false
        startTimer()
    }

    func clearSession() {
        stopTimer()
        UserDefaults.standard.removeObject(forKey: "LoginDate")
        didShowTwoDayWarning = false
    }

    private func startTimer() {
        stopTimer()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.isSessionExpired() {
                self.stopTimer()
                self.onSessionExpired?()
            } else {
                let remaining = self.getRemainingTime() ?? 0

                
                if remaining < 2 * 60, !self.didShowTwoDayWarning {
                    self.didShowTwoDayWarning = true
                    self.onTwoDayWarning?()
                }

                self.onTick?(self.formattedTimeLeft())
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func getRemainingTime() -> TimeInterval? {
        guard let loginDate = UserDefaults.standard.object(forKey: "LoginDate") as? Date else {
            return nil
        }

        let expiryDate = loginDate.addingTimeInterval(sessionDuration)
        let remaining = expiryDate.timeIntervalSinceNow

        return remaining > 0 ? remaining : nil
    }

    func isSessionExpired() -> Bool {
        return getRemainingTime() == nil
    }

    func formattedTimeLeft() -> String {
        guard let interval = getRemainingTime() else { return "Session expired" }

        let days = Int(interval) / 86400
        let hours = (Int(interval) % 86400) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60

        return String(format: "%02dd %02dh %02dm %02ds", days, hours, minutes, seconds)
    }
    
    func performAutoLogout() {
        // Clear all local Core Data first
        clearCoreDataAndUserdefaults()
        
        // Reset user session flags
        UserDefaults.standard.set(false, forKey: "newlogin")
        UserDefaults.standard.removeObject(forKey: "LoginDate")
        
        TimeManager.shared.clearSession()
        resetToLoginScreen()
    }
    
    func resetToLoginScreen() {
        
        if let vc  = UIApplication.getTopMostViewController(){
            for controller in (vc.navigationController?.viewControllers ?? []) as Array {
            if controller.isKind(of: ViewController.self) {
                vc.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }

    }
    
    private func clearAllUserDefaults() {

        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(false, forKey: "newlogin")
        UserDefaults.standard.set(true, forKey: "callDraftApi")
        self.initiateLeftPenal()
    }

    
    func initiateLeftPenal() {
        let containerViewController = ContainerViewController()
        UIApplication.shared.keyWindow?.rootViewController = containerViewController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }

    
    
    func clearCoreDataAndUserdefaults() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        guard let model = context.persistentStoreCoordinator?.managedObjectModel else { return }
        let entityNames = model.entities.compactMap { $0.name }

        for entityName in entityNames {
            debugPrint("all deleted entities:" , entityName)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(batchDeleteRequest)
            } catch {
                print("Failed to delete objects for entity \(entityName): \(error)")
            }
        }

        do {
            try context.save()
        } catch {
            print("Failed to save context after deleting data: \(error)")
        }
        
        self.clearAllUserDefaults()
    }
}
