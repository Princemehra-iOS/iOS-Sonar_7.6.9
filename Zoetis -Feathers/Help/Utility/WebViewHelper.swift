//
//  WebViewHelper.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 5/15/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView: WKWebView!
    var fileUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the WKWebView
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        // Add a navigation bar with a Close button
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let navItem = UINavigationItem(title: "")
        let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navItem.rightBarButtonItem = closeItem
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)

        // Set up constraints for the navBar
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Add the webView and constrain it below the navBar
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Load the PDF file
        if let filePath = fileUrl {
            webView.loadFileURL(filePath, allowingReadAccessTo: filePath)
        }
    }

    @objc func closeTapped() {
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
}
