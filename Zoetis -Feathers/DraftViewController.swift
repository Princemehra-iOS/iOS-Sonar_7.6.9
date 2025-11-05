//
//  DraftViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 04/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class DraftViewController: BaseViewController {

        //MARK:- Custom NavBar Properties
       @IBOutlet weak var sideMenuBtn: UIButton!
       
       //MARK:- Status & Survey Properties
       @IBOutlet weak var statusSurveyView: UIView!
       @IBOutlet weak var selectSurveyTextField: UITextField!
       @IBOutlet weak var selectSurveyDropDownBtn: UIButton!
       
       //MARK:- Table
       @IBOutlet weak var tblHeaderFixedView: UIView!
       @IBOutlet weak var tblViewRequisition: UITableView!
       
       
       //MARK:- Other Outlets
       @IBOutlet weak var lblNoDraftFound: UILabel!
    
       private let seperatorColor = UIColor(displayP3Red: 156/255, green: 187/255, blue: 1, alpha: 1.0)
       private let borderColorOfTextField = UIColor(displayP3Red: 204/255, green: 227/255, blue: 1, alpha: 1.0).cgColor
       private let heightOfFooter = CGFloat(0.1)
       private let heightOfRow = CGFloat(73.0)
       private let cornerRadius = CGFloat(18.5)
       private let borderWidth = CGFloat(1.0)
       private let textFieldPadding = CGFloat(10.0)
       
       private let gradientColorHeaderTable1 = UIColor(displayP3Red: 21/255, green: 165/255, blue: 198/255, alpha: 1.0).cgColor
       private let gradientColorHeaderTable2 = UIColor(displayP3Red: 15/255, green: 117/255, blue: 187/255, alpha: 1.0).cgColor
       private let gradientstatusSurveyView1 = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
       private let gradientstatusSurveyView2 = UIColor(displayP3Red: 210/255, green: 231/255, blue: 1.0, alpha: 1.0).cgColor
       
       private let kDraftsCell = "DraftsTableViewCell"
       private let kLeftMenuNotification = "LeftMenuBtnNoti"
       private let kMicrobial = "Microbial"
       private let kEnviromentalSurveyController = "EnviromentalSurveyController"
       private let kFeatherPulpVC = "FeatherPulpVC"
       private let kNoValue = "All"
       
       private var arrSurveyStatus : [String] = []
       private var arrDraftsViewRequisition : [Microbial_EnviromentalSurveyFormSubmitted] = [] {
        didSet{
            self.tblViewRequisition.reloadData()
        }
       }
       private let objDraftViewModel = DraftsViewModel()
    
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.setAttributes()
        self.setTableViewAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrDraftsViewRequisition = self.getDataFromLocal()
        for item in self.objDraftViewModel.getRequisitionArray(arrDraft: self.arrDraftsViewRequisition) {
            print("your item is here :\(item)")
            if item != "" {
                self.arrSurveyStatus.append(item)
            } else {
                print("one case is genrated")
            }
        }
    }
    
    private func getDataFromLocal() -> [Microbial_EnviromentalSurveyFormSubmitted]{
        let requisitionArray = self.objDraftViewModel.getData()
        self.showData(isDataAvailable: (requisitionArray.count > 0))
        return requisitionArray
    }
    
    //MARK:- Set TableView Attributes
    private func setTableViewAttributes() {
        self.tblViewRequisition.register(UINib(nibName: kDraftsCell, bundle: nil), forCellReuseIdentifier: kDraftsCell)
        self.tblViewRequisition.delegate = self
        self.tblViewRequisition.dataSource = self
        self.tblViewRequisition.separatorColor = seperatorColor
    }
    
    //MARK:- Set Other Attributes
    private func setAttributes() {
        self.setAttributesOfTextField(textField: selectSurveyTextField)
        self.selectSurveyDropDownBtn.addTarget(self, action: #selector(selectSurveyAction(_:)), for: .touchUpInside)
        self.sideMenuBtn.addTarget(self, action: #selector(openSideMenu(_:)), for: .touchUpInside)
        self.setGradient()
    }
    
    private func setAttributesOfTextField(textField: UITextField) {
        textField.layer.cornerRadius = cornerRadius
        textField.layer.borderWidth  = borderWidth
        textField.layer.borderColor  = borderColorOfTextField
        textField.setLeftPaddingPoints(textFieldPadding)
        textField.setRightPaddingPoints(textFieldPadding)
        textField.delegate = self
    }
    
    private func setGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [gradientColorHeaderTable1, gradientColorHeaderTable2]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.tblHeaderFixedView.frame.size.height)
        self.tblHeaderFixedView.layer.insertSublayer(gradient, at: 0)
        
        let gradientStatusSurveyView: CAGradientLayer = CAGradientLayer()
        gradientStatusSurveyView.colors = [gradientstatusSurveyView1, gradientstatusSurveyView2]
        gradientStatusSurveyView.locations = [0.0 , 1.0]
        gradientStatusSurveyView.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientStatusSurveyView.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientStatusSurveyView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.statusSurveyView.frame.size.height)
        self.statusSurveyView.layer.insertSublayer(gradientStatusSurveyView, at: 0)
    }
    
    
    private func showData(isDataAvailable: Bool) {
        self.statusSurveyView.isHidden = !isDataAvailable
        self.tblHeaderFixedView.isHidden = !isDataAvailable
        self.tblViewRequisition.isHidden = !isDataAvailable
        self.lblNoDraftFound.isHidden = isDataAvailable
    }
    
    
    private func setDropdrown(_ textField: UITextField, dropDownArr:[String]?) {
        if let dropDownArray = dropDownArr,
            dropDownArray.count > 0 {
            
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: textField.frame.width, kAnchor: textField, yheight: textField.bounds.height) {  selectedVal, index  in
                if selectedVal != self.kNoValue {
                    textField.text = selectedVal
                    self.arrDraftsViewRequisition = self.objDraftViewModel.filterDataAccordingToRequisitionSelected(selectedRequistion: selectedVal, arrViewRequisition: self.getDataFromLocal())
                } else {
                    textField.text = ""
                    self.arrDraftsViewRequisition = self.getDataFromLocal()
                }
            }
            self.dropHiddenAndShow()
        }
    }
    
    private func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    
    private func showAlert(completionHandler: @escaping (_ yesOrNo: Bool) -> Void){
        let alert = UIAlertController(title: Constants.alertStr, message: "Are you sure you want to delete??", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in    completionHandler(true) }))
        alert.addAction(UIAlertAction(title: Constants.noStr, style: .default, handler: { action in    completionHandler(false) }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func pushToRequisitionControllers(detailsOfRequistion: Microbial_EnviromentalSurveyFormSubmitted) {
        guard let requisitionType = detailsOfRequistion.requisitionType?.intValue,
              requisitionType == RequisitionType.bacterial.rawValue || requisitionType == RequisitionType.enviromental.rawValue,
              let viewController = UIStoryboard(name: kMicrobial, bundle: nil).instantiateViewController(withIdentifier: kEnviromentalSurveyController) as? EnviromentalSurveyController,
              let navigator = navigationController else { return }
        
        viewController.savedData = detailsOfRequistion
        viewController.requisitionSavedSessionType = .SHOW_DRAFT_FOR_EDITING
        viewController.currentRequisitionType = requisitionType == RequisitionType.bacterial.rawValue ? .bacterial : .enviromental
        navigator.pushViewController(viewController, animated: true)
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension DraftViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDraftsViewRequisition.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: kDraftsCell, for: indexPath) as? DraftsTableViewCell{
            cell.arrViewRequistion = self.arrDraftsViewRequisition
            cell.setCornerRadiusOfFirstAndLastCell(indexPath: indexPath)
            cell.showData(indexPath: indexPath)
            cell.buttonDeleteAction = { sender in
                self.showAlert { (yes) in
                    if yes{
                        self.objDraftViewModel.deleteRequisition(self.arrDraftsViewRequisition[indexPath.row])
                        self.arrDraftsViewRequisition = self.getDataFromLocal()
                    }
                }
            }
            
            cell.buttonEditAction = { sender in
                self.pushToRequisitionControllers(detailsOfRequistion: self.arrDraftsViewRequisition[indexPath.row])
            }
            return cell
        }else{
            return ViewRequisistionTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfRow
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter
    }

}



//MARK:- UITextFieldDelegate
extension DraftViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case selectSurveyTextField:
            self.setDropdrown(textField, dropDownArr: self.arrSurveyStatus)
            
        default:
            break
        }
        return false
    }
}



//MARK:- Button Actions
extension DraftViewController{
    @objc private func selectSurveyAction(_ sender: UIButton?) {
        self.setDropdrown(selectSurveyTextField, dropDownArr: self.arrSurveyStatus)
    }
    
    @objc private func openSideMenu(_ sender: UIButton?) {
        NotificationCenter.default.post(name: NSNotification.Name(kLeftMenuNotification), object: nil, userInfo: nil)
    }

}
