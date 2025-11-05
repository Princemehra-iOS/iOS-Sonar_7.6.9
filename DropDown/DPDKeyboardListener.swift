//
//  KeyboardListener.swift
//
//  Created by "" ""on 21/11/18.
//  Copyright © "" Kumar Panday. All rights reserved.
//



import UIKit

internal final class KeyboardListener {
	
	static let sharedInstance = KeyboardListener()
	
	fileprivate(set) var isVisible = false
	fileprivate(set) var keyboardFrame = CGRect.zero
	fileprivate var isListening = false
	
	deinit {
		stopListeningToKeyboard()
	}
	
}

//MARK: - Notifications

extension KeyboardListener {
	
	func startListeningToKeyboard() {
		if isListening {
			return
		}
		
		isListening = true
        
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(KeyboardListener.keyboardDidShow(_:)),
            name: UIApplication.keyboardDidShowNotification,
			object: nil)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(KeyboardListener.keyboardDidHide(_:)),
			name: UIApplication.keyboardDidHideNotification,
			object: nil)
	}
	
	func stopListeningToKeyboard() {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc
	fileprivate func keyboardDidShow(_ notification: Notification) {
		isVisible = true
		keyboardFrame = keyboardFrameFromNotification(notification)
	}
	
	@objc
	fileprivate func keyboardDidHide(_ notification: Notification) {
		isVisible = false
		keyboardFrame = keyboardFrameFromNotification(notification)
	}
	
	fileprivate func keyboardFrameFromNotification(_ notification: Notification) -> CGRect {
        return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
	}
	
}
