//
//  View.swift
//  Zoetis -Feathers
//
//  Created by MobileProgramming on 11/03/22.
//

import UIKit
import WebKit

class View: UIView , WKNavigationDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var viewForWeb: UIView!
    @IBOutlet weak var viewWeb: WKWebView!
    
    // MARK: - Variables
    var webView: WKWebView!
}
