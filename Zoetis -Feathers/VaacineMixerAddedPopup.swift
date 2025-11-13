//
//  VaacineMixerAddedPopup.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 7/2/25.
//

import UIKit

class AlertPopupViewController: UIViewController {

    private let popupView = UIView()
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let noteLabel = UILabel()
    private let okButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .custom)
    let helveticaRegular = UIFont(name:"HelveticaNeue-Regular", size: 10.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // Gradient background for popup
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(red: 190/255, green: 235/255, blue: 1, alpha: 1.0).cgColor
        ]
        
        gradientLayer.locations = [0.5, 0.9]
        gradientLayer.cornerRadius = 12

        popupView.layer.insertSublayer(gradientLayer, at: 0)
        popupView.layer.cornerRadius = 12
        popupView.clipsToBounds = true
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)

        // Header
        headerView.backgroundColor = UIColor.systemBlue
        headerView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(headerView)

        // Header
        headerView.backgroundColor = UIColor.systemBlue
        headerView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(headerView)

        // 1. Add background image view
        let titleBackgroundImageView = UIImageView()
        titleBackgroundImageView.image = UIImage(named: "headerNavigation")
        titleBackgroundImageView.contentMode = .scaleAspectFill
        titleBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleBackgroundImageView)
        headerView.sendSubviewToBack(titleBackgroundImageView)

        // 2. Constrain the image view to headerView
        NSLayoutConstraint.activate([
            titleBackgroundImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleBackgroundImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            titleBackgroundImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleBackgroundImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])

        
        titleLabel.text = "Alert"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        headerView.addSubview(closeButton)

        // Message
        messageLabel.text = "New vaccine mixer name added successfully."
        messageLabel.font = helveticaRegular//.systemFont(ofSize: 15)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(messageLabel)

        // Note
        noteLabel.text = "Note: The vaccine mixer name will be added to the database only after the assessment has been submitted."
        noteLabel.font = helveticaRegular//.systemFont(ofSize: 13)
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 0
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(noteLabel)

        // OK Button
        okButton.setTitle("Ok", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = UIColor(hexString: "2276B6")
        okButton.titleLabel?.font = helveticaRegular//.systemFont(ofSize: 15)
        okButton.layer.cornerRadius = 10
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        popupView.addSubview(okButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popupView.layer.sublayers?.first?.frame = popupView.bounds
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 700),
            popupView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
        ])

        // Header view
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: popupView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 25),
            messageLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),

            noteLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            noteLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            noteLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),

            okButton.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 22),
            okButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 180),
            okButton.heightAnchor.constraint(equalToConstant: 40),
            okButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -30)
        ])
    }

    @objc private func dismissPopup() {
        dismiss(animated: true)
    }
}
