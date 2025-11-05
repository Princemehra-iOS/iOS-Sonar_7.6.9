//
//  APIActivityTracker.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 6/6/25.
//

import Foundation

class APIActivityTracker {
    static let shared = APIActivityTracker()
    
    var activeRequestCount = 0
    private let queue = DispatchQueue(label: "api.activity.tracker")
    var showLoader: (() -> Void)?
    var hideLoader: (() -> Void)?

    func startRequest() {
        queue.sync {
            activeRequestCount += 1
            if activeRequestCount == 1 {
                DispatchQueue.main.async {
//                    appDelegateObj.showLoader()
                }
            }
        }
    }

    func endRequest() {
        queue.sync {
            activeRequestCount = max(activeRequestCount - 1, 0)
            if activeRequestCount == 0 {
                DispatchQueue.main.async {
//                    appDelegateObj.hideLoader()
                }
            }
        }
    }

    func reset() {
        queue.sync {
            activeRequestCount = 0
            DispatchQueue.main.async {
//                appDelegateObj.hideLoader()
            }
        }
    }
}
