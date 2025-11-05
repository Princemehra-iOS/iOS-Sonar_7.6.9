//
//  ViewRequisitionViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 02/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class ViewRequisitionViewController: BaseViewController {
    
    //MARK:- Custom NavBar Properties
    @IBOutlet weak var sideMenuBtn: UIButton!
    
    //MARK:- Status & Survey Properties
    @IBOutlet weak var statusSurveyView: UIView!
    @IBOutlet weak var selectStatusTextField: UITextField!
    @IBOutlet weak var selectStatusDropDownBtn: UIButton!
    @IBOutlet weak var selectSurveyTextField: UITextField!
    @IBOutlet weak var selectSurveyDropDownBtn: UIButton!
    
    //MARK:- Table
    @IBOutlet weak var tblHeaderFixedView: UIView!
    @IBOutlet weak var tblViewRequisition: UITableView!
    
    
    //MARK:- Other Outlets
    @IBOutlet weak var lblNoRequisitionFound: UILabel!
    
    
    //MARK:- Other Properties
    private let seperatorColor = UIColor(displayP3Red: 156/255, green: 187/255, blue: 225/255, alpha: 1.0)
    private let borderColorOfTextField = UIColor(displayP3Red: 204/255, green: 227/255, blue: 1.0, alpha: 1.0).cgColor
    private let heightOfFooter = CGFloat(0.1)
    private let heightOfRow = CGFloat(73.0)
    private let cornerRadius = CGFloat(18.5)
    private let borderWidth = CGFloat(1.0)
    private let textFieldPadding = CGFloat(10.0)
    
    private let gradientColorHeaderTable1 = UIColor(displayP3Red: 21/255, green: 165/255, blue: 198/255, alpha: 1.0).cgColor
    private let gradientColorHeaderTable2 = UIColor(displayP3Red: 15/255, green: 117/255, blue: 187/255, alpha: 1.0).cgColor
    private let gradientstatusSurveyView1 = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    private let gradientstatusSurveyView2 = UIColor(displayP3Red: 210/255, green: 231/255, blue: 1.0, alpha: 1.0).cgColor
    
    private let kRequisitionCell = "ViewRequisistionTableViewCell"
    private let kLeftMenuNotification = "LeftMenuBtnNoti"
    private let kNoValue = "All"
    
    private var arrSurveyStatus : [String] = []
    private var arrCaseStatus : [String] = []
    private let objViewRequisitionViewModel = ViewRequisitionViewModel()
    private var arrViewRequisition : [Microbial_EnviromentalSurveyFormSubmitted] = []{
        didSet{
            self.tblViewRequisition.reloadData()
        }
    }
    
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.setAttributes()
        self.setTableViewAttributes()
        self.arrViewRequisition = self.getDataFromLocal()
        
        for item in self.objViewRequisitionViewModel.getRequisitionArray(arrDraft: self.arrViewRequisition){
            print("your item is here :\(item)")
            if item != "" {
            self.arrSurveyStatus.append(item)
            }
            else {
                print("one case is genrated")
            }
        }
        
        if arrSurveyStatus.count > 0
        {
            selectSurveyTextField.text = kNoValue
            selectStatusTextField.text = kNoValue
        }
        
        
        self.arrCaseStatus = self.objViewRequisitionViewModel.getCaseStatus()
    }
    
    
    private func getDataFromLocal() -> [Microbial_EnviromentalSurveyFormSubmitted]{
        let requisitionArray = self.objViewRequisitionViewModel.getData()
        self.showData(isDataAvailable: (requisitionArray.count > 0))
        return requisitionArray
    }
    
    //MARK:- Set TableView Attributes
    private func setTableViewAttributes(){
        self.tblViewRequisition.register(UINib(nibName: kRequisitionCell, bundle: nil), forCellReuseIdentifier: kRequisitionCell)
        self.tblViewRequisition.delegate = self
        self.tblViewRequisition.dataSource = self
        self.tblViewRequisition.separatorColor = seperatorColor
    }
    
    //MARK:- Set Other Attributes
    private func setAttributes(){
//        self.statusSurveyView.roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
//        self.tblHeaderFixedView.roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
        self.selectStatusDropDownBtn.addTarget(self, action: #selector(selectStatusAction(_:)), for: .touchUpInside)
        self.selectSurveyDropDownBtn.addTarget(self, action: #selector(selectSurveyAction(_:)), for: .touchUpInside)
        self.sideMenuBtn.addTarget(self, action: #selector(openSideMenu(_:)), for: .touchUpInside)
        self.setAttributesOfTextField(textField: selectSurveyTextField)
        self.setAttributesOfTextField(textField: selectStatusTextField)
        self.setGradient()
    }
    
    
    //MARK:- Set TextField Attributes
    private func setAttributesOfTextField(textField: UITextField){
        textField.layer.cornerRadius = cornerRadius
        textField.layer.borderWidth  = borderWidth
        textField.layer.borderColor  = borderColorOfTextField
        textField.setLeftPaddingPoints(textFieldPadding)
        textField.setRightPaddingPoints(textFieldPadding)
        textField.delegate = self
    }
    
    private func setGradient(){ 
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [gradientColorHeaderTable1, gradientColorHeaderTable2]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.tblHeaderFixedView.frame.size.height)
        self.tblHeaderFixedView.layer.insertSublayer(gradient, at: 0)
        //
        let gradientStatusSurveyView: CAGradientLayer = CAGradientLayer()
        gradientStatusSurveyView.colors = [gradientstatusSurveyView1, gradientstatusSurveyView2]
        gradientStatusSurveyView.locations = [0.0 , 1.0]
        gradientStatusSurveyView.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientStatusSurveyView.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientStatusSurveyView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.statusSurveyView.frame.size.height)
        self.statusSurveyView.layer.insertSublayer(gradientStatusSurveyView, at: 0)
    }
    
    
    private func showData(isDataAvailable: Bool){
        self.statusSurveyView.isHidden = !isDataAvailable
        self.tblHeaderFixedView.isHidden = !isDataAvailable
        self.tblViewRequisition.isHidden = !isDataAvailable
        self.lblNoRequisitionFound.isHidden = isDataAvailable
    }
    
    
    //MARK:- Drop Down
    private func setDropdrown(_ textField: UITextField, dropDownArr:[String]?){
        if  dropDownArr!.count > 0 {
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: textField.frame.width, kAnchor: textField, yheight: textField.bounds.height) {  selectedVal, index  in
                textField.text = selectedVal
                self.arrViewRequisition = self.objViewRequisitionViewModel.filterDataAccordingToRequisitionSelected(selectedRequistion: self.selectSurveyTextField.text ?? "", caseStatus: self.selectStatusTextField.text ?? "", arrViewRequisition: self.getDataFromLocal())
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
        
    func pushToRequisitionControllers(detailsOfRequistion: Microbial_EnviromentalSurveyFormSubmitted){
        switch detailsOfRequistion.requisitionType?.intValue {
        case RequisitionType.bacterial.rawValue: 
            if let viewController = UIStoryboard(name: "Microbial", bundle: nil).instantiateViewController(withIdentifier: "EnviromentalSurveyController") as? EnviromentalSurveyController {
                viewController.savedData = detailsOfRequistion
                viewController.requisitionSavedSessionType = .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY
                viewController.currentRequisitionType = .bacterial
                let requisitionId = detailsOfRequistion.reqNo?.replacingOccurrences(of: "C-", with: "")
                viewController.selectedRequisionId = requisitionId
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        case RequisitionType.enviromental.rawValue:
            if let viewController = UIStoryboard(name: "Microbial", bundle: nil).instantiateViewController(withIdentifier: "EnviromentalSurveyController") as? EnviromentalSurveyController {
                viewController.savedData = detailsOfRequistion
                viewController.requisitionSavedSessionType = .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY
                let requisitionId = detailsOfRequistion.reqNo?.replacingOccurrences(of: "C-", with: "")
                viewController.selectedRequisionId = requisitionId
                viewController.currentRequisitionType = .enviromental
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        
        default:
            break
        }
    }
    
}





//MARK:- UITableViewDelegate, UITableViewDataSource
extension ViewRequisitionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrViewRequisition.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: kRequisitionCell, for: indexPath) as? ViewRequisistionTableViewCell{
            cell.arrViewRequistion = self.arrViewRequisition
            cell.setCornerRadiusOfFirstAndLastCell(indexPath: indexPath)
            cell.showData(indexPath: indexPath)
            cell.pdfOfSubmittedRequisition = { sender in
                print(appDelegateObj.testFuntion())
            }
            cell.viewSubmittedRequisitionDetails = { sender in
                self.pushToRequisitionControllers(detailsOfRequistion: self.arrViewRequisition[indexPath.row])
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
extension ViewRequisitionViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case selectStatusTextField:
            self.setDropdrown(textField, dropDownArr: self.arrCaseStatus)
            
        case selectSurveyTextField:
            self.setDropdrown(textField, dropDownArr: self.arrSurveyStatus)
            
        default:
            break
        }
        return false
    }
}



//MARK:- Button Actions
extension ViewRequisitionViewController{
    @objc private func selectStatusAction(_ sender: UIButton?) {
        self.setDropdrown(selectStatusTextField, dropDownArr: self.arrCaseStatus)
    }
    
    @objc private func selectSurveyAction(_ sender: UIButton?) {
        self.setDropdrown(selectSurveyTextField, dropDownArr: self.arrSurveyStatus)
    }
    
    @objc private func openSideMenu(_ sender: UIButton?) {
        NotificationCenter.default.post(name: NSNotification.Name(kLeftMenuNotification), object: nil, userInfo: nil)
    }

}
