//
//  Untitled.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 6/26/25.
//
import UIKit

class AddVaccineMixerPopupViewController: UIViewController {

    var assessmentDate = "02/03/2019"
    var customer = "Amick Farms Parent"
    var siteID = "pv 360"

    let vaccineMixerField = UITextField()
    let certificationDateField = UITextField()
    var selectedFieldIndex: Int?
    private var gradientLayer = CAGradientLayer()

    var onMixerInfoSaved: ((_ mixerName: String, _ certificateDate: String , _ indexIs: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlur()
        setupPopup()
    }

    private func setupBlur() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blur)

        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: view.topAnchor),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
            popup.widthAnchor.constraint(equalToConstant: 700),
            popup.heightAnchor.constraint(equalToConstant: 220)
        ])

        // MARK: - Header
        // Gradient Header
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(header)

//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: 700, height: 44)
//        header.layer.insertSublayer(gradientLayer, at: 0)

        let title = UILabel()
        title.text = "Add New Vaccine Mixer"
        title.font = .boldSystemFont(ofSize: 14)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false

        let titleBackgroundImageView = UIImageView()
        titleBackgroundImageView.image = UIImage(named: "headerNavigation")
        titleBackgroundImageView.contentMode = .scaleAspectFill
        titleBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        header.addSubview(titleBackgroundImageView)

        NSLayoutConstraint.activate([
            titleBackgroundImageView.topAnchor.constraint(equalTo: header.topAnchor),
            titleBackgroundImageView.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            titleBackgroundImageView.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            titleBackgroundImageView.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        header.addSubview(titleBackgroundImageView)
        header.addSubview(title)
        header.addSubview(closeButton)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: popup.topAnchor),
            header.leadingAnchor.constraint(equalTo: popup.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: popup.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 44),

//            title.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: header.centerXAnchor),

            closeButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])

        // MARK: - Info Row
        let infoRow = makeInfoRow()
        popup.addSubview(infoRow)

        NSLayoutConstraint.activate([
            infoRow.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            infoRow.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 16),
            infoRow.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -16)
        ])

        // MARK: - Input Row
        let inputRow = makeInputRow()
        popup.addSubview(inputRow)

        NSLayoutConstraint.activate([
            inputRow.topAnchor.constraint(equalTo: infoRow.bottomAnchor, constant: 12),
            inputRow.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 16),
            inputRow.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -16)
        ])

        // MARK: - Add Button
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(hexString: "2276B6")
        addButton.layer.cornerRadius = 18
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addButton.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        popup.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: inputRow.bottomAnchor, constant: 10),
            addButton.centerXAnchor.constraint(equalTo: popup.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func makeInfoRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 16
        row.translatesAutoresizingMaskIntoConstraints = false

        row.addArrangedSubview(makeLabelColumn(title: "Assessment Date", value: assessmentDate))
        row.addArrangedSubview(makeLabelColumn(title: "Customer", value: customer))
        row.addArrangedSubview(makeLabelColumn(title: "Site", value: siteID))
        return row
    }

    private func makeInputRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 16
        row.translatesAutoresizingMaskIntoConstraints = false

        vaccineMixerField.placeholder = "Enter Vaccine Mixer Name"
        certificationDateField.placeholder = "Select Certification Date"
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"  // ✅ Custom format
        
        let dateString = formatter.string(from: Date())
        certificationDateField.text = assessmentDate
        certificationDateField.isUserInteractionEnabled = false
        
        [vaccineMixerField, certificationDateField].forEach {
            $0.borderStyle = .roundedRect
            $0.font = .systemFont(ofSize: 13)
        }

        row.addArrangedSubview(makeInputColumn(title: "Vaccine Mixer", field: vaccineMixerField))
        row.addArrangedSubview(makeInputColumn(title: "Certification Date", field: certificationDateField))
        return row
    }

    private func makeLabelColumn(title: String, value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .gray

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 13)
        valueLabel.textColor = .black

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }

    private func makeInputColumn(title: String, field: UITextField) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .gray

        let stack = UIStackView(arrangedSubviews: [titleLabel, field])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc private func addBtnAction() {
        let mixerName = vaccineMixerField.text ?? ""
        if mixerName.count > 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"  // ✅ Custom format
            
            let dateString = formatter.string(from: Date())
            dismiss(animated: true)
            onMixerInfoSaved?(mixerName, assessmentDate, selectedFieldIndex ?? 0)
        } else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please add vaccine mixer name.")
            vaccineMixerField.layer.borderColor = UIColor.red.cgColor
            vaccineMixerField.layer.borderWidth = 1.5
            vaccineMixerField.setCornerRadius = 5
        }
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let header = view.subviews.first(where: { $0 is UIView })?.subviews.first {
            gradientLayer.frame = header.bounds
        }
    }
}
