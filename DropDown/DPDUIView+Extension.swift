//
//  UIView+Constraints.swift
//  Created by "" ""on 21/11/18.
//  Copyright © "" Kumar Panday. All rights reserved.
//




import UIKit

//MARK: - Constraints

internal extension UIView {
	
    func addConstraints(_ format: String, options: NSLayoutConstraint.FormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: UIView]) {
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views))
	}
	
    func addUniversalConstraints(_ format: String, options: NSLayoutConstraint.FormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: UIView]) {
		addConstraints("H:\(format)", options: options, metrics: metrics, views: views)
		addConstraints("V:\(format)", options: options, metrics: metrics, views: views)
	}
	
}



//MARK: - Bounds

internal extension UIView {
	
	var windowFrame: CGRect? {
		return superview?.convert(frame, to: nil)
	}
	
}

internal extension UIWindow {
	
	static func visibleWindow() -> UIWindow? {
		var currentWindow = UIApplication.shared.keyWindow
		
		if currentWindow == nil {
			let frontToBackWindows = Array(UIApplication.shared.windows.reversed()) 
			
			for window in frontToBackWindows {
                if window.windowLevel == UIWindow.Level.normal {
					currentWindow = window
					break
				}
			}
		}
		
		return currentWindow
	}
	
}
