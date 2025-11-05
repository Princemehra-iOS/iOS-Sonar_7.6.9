//
//  VaccineMixerCell.swift
//  Zoetis -Feathers
//
//  Created by MobileProgramming on 11/10/22.
//

import UIKit

struct VaccineMixerDetails {
    let source: String
    let customer: String
    let siteIDName: String
    let fssFSMName: String
    let addedDate: String
    let vaccineMixerName: String
}

class VaccineMixerCell: UITableViewCell  {
    
    // MARK: - OUTLETS
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var toggleImgView: UIImageView!
    @IBOutlet weak var vaccNameField: UITextField!
    @IBOutlet weak var vaccSelectBtn: UIButton!
    @IBOutlet weak var vaccDropImgView: UIImageView!
    @IBOutlet weak var certDateSelectBtn: UIButton!
    @IBOutlet weak var mixerSigImgView: UIImageView!
    @IBOutlet weak var fstSigImgView: UIImageView!
    @IBOutlet weak var calenderBtn: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var noMixerFoundView: UIView!
    @IBOutlet weak var addNewMixerBtn: UIButton!
    
    // MARK: - VARIABLES
    var nameCompletion:((_ error: String?) -> Void)?
    var certDateCompletion:((_ error: Int) -> Void)?
    var checkBoxCompletion:((_ error: String?) -> Void)?
    var changedDateCompletion:((_ error: Int?) -> Void)?
    var infoBtnCompletion:((_ error: Int?, _ cell: VaccineMixerCell ) -> Void)?
    var addNewMixerCompletion:((_ error: UITableViewCell) -> Void)?
    var certificateData:PECertificateData?
    var count: Int?
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vaccNameField.setLeftPaddingPoints(10.0)
        vaccNameField.font = UIFont.systemFont(ofSize: 18)
        vaccNameField.layer.borderWidth = 1.0
        vaccNameField.layer.cornerRadius = vaccNameField.frame.size.height/2
        vaccNameField.layer.masksToBounds = true
        vaccNameField.layer.borderColor = UIColor(red: 0.0, green: 200.0, blue: 226.0, alpha: 1.0).cgColor
        certDateSelectBtn.layer.borderColor = UIColor(red: 0.0, green: 200.0, blue: 226.0, alpha: 1.0).cgColor
    }
    
    func config(data:PECertificateData,_ mixerIdArray: [Int]? = nil){
        self.vaccNameField.text = data.name
        self.certDateSelectBtn.setTitle(data.certificateDate, for: .normal)
        certificateData = data
        if data.vacOperatorId != 0 && self.vaccNameField.text?.isEmpty == false {
            self.infoButton.isHidden = false
            self.vaccDropImgView.isHidden = false
        } else {
            self.infoButton.isHidden = true
            self.vaccDropImgView.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IB ACTIONS
    // MARK: Toggle Button Action
    @IBAction func toggleBtnAction(_ sender: Any) {
        checkBoxCompletion?(nil)
    }
    
    // MARK: Vaccine Button Action
    @IBAction func vaccMixerSelectAction(_ sender: Any) {
        nameCompletion?("")
    }
    // MARK: Date Selection Button Action
    @IBAction func certDateSelectAction(_ sender: UIButton) {
        let regionID = UserDefaults.standard.integer(forKey: "Regionid")
        if regionID != 3 {
            if(certificateData?.certificateDate == "") {
                certDateCompletion?(sender.tag)
            }
        }
    }
    // MARK: Certificate Date Button Action
    @IBAction func updateDateAction(_ sender: UIButton) {
        let  regionID = UserDefaults.standard.integer(forKey: "Regionid")
        if(regionID != 3){
            changedDateCompletion?(sender.tag)
        }
    }
    // MARK:  Info Button Action
    @IBAction func infoBtnAction(_ sender: UIButton) {
        
        let regionID = UserDefaults.standard.integer(forKey: "Regionid")
        if regionID == 3 {
            infoBtnCompletion?(infoButton.tag, self)
        }
    }
    
    // MARK: Add New Mixer Button Action
    @IBAction func addNewMixerBtn(_ sender: UIButton) {
        let regionID = UserDefaults.standard.integer(forKey: "Regionid")
        if regionID == 3 {
            addNewMixerCompletion?(self)
        }
    }
}

