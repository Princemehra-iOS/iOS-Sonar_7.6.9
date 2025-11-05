//
//  Untitled.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 6/26/25.
//
import UIKit

class VaccineMixerPopupViewController: UIViewController {

    var details: VaccineMixerDetails!
    let width = 850.0
    let height = 190.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurBackground()
        setupPopup()
    }

    private func setupBlurBackground() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupPopup() {
        let popup = UIView()
        popup.translatesAutoresizingMaskIntoConstraints = false
        popup.backgroundColor = .white
        popup.layer.cornerRadius = 12
        popup.clipsToBounds = true
        view.addSubview(popup)

        NSLayoutConstraint.activate([
            popup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popup.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popup.widthAnchor.constraint(equalToConstant: width),
            popup.heightAnchor.constraint(equalToConstant: height)
        ])
        
        // Gradient Header
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(headerView)

        // Add background image
        let titleBackgroundImageView = UIImageView()
        titleBackgroundImageView.image = UIImage(named: "headerNavigation")
        titleBackgroundImageView.contentMode = .scaleAspectFill
        titleBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleBackgroundImageView)
        headerView.sendSubviewToBack(titleBackgroundImageView)

        NSLayoutConstraint.activate([
            titleBackgroundImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleBackgroundImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            titleBackgroundImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleBackgroundImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])

        // Gradient Layer on top of image
//        let gradientLayers = CAGradientLayer()
////        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: 44)
//        headerView.layer.insertSublayer(gradientLayer, above: titleBackgroundImageView.layer)

        let titleLabel = UILabel()
        titleLabel.text = "Vaccine Mixer Details"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: popup.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: popup.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: popup.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44),

//            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])


        // Content
        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.spacing = 10
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            contentStack.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 30),
            contentStack.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: popup.bottomAnchor, constant: -40)
        ])
        contentStack.addArrangedSubview(makeRow("Source", "FSS/FSM Name",false))
        contentStack.addArrangedSubview(makeRow(details.source, details.fssFSMName,true))
        contentStack.addArrangedSubview(makeRow("Customer", "Added Date",false))
        contentStack.addArrangedSubview(makeRow(details.customer, details.addedDate,true))
        contentStack.addArrangedSubview(makeRow("Site ID Name", "Vaccine Mixer Name",false))
        contentStack.addArrangedSubview(makeRow(details.siteIDName,  details.vaccineMixerName,true))
    }
    
    private func makeRow(_ label1:String,_ label2:String,_ isBold:Bool) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 5
        row.distribution = .fillEqually

        row.addArrangedSubview(makeColumn(label1, label2, isBold: isBold))
        return row
    }
    
    private func makeColumn(_ label: String, _ value: String, isBold:Bool) -> UIStackView {
        let titleLabel1 = UILabel()
        titleLabel1.text = label
        titleLabel1.font = .systemFont(ofSize: 12)
        titleLabel1.textColor = .darkGray
        titleLabel1.numberOfLines = 0
        titleLabel1.minimumScaleFactor = 0.7
        if isBold {
            titleLabel1.font = .boldSystemFont(ofSize: 12)
            titleLabel1.textColor = .black
        }
        
        let titleLabel2 = UILabel()
        titleLabel2.text = value
        titleLabel2.font = .systemFont(ofSize: 12)
        titleLabel2.textColor = .darkGray
        if isBold {
            titleLabel2.font = .boldSystemFont(ofSize: 12)
            titleLabel2.textColor = .black
        }
        titleLabel2.numberOfLines = 0
        titleLabel2.minimumScaleFactor = 0.7
        
        let column = UIStackView(arrangedSubviews: [titleLabel1, titleLabel2])
        column.axis = .vertical
        column.spacing = 10

        return column
    }

    @objc private func dismissSelf() {
        self.dismiss(animated: true)
    }
}
