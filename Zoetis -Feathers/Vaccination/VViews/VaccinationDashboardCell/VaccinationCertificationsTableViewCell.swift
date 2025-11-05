//
//  VaccinationCertificationsTableViewCell.swift
//  
//
//  Created by Mobile Programming on 07/04/20.
//

import UIKit

class VaccinationCertificationsTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS
    
    @IBOutlet var dateVw: UIView!
    @IBOutlet var customerVw: UIView!
    @IBOutlet var certificationTypeVw: UIView!
    @IBOutlet var locationVw: UIView!
    @IBOutlet var managerVw: UIView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var customerLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var certificationTypeLbl: UILabel!
    @IBOutlet var managerLbl: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mainVw: UIView!
    @IBOutlet weak var customerColorVw: UIView!
    @IBOutlet weak var certTypeColorVw: UIView!
    @IBOutlet weak var separatorLbl: UILabel!
    @IBOutlet weak var certManagerVw: UIView!
    @IBOutlet weak var btnVw: UIView!
    @IBOutlet weak var btnStackVw: UIStackView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    // MARK: - VARIABLES
    
    static let identifier =  "vaccinationCertificationTableViewCell"
    class var classIdentifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: classIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - METHODS AND FUNCTIONS
    
    func setWhiteBackgroundColor(){
        customerColorVw.backgroundColor = UIColor.white
        certTypeColorVw.backgroundColor = UIColor.white
        certManagerVw.backgroundColor = UIColor.white
        separatorLbl.backgroundColor = UIColor.greyTblBackground()
    }
    
    func removeCertVw(){
        stackView.removeArrangedSubview(certificationTypeVw)
        certificationTypeVw.removeFromSuperview()
        managerVw.backgroundColor = UIColor.greyTblBackground()
    }
    
    func removeBtnVw(){
        if btnStackVw != nil{
            btnStackVw.subviews.forEach({$0.removeFromSuperview()})
            stackView.removeArrangedSubview(btnStackVw)
            btnStackVw.removeFromSuperview()
            stackView.removeArrangedSubview(btnVw)
            btnVw.removeFromSuperview()
        }
    }
    
    func hideDeleteBtn(){
        if let closeButton = closeBtn {
            stackView.removeArrangedSubview(closeButton)
            closeBtn.isHidden = true
            closeBtn.isUserInteractionEnabled = false
            closeBtn.removeFromSuperview()
        }
    }
    
    func removeStatus(){
        stackView.removeArrangedSubview(certificationTypeVw)
        certificationTypeVw.removeFromSuperview()
        stackView.removeArrangedSubview(certificationTypeVw)
        certificationTypeVw.removeFromSuperview()
    }
    
    func addCertCategory(vaccinationCertificatonObj:VaccinationCertificationVM){
        if vaccinationCertificatonObj.certificationCategoryId == "1"{
            managerLbl.text = "359 Form"
        } else{
            managerLbl.text = "Operator"
        }
    }
    
    func setValues(vaccinationCertificatonObj:VaccinationCertificationVM){
        dateLbl.text = vaccinationCertificatonObj.scheduledDate
        dateLbl.text = CodeHelper.sharedInstance.convertDateFormater(vaccinationCertificatonObj.scheduledDate ?? "")
        
        if vaccinationCertificatonObj.scheduledDate == nil {
            dateLbl.text = "Exception occure"
        }
        
        customerLbl.text = vaccinationCertificatonObj.customerName
        locationLbl.text = vaccinationCertificatonObj.siteName ?? ""
        certificationTypeLbl.text = vaccinationCertificatonObj.certificationTypeName
        managerLbl.text = vaccinationCertificatonObj.fsmName
        let formatter = CodeHelper.sharedInstance.getDateFormatterObj("")
        formatter.dateFormat = Constants.yyyyMMddHHmmss
        
        let firstDate = formatter.date(from: vaccinationCertificatonObj.scheduledDate ?? "")
        let secondDate = Date()
        if firstDate?.compare(secondDate) == .orderedAscending{
            
            managerLbl.text = "Pending"
        } else{
            managerLbl.text = "Scheduled"
        }
        
    }
    
    func setPEValues(vaccinationCertificatonObj:PENewAssessment){
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.MMddyyyyStr
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        dateLbl.text = "\(vaccinationCertificatonObj.quarter!)" + " " + "\(vaccinationCertificatonObj.year!)"
        customerLbl.text = vaccinationCertificatonObj.customerName
        locationLbl.text = vaccinationCertificatonObj.siteName ?? ""
        managerLbl.text = vaccinationCertificatonObj.visitName
        let regionID = UserDefaults.standard.integer(forKey: "Regionid")
        
        if regionID == 3
        {
            if vaccinationCertificatonObj.sanitationEmbrex == 1{
                certificationTypeLbl.text = "Yes"
            }else{
                certificationTypeLbl.text = Constants.noStr
            }
        }
        else
        {
            certificationTypeLbl.text = vaccinationCertificatonObj.countryName
        }
    }
}
