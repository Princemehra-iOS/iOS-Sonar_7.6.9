//
//  UnsyncedTableCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 5/23/25.
//

import UIKit

class ExportLogsTableCell: UITableViewCell {
    
    let quarterLabel = UILabel()
    let customerLabel = UILabel()
    let siteLabel = UILabel()
    let exportLabel = UILabel()
    let exportButton = UIButton(type: .system)
    
    var exportAction: ((Int) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            quarterLabel,
            customerLabel,
            siteLabel,
            exportLblAndButtonStack,
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 4
        return stack
    }()
    
    private lazy var exportLblAndButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            exportLabel,
            exportButton
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabels()
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(peData: PENewAssessment?,PVEData:[String : AnyObject]?,headerData:[String]?, isHeader: Bool,isPE:Bool = true,indexPath:IndexPath) {
        
        if isHeader {
            if let headData = headerData {
                quarterLabel.text = headData[0]
                customerLabel.text = headData[1]
                siteLabel.text = headData[2]
                exportLabel.text = headData[3]
                configureAsHeader()
                setupHeaderBGImage()
            }
        } else {
            if isPE {
                if let assData = peData {
                    quarterLabel.text = assData.evaluationDate
                    customerLabel.text = assData.customerName
                    siteLabel.text = assData.siteName
                    exportLabel.text = "Export Logs"
                    configureAsRegular()
                }
            } else {
                if let pveData = PVEData {
                    quarterLabel.text = pveData["Evaluation_Date"] as? String
                    customerLabel.text = pveData["evaluator"] as? String
                    siteLabel.text = pveData["evaluationFor"] as? String
                    exportLabel.text = "Export Logs"
                    configureAsRegular()
                }
            }
        }
    }

    private func configureLabels() {
        let labels = [quarterLabel, customerLabel, siteLabel,exportLabel]
        labels.forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    private func configureAsHeader() {
        let labels = [quarterLabel, customerLabel, siteLabel,exportLabel]
        labels.forEach {
            $0.font = UIFont.boldSystemFont(ofSize: 15)
            $0.textColor = .white
        }
        exportButton.isHidden = true
        exportLabel.isHidden = false
    }

    private func configureAsRegular() {
        exportButton.isHidden = false
        exportLabel.isHidden = true
    }
    
    private func setupHeaderBGImage() {
        let backgroundImage = UIImage(named: "poppupHeader")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        self.backgroundView = imageView
    }
}
