//
//  CustomAlertViewController.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 01/12/25.
//

import Foundation


import UIKit

class CustomAlertViewController: UIViewController {

    private let alertMessage: String
    private let iconName: String

    init(message: String, iconName: String) {
        self.alertMessage = message
        self.iconName = iconName
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupUI()
    }

    private func setupUI() {

           let card = UIView()
           card.backgroundColor = .white
           card.layer.cornerRadius = 16
           card.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(card)

           NSLayoutConstraint.activate([
               card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               card.widthAnchor.constraint(equalToConstant: 260)
           ])

           let icon = UIImageView(image: UIImage(systemName: iconName))
           icon.tintColor = .systemRed
           icon.contentMode = .scaleAspectFit
           icon.translatesAutoresizingMaskIntoConstraints = false

           let label = UILabel()
           label.text = alertMessage
           label.textAlignment = .center
           label.numberOfLines = 0
           label.font = UIFont.systemFont(ofSize: 15)
           label.translatesAutoresizingMaskIntoConstraints = false

           let separator = UIView()
           separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
           separator.translatesAutoresizingMaskIntoConstraints = false

           let okButton = UIButton(type: .system)
           okButton.setTitle("OK", for: .normal)
           okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
           okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
           okButton.translatesAutoresizingMaskIntoConstraints = false

           card.addSubview(icon)
           card.addSubview(label)
           card.addSubview(separator)
           card.addSubview(okButton)

           NSLayoutConstraint.activate([
               icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
               icon.centerXAnchor.constraint(equalTo: card.centerXAnchor),
               icon.heightAnchor.constraint(equalToConstant: 40),
               icon.widthAnchor.constraint(equalToConstant: 40),

               label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
               label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
               label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),

               // Separator ABOVE OK Button
               separator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
               separator.leadingAnchor.constraint(equalTo: card.leadingAnchor),
               separator.trailingAnchor.constraint(equalTo: card.trailingAnchor),
               separator.heightAnchor.constraint(equalToConstant: 0.8),

               okButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12),
               okButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
               okButton.centerXAnchor.constraint(equalTo: card.centerXAnchor),
               okButton.heightAnchor.constraint(equalToConstant: 40)
           ])
       }

    @objc private func dismissAlert() {
        dismiss(animated: true)
    }
}
