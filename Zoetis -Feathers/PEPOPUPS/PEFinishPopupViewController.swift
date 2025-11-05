//
//  PEFinishPopupViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 19/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PEFinishPopupViewController: BaseViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var signatureImgView: UIImageView!
    @IBOutlet weak var signature2ImgView: UIImageView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var failChlorineStripLbl: UILabel!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var txtManagerName: PEFormTextfield!
    @IBOutlet weak var txtManagerName2: PEFormTextfield!
    @IBOutlet weak var empIdBtn: UIButton!
    @IBOutlet weak var empIdBtn2: UIButton!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var employeeIDView: UIView!
    @IBOutlet weak var employeIDView2: UIView!
    @IBOutlet weak var hatcheryManagerNameView: UIView!
    @IBOutlet weak var hatcheryManagerNameView2: UIView!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var signatureView2: YPDrawSignatureView!
    @IBOutlet weak var doneButton: PESubmitButton!
    @IBOutlet weak var txtPhone: UITextView!
    @IBOutlet weak var txtEmployeeID: PEFormTextfield!
    @IBOutlet weak var txtEmployeeID2: PEFormTextfield!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var totalResultLbl: UILabel!
    @IBOutlet weak var clearSignature: PESubmitButton!
    @IBOutlet weak var clearSignature2: PESubmitButton!
    
    // MARK: - VARIABLES
    
    var isRejectedAssessment:Bool = false
    var scheduledAssessment:PENewAssessment?
    var rejectedAssessments:[PE_AssessmentInProgress] = []
    var peNewAssessmentArrayForCatQuest1  : [PENewAssessment] = []
    var peNewAssessmentArrayForCatQuest  : [PENewAssessment] = []
    var  peNewAssessmentArray : [PENewAssessment] = []
    var sanitationQuesArr = [PE_ExtendedPEQuestion]()
    var catArrayForCollectionIs : [PENewAssessment] = []
    var hatheryManagerName = ""
    var hatheryManagerName2 = ""
    var employeeID = ""
    var employeeID2 = ""
    var phone = ""
    var module = ""
    var isFromSchedule = false
    var certificateData : [PECertificateData] = []
    var firstTime = true
    var validationSuccessFull:((_ param: [String:String]?) -> Void)?
    var golbalEvaluationID = 0
    var prevController = ""
    var isFromDraft : Bool = false
    var showExtendedPE:Bool = false
    var regionID = Int()
    
    // MARK: - VIEW LIFE CYCLE

    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        let assessmentId = UserDefaults.standard.value(forKey: "currentServerAssessmentId") as? String ?? ""
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
        self.signatureView.delegate = self
        self.doneButton.setNextButtonUI()
        self.clearSignature.setNextButtonUI()
        self.clearSignature2.setNextButtonUI()
        DispatchQueue.main.async {
            self.gradientView.setGradient(topGradientColor: UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientLowerColor())
        }
        
        peNewAssessmentArray = CoreDataHandlerPE().getOnGoingAssessmentArrayPEObject(serverAssessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        if isFromDraft {
            peNewAssessmentArray = CoreDataHandlerPE().getDraftOnGoingAssessmentArrayPEObject()
        }
        
        phoneView.backgroundColor = UIColor.white
        phoneView.layer.cornerRadius = 2
        phoneView.layer.masksToBounds = true
        phoneView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        phoneView.layer.borderWidth = 2.0
        txtPhone.layer.cornerRadius = 2
        txtPhone.layer.masksToBounds = true
        setUI(viewNew: employeeIDView)
        setUI(viewNew: employeIDView2)
        setUI(viewNew: hatcheryManagerNameView)
        setUI(viewNew: hatcheryManagerNameView2)
        txtPhone.delegate = self
        DispatchQueue.main.async {
            self.signatureView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.signatureView.layer.borderWidth = 2.0
            self.signatureView.layer.masksToBounds = true
            self.signatureView.layer.cornerRadius = 20.0
            self.signatureView.delegate = self
            
            self.signatureImgView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.signatureImgView.layer.borderWidth = 2.0
            self.signatureImgView.layer.masksToBounds = true
            self.signatureImgView.layer.cornerRadius = 20.0
            
            self.signatureView2.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.signatureView2.layer.borderWidth = 2.0
            self.signatureView2.layer.masksToBounds = true
            self.signatureView2.layer.cornerRadius = 20.0
            self.signatureView2.delegate = self
            
            self.signature2ImgView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.signature2ImgView.layer.borderWidth = 2.0
            self.signature2ImgView.layer.masksToBounds = true
            self.signature2ImgView.layer.cornerRadius = 20.0
            
        }
        
        if scheduledAssessment?.isAutomaticFail == 1{
            self.failChlorineStripLbl.isHidden = false
        }else{
            self.failChlorineStripLbl.isHidden = true
        }
        let isFromDraft = UserDefaults.standard.value(forKey: "isFromDraft") as? Bool
        if isFromDraft ?? false{
            rejectedAssessments = CoreDataHandlerPE().fetchRejectedDraftCustomerWithCatID(assessmentId: assessmentId) as? [PE_AssessmentInProgress] ?? []
            if rejectedAssessments.count > 0 {
                
                let empID1 = rejectedAssessments[0].sig_Name ?? ""
                isRejectedAssessment = true
                
                if empID1 != "" {
                    if Int(truncating: rejectedAssessments[0].sig ?? 0) > 0 {
                        let data = CoreDataHandlerPE().getImageByImageID(idArray:Int(truncating: (rejectedAssessments[0].sig)!))
                        DispatchQueue.main.async() {
                            self.signatureView.isHidden = true
                            self.signatureImgView.isHidden = false
                            self.signatureImgView.image = UIImage(data: data)
                        }
                    }else{
                        self.signatureView.isHidden = false
                        self.signatureImgView.isHidden = true
                    }
                    
                    if Int(truncating: rejectedAssessments[0].sig2 ?? 0) > 0 {
                        let data2 = CoreDataHandlerPE().getImageByImageID(idArray:Int(truncating: (rejectedAssessments[0].sig2)!))
                        DispatchQueue.main.async() {
                            self.signatureView2.isHidden = true
                            self.signature2ImgView.isHidden = false
                            self.signature2ImgView.image = UIImage(data: data2)
                        }
                    }else{
                        self.signatureView2.isHidden = false
                        self.signature2ImgView.isHidden = true
                    }
                    self.txtManagerName.text = rejectedAssessments[0].sig_Name
                    self.txtManagerName2.text = rejectedAssessments[0].sig_Name2
                    self.hatheryManagerName = rejectedAssessments[0].sig_Name ?? ""
                    self.hatheryManagerName2 = rejectedAssessments[0].sig_Name2 ?? ""
                    self.txtEmployeeID.text = rejectedAssessments[0].sig_EmpID
                    self.txtEmployeeID2.text = rejectedAssessments[0].sig_EmpID2
                    self.txtPhone.text = rejectedAssessments[0].sig_Phone
                    
                    
                }
                if rejectedAssessments[0].statusType == 2{
                    self.clearSignature.isHidden = true
                    self.clearSignature2.isHidden = true
                    self.txtManagerName.isUserInteractionEnabled = false
                    self.txtManagerName2.isUserInteractionEnabled = false
                    self.empIdBtn.isUserInteractionEnabled = false
                    self.empIdBtn2.isUserInteractionEnabled = false
                    self.txtPhone.isUserInteractionEnabled = false
                }
            }
        }
        
        self.txtPhone.delegate = self
        self.txtManagerName.delegate = self
        self.txtEmployeeID.delegate = self
        
        DispatchQueue.main.async {
            self.gradientView.setGradientThreeColors(topGradientColor:   UIColor.getGradientUpperColorStartAssessment(),midGradientColor:UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientUpperColorStartAssessmentLast())
        }
        
        tableview.register(PE_FinalizeCell.nib, forCellReuseIdentifier: PE_FinalizeCell.identifier)
        let nibCasz = UINib(nibName: "PEFinializeHeaderTableViewCell", bundle: nil)
        tableview.register(nibCasz, forCellReuseIdentifier: "PEFinializeHeaderTableViewCell")
        
        let nibCaszy = UINib(nibName: "SignatureTableViewCell", bundle: nil)
        tableview.register(nibCaszy, forCellReuseIdentifier: "signatureTableViewCell")
        filterCategory()
        
        sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        
        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        showExtendedPE = infoObj?.isExtendedPE ?? false
        calculateResult()
        
        self.showCustomerRepSignature()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        Constants.isMovedOn = false
    }
    
    func showCustomerRepSignature ()
    {

        
     
        if Constants.customRepSigIdFirst == 0
        {
            
        }
        else
        {
            let data = CoreDataHandlerPE().getImageByImageID(idArray: Constants.customRepSigIdFirst)
            if !data.isEmpty {
                DispatchQueue.main.async {
                    self.signatureView.isHidden = true
                    self.signatureImgView.isHidden = false
                    self.signatureImgView.image = UIImage(data: data)
                }
            } else {
                print("❌ Image data is empty (0 bytes)")
                self.signatureView.isHidden = false
                self.signatureImgView.isHidden = true
            }
        }
        
        if Constants.secoundcustomRepSigIdFirst == 0
        {
            
        }
        else
        {
            let data = CoreDataHandlerPE().getImageByImageID(idArray:(Constants.secoundcustomRepSigIdFirst))
            if !data.isEmpty {
                DispatchQueue.main.async {
                    self.signatureView2.isHidden = true
                    self.signature2ImgView.isHidden = false
                    self.signature2ImgView.image = UIImage(data: data)
                }
            } else {
                print("❌ Image data is empty (0 bytes)")
                self.signatureView2.isHidden = false
                self.signature2ImgView.isHidden = true
            }
        }
        
      
    }
    
    



    // MARK: - METHODS

    func convertLargeBase64ToCompressedString(Base64 : String) -> String {
        var signatureImg = CodeHelper.sharedInstance.convertToImage(base64:Base64)
        var compressedImg = signatureImg!.jpegData(compressionQuality: 0.1)
        var base64String = compressedImg!.base64EncodedString(options: .lineLength64Characters)
        
        return base64String
    }
    
    
    func crossNewClicked()
    {

        if golbalEvaluationID != 2 {
            var i = 0
            for item in  certificateData {
                if certificateData[i].signatureImg != "" {
                    let signatureImg =  convertLargeBase64ToCompressedString(Base64 : certificateData[i].signatureImg)
                    certificateData[i].signatureImg = signatureImg
                }
                if certificateData[i].fsrSign != "" {
                    let fsrSign = convertLargeBase64ToCompressedString(Base64 : certificateData[i].fsrSign)
                    certificateData[i].fsrSign = fsrSign
                }
                CoreDataHandlerPE().updateVMixerNewInDB(peCertificateData:  self.certificateData[i], id:  self.certificateData[i].id ?? 0)
                i = i + 1
            }
        }

       // self.customerRepSignatureSave()
    }
    
    
    func customerRepSignatureSave ()
    {
        
        let signatureImage1 = self.signatureView.getSignature(scale: 10)
        let signatureImage2 = self.signatureView2.getSignature(scale: 10)

        if signatureImage1 != nil || signatureImage2 != nil {
            DispatchQueue.main.async {
                var param: [String: String] = [:]

                if let image1 = signatureImage1 {
                    let imageData1 = image1.jpegData(compressionQuality: 0.1)
                    let imageCount1 = self.getImageCountInPEModule()
                    if let imageData1 = imageData1 {
                        
                        if self.scheduledAssessment?.sig != 0 && self.scheduledAssessment?.sig != nil
                        {
                            CoreDataHandlerPE().saveImageInPEFinishModule(imageId: (self.scheduledAssessment?.sig)!, imageData: imageData1)
                            Constants.customRepSigIdFirst = (self.scheduledAssessment?.sig)!
                        }
                        else
                        {
                            CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount1 + 1, imageData: imageData1)
                            Constants.customRepSigIdFirst = imageCount1 + 1
                        }
                    }
                }

                if let image2 = signatureImage2 {
                    let imageData2 = image2.jpegData(compressionQuality: 0.1)
                    let imageCount2 = self.getImageCountInPEModule()
                    if let imageData2 = imageData2 {
                        if self.scheduledAssessment?.sig2 != 0 && self.scheduledAssessment?.sig != nil
                        {
                            CoreDataHandlerPE().saveImageInPEFinishModule(imageId: (self.scheduledAssessment?.sig2)!, imageData: imageData2)
                            Constants.secoundcustomRepSigIdFirst = (self.scheduledAssessment?.sig2)!
                        }
                        else
                        {
                            CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount2 + 1, imageData: imageData2)
                            Constants.secoundcustomRepSigIdFirst = imageCount2 + 1 //
                        }
                    }
                }

                param = [
                    "sig": String(Constants.customRepSigIdFirst),
                    "sig2": String(Constants.secoundcustomRepSigIdFirst),
                    "sig_EmpID": self.txtEmployeeID.text ?? "",
                    "sig_EmpID2": self.txtEmployeeID2.text ?? "",
                    "sig_Name": self.hatheryManagerName ?? "",
                    "sig_Name2": self.hatheryManagerName2 ?? "",
                    "sig_Phone": self.txtPhone.text ?? "",
                    "sig_Date": Date().stringFormat(format: "MMM d, yyyy")
                ]

                print("params are", param)
            }
        }

        
        /*
        if let signatureImage = self.signatureView.getSignature(scale: 10) {
            DispatchQueue.main.async {

                let imageData = signatureImage.jpegData(compressionQuality: 0.1)
                var imageCountID = 0
                let imageCount = self.getImageCountInPEModule()
                if imageData != nil {
                    CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount+1, imageData: imageData!)
                }
                imageCountID = imageCount+1
                Constants.customRepSigIdFirst = imageCountID
              
                
                var param : [String:String] = ["sig":String(imageCountID),"sig_EmpID":self.txtEmployeeID.text ?? "","sig_EmpID2":self.txtEmployeeID2.text ?? "","sig_Name":self.hatheryManagerName ?? "","sig_Name2":self.hatheryManagerName2 ?? "","sig_Phone":self.txtPhone.text ?? "","sig_Date":Date().stringFormat(format: "MMM d, yyyy") ]
                let signatureImage2 = self.signatureView2.getSignature(scale: 10)
                
                let imageData2 = signatureImage2?.jpegData(compressionQuality: 0.1)
                if imageData2 != nil {
                    var imageCountID2 = 0
                    let imageCount2 = self.getImageCountInPEModule()
                    CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount2+1, imageData: imageData2!)
                    imageCountID2 = imageCount2+1
                    Constants.secoundcustomRepSigIdFirst = imageCountID2
                    
                    param  = ["sig":String(imageCountID),"sig2":String(imageCountID2),"sig_EmpID":self.txtEmployeeID.text ?? "","sig_EmpID2":self.txtEmployeeID2.text ?? "","sig_Name":self.hatheryManagerName ?? "","sig_Name2":self.hatheryManagerName2 ?? "","sig_Phone":self.txtPhone.text ?? "","sig_Date":Date().stringFormat(format: "MMM d, yyyy") ]
                }
                print("params are",param)
  
            }
                
        }
        
        */
        
        
    }
    
    func submitRejectedAssessmentSignature(){
        
        let  sig1 = Int(truncating: rejectedAssessments[0].sig ?? 0)
        if sig1 > 0 {
            DispatchQueue.main.async {
                if self.hatheryManagerName == "" {
                    self.hatcheryManagerNameView.layer.borderColor = UIColor.red.cgColor
                    self.hatcheryManagerNameView.layer.borderWidth = 2.0
                    self.showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
                    return
                }
                if self.txtEmployeeID.text == "" {
                    self.employeeIDView.layer.borderColor = UIColor.red.cgColor
                    self.employeeIDView.layer.borderWidth = 2.0
                    self.showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
                    return
                }
                var param : [String:String] = ["sig":String(sig1),"sig_EmpID":self.txtEmployeeID.text ?? "","sig_EmpID2":self.txtEmployeeID2.text ?? "","sig_Name":self.hatheryManagerName ?? "","sig_Name2":self.hatheryManagerName2 ?? "","sig_Phone":self.txtPhone.text ?? "","sig_Date":Date().stringFormat(format: "MMM d, yyyy") ]
                let  sig2 = Int(truncating: self.rejectedAssessments[0].sig2 ?? 0)
                if sig2 > 0 {
                    param  = ["sig":String(sig1),"sig2":String(sig2),"sig_EmpID":self.txtEmployeeID.text ?? "","sig_EmpID2":self.txtEmployeeID2.text ?? "","sig_Name":self.hatheryManagerName ?? "","sig_Name2":self.hatheryManagerName2 ?? "","sig_Phone":self.txtPhone.text ??                "","sig_Date":Date().stringFormat(format: "MMM d, yyyy") ]
                }
                print("params are",param)
                
                
                if let microAvailable =  UserDefaults.standard.value(forKey: "extendedAvailable") as? Bool
                {
                    if microAvailable == true
                    {
                        if let extendedValue = UserDefaults.standard.value(forKey: "ExtendedMicro") as? Bool
                        {
                            if extendedValue == true {
                                self.showExtendedMicroAlert(errorMsg: "Your PE & Extended Microbial Assessment has been submitted successfully", param: param)
                            }
                            else {
                                
                                if self.regionID == 3
                                {
                                    self.showExtendedMicroAlert(errorMsg: "Are you sure, you want to submit the assessment without Extended Microbial?", param: param)
                                }
                            }
                        }
                    }
                    else
                    {
                        self.validationSuccessFull?(param)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                else
                {
                    self.validationSuccessFull?(param)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            if hatheryManagerName == "" {
                hatcheryManagerNameView.layer.borderColor = UIColor.red.cgColor
                hatcheryManagerNameView.layer.borderWidth = 2.0
            }
            if self.txtEmployeeID.text == "" {
                self.employeeIDView.layer.borderColor = UIColor.red.cgColor
                self.employeeIDView.layer.borderWidth = 2.0
            }
            signatureView.layer.borderColor = UIColor.red.cgColor
            signatureView.layer.borderWidth = 2.0
            showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
            return
        }
        
    }

    //MARKS: DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    func setUI(viewNew:UIView){
        DispatchQueue.main.async {
            viewNew.backgroundColor = UIColor.white
            viewNew.layer.cornerRadius = viewNew.frame.height/2
            viewNew.layer.masksToBounds = true
            viewNew.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            viewNew.layer.borderWidth = 2.0
        }
    }
    
    func filterCategory() {
        var  peNewAssessmentArray = CoreDataHandlerPE().getOnGoingAssessmentArrayPEObject(isFromDraft:false, serverAssessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        if isFromDraft{
            peNewAssessmentArray = CoreDataHandlerPE().getOnGoingAssessmentArrayPEObject(isFromDraft:true, serverAssessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        }
        var carColIdArray : [Int] = []
        var carTabIdArray : [Int] = []
        
        var row = 0
        if peNewAssessmentArray[0].evaluationID != 2{
            var pe = PENewAssessment()
            pe.catID = 10
            pe.isOpened = true
            catArrayForCollectionIs.append(pe)
        }
        
        for cat in peNewAssessmentArray {
            if !carColIdArray.contains(cat.catID ?? 0){
                carColIdArray.append(cat.catID ?? 0)
                if(cat.sequenceNoo != 12 ){
                    catArrayForCollectionIs.append(cat)
                }
            }
        }
        tableview.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first ?? UITouch()
        if (touch.view?.tag == 1111){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - IB ACTIONS

    @IBAction func doneClicked(_ sender: Any) {
        
        
        if golbalEvaluationID != 2 {
          
            
            var i = 0
            for item in  certificateData {
                if certificateData[i].signatureImg != "" {
                    let signatureImg =  convertLargeBase64ToCompressedString(Base64 : certificateData[i].signatureImg)
                    certificateData[i].signatureImg = signatureImg
                }
                if self.certificateData[i].fsrSign != "" {
                    let fsrSign = convertLargeBase64ToCompressedString(Base64 : certificateData[i].fsrSign)
                    certificateData[i].fsrSign = fsrSign
                }
                CoreDataHandlerPE().updateVMixerNewInDB(peCertificateData:  certificateData[i], id:  certificateData[i].id ?? 0)
                i = i + 1
            }
  
            
        }
        
        if !isFromSchedule{
            if rejectedAssessments.count > 0{
                if rejectedAssessments[0].statusType == 2 {
                    submitRejectedAssessmentSignature()
                }else{
                    self.validate()
                }
            }else{
                self.validate()
            }
        }else{
            self.validate()
        }
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        
        self.crossNewClicked()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func titleAction2(_ sender: Any) {
        var vManufacutrerNameArray = NSArray()
        var vManufacutrerDetailsArray = NSArray()
        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Roles")
        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "roleName") as? NSArray ?? NSArray()
        if  vManufacutrerNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: vManufacutrerNameArray as? [String] ?? [String](), kWidth: txtEmployeeID2.frame.width, kAnchor: txtEmployeeID2, yheight: txtEmployeeID2.bounds.height) { [unowned self] selectedVal, index  in
                self.txtEmployeeID2.text = selectedVal
            }
            self.dropHiddenAndShow()
        }
    }
    
    
    @IBAction func titleAction(_ sender: Any) {
        var vManufacutrerNameArray = NSArray()
        var vManufacutrerDetailsArray = NSArray()
        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Roles")
        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "roleName") as? NSArray ?? NSArray()
        if  vManufacutrerNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: vManufacutrerNameArray as? [String] ?? [String](), kWidth: txtEmployeeID.frame.width, kAnchor: txtEmployeeID, yheight: txtEmployeeID.bounds.height) { [unowned self] selectedVal, index  in
                self.txtEmployeeID.text = selectedVal
            }
            self.dropHiddenAndShow()
        }
    }
    
    
    @IBAction func clearSignature2(_ sender: Any) {
        
        self.signatureView2.clear()
        self.signatureView2.isHidden = false
        self.signature2ImgView.isHidden = true
        
    }
    
    @IBAction func clearSignatureCliked(_ sender: Any) {
        self.signatureView.clear()
        self.signatureView.isHidden = false
        self.signatureImgView.isHidden = true
    }
    
}

// MARK: - EXTENSION FOR TABLE VIEW DELEGATES

extension PEFinishPopupViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return catArrayForCollectionIs.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var  peNewAssessmentArray = CoreDataHandlerPE().getOnGoingAssessmentArrayPEObject(serverAssessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        
        if isFromDraft {
            peNewAssessmentArray = CoreDataHandlerPE().getDraftOnGoingAssessmentArrayPEObject()
        }
        
        var peNewAssessmentArrayForCatQuest  : [PENewAssessment] = []
        let catID = catArrayForCollectionIs[section].catID
        for cat in peNewAssessmentArray {
            if  catID == cat.catID{
                golbalEvaluationID = (cat.evaluationID)!
                if (cat.evaluationID)! != 2 {
                    if firstTime {
                        cat.titleName = "Signature"
                        catArrayForCollectionIs[section].isOpened = true
                        peNewAssessmentArrayForCatQuest1.append(cat)
                        firstTime = false
                    }
                }
                peNewAssessmentArrayForCatQuest1.append(cat)
                peNewAssessmentArrayForCatQuest.append(cat)
            }
        }
        
        if  catArrayForCollectionIs[section].isOpened {
            
            if section == 0 {
                if golbalEvaluationID != 2 {
                    if  catArrayForCollectionIs[section].isOpened {
                        return 2
                    }
                    else {
                        return 1
                    }
                }
                else {
                    return peNewAssessmentArrayForCatQuest.count
                }
            }
            else {
                return peNewAssessmentArrayForCatQuest.count
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if  catArrayForCollectionIs[indexPath.section].isOpened {
                if golbalEvaluationID != 2 {
                    if indexPath.row == 1 {
                        return 220
                    }
                    else{
                        return 40
                    }
                }
                else {
                    return 40
                }
            }
            else{
                return 40
            }
        }
        else {
            
            return 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0 && catArrayForCollectionIs[0].isOpened ){
            if golbalEvaluationID != 1 {
                tableView.isScrollEnabled = true
            }
            else{
                tableView.isScrollEnabled = false
            }
        }
        else{
            tableView.isScrollEnabled = true
        }
        
        
        if indexPath.row == 0 {
            if   let headerView = tableView.dequeueReusableCell(withIdentifier: "PEFinializeHeaderTableViewCell") as? PEFinializeHeaderTableViewCell {
                headerView.contentView.backgroundColor =  UIColor.cellAlternateBlueCOlor()
                
                if golbalEvaluationID != 2 {
                    if indexPath.section == 0 {
                        headerView.lblTitle.text = "Signature"
                        let plus = UIImage.init(named: "add-4")
                        let minus = UIImage.init(named: "minusBtn")
                        if catArrayForCollectionIs[indexPath.section].isOpened {
                            headerView.btnPlusMinus.setImage(minus!, for: .normal)
                        }
                        else {
                            headerView.btnPlusMinus.setImage(plus!, for: .normal)
                            DispatchQueue.main.async {
                                let indexPathRow:Int = 1
                                let indexPath = IndexPath(item: indexPathRow, section: 0)
                                self.tableview.reloadRows(at: [indexPath], with: .automatic)
                                
                            }
                        }
                        headerView.lblScore.text = ""
                        return headerView
                    }
                    else {
                        headerView.lblTitle.text = catArrayForCollectionIs[indexPath.section].catName
                        let resultMark  = String(catArrayForCollectionIs[indexPath.section].catResultMark ?? 0)
                        let maxMark  = String(catArrayForCollectionIs[indexPath.section].catMaxMark ?? 0)
                        let score = resultMark + "/" + maxMark
                        let plus = UIImage.init(named: "add-4")
                        let minus = UIImage.init(named: "minusBtn")
                        if catArrayForCollectionIs[indexPath.section].isOpened {
                            headerView.btnPlusMinus.setImage(minus!, for: .normal)
                        }
                        else {
                            headerView.btnPlusMinus.setImage(plus!, for: .normal)
                        }
                        headerView.lblScore.text = score
                        if(catArrayForCollectionIs[indexPath.section].sequenceNoo == 11){
                            headerView.lblScore.text = "NA"
                        }
                        
                        return headerView
                        
                    }
                }
                else {
                    headerView.lblTitle.text = catArrayForCollectionIs[indexPath.section].catName
                    let resultMark  = String(catArrayForCollectionIs[indexPath.section].catResultMark ?? 0)
                    let maxMark  = String(catArrayForCollectionIs[indexPath.section].catMaxMark ?? 0)
                    let score = resultMark + "/" + maxMark
                    let plus = UIImage.init(named: "add-4")
                    let minus = UIImage.init(named: "minusBtn")
                    if catArrayForCollectionIs[indexPath.section].isOpened {
                        headerView.btnPlusMinus.setImage(minus!, for: .normal)
                    }
                    else {
                        headerView.btnPlusMinus.setImage(plus!, for: .normal)
                    }
                    headerView.lblScore.text = score
                    return headerView
                    
                    
                    
                }
            }
        }
        else {
            
            let catID = catArrayForCollectionIs[indexPath.section].catID
            for cat in peNewAssessmentArray {
                if  catID == cat.catID{
                    peNewAssessmentArrayForCatQuest.append(cat)
                }
            }
            
            if golbalEvaluationID != 2 {
                if indexPath.section == 0 {
                    
                    if   let cell = tableView.dequeueReusableCell(withIdentifier: "signatureTableViewCell") as? SignatureTableViewCell {
                        cell.certificateData = certificateData
                        cell.fromScreen = "PEFinishPopUpScreen"
                        cell.prevController = self.prevController
                        cell.empIndex = 0
                        cell.index = 0
                        
                       // cell.shipToLbl.isHidden = true //3839
                        cell.shippindAddressBtn.isHidden = true
                        if regionID != 3
                        {
                            cell.signView.clearCanvas()
                            var fullName = ""
                            let firstname = certificateData[0].name
                            fullName = firstname ?? ""
                            cell.operatorSignLbl.text = "Vaccine Mixer Signature" //"Vaccine Mixer Signature*" //"Vaccine Mixer Signature*" we did this change in 7.6.5 release 19 june as per QA suggestion
                            cell.operatorSignLbl.text = cell.operatorSignLbl.text  ?? "" + "*"
                            cell.deviceOperatorNamebl.text  = "Vaccine Mixer Name: \(fullName)"
                            if ("\(fullName)" == certificateData[0].name) {
                                
                                cell.previousBtn.isHidden = true
                                cell.nextBtn.isHidden = false
                                cell.nextBtn.isUserInteractionEnabled = true
                                
                            }
                            if !(certificateData[0].isCertExpired)!  && (prevController == "Rejected"){
                                cell.hideShowImgVw(false)
                                cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:certificateData[0].signatureImg)
                            }
                            else if !(certificateData[0].isCertExpired)!  && (prevController == "Draft"){
                                cell.showImgVw(true)
                                cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:certificateData[0].signatureImg)
                            }
                            else
                            {
                                cell.showImgVw(true)
                                cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:certificateData[0].signatureImg)
                                
                            }
                        }
                        else
                        {
                            cell.signView.clearCanvas()
                            if indexPath.row == 1 {
                                var fullName = ""
                                //         if indexPath.row == 1 {
                                let firstname = certificateData[0].name
                                fullName = firstname ?? ""
                                cell.operatorSignLbl.text = "Vaccine Mixer Signature" //"Vaccine Mixer Signature*" we did this change in 7.6.5 release 19 june as per QA suggestion
                                cell.operatorSignLbl.text = cell.operatorSignLbl.text  ?? "" + "*"
                                cell.deviceOperatorNamebl.text  = "Vaccine Mixer Name: \(fullName)"
                                
                                if ("\(fullName)" == certificateData[0].name) {
                                    
                                    cell.previousBtn.isHidden = true
                                    cell.nextBtn.isHidden = false
                                    cell.nextBtn.isUserInteractionEnabled = true
                                    
                                }
                                
                                if !(certificateData[0].isCertExpired)!  && (prevController == "Rejected"){
                                    cell.hideShowImgVw(false)
                                    cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:certificateData[0].signatureImg)
                                }
                                else if !(certificateData[0].isCertExpired)!  && (prevController == "Draft"){
                                    cell.showImgVw(true)
                                    cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:certificateData[0].signatureImg)
                                }
                                else
                                {
                                    cell.showImgVw(true)
                                    cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:certificateData[0].signatureImg)
                                    
                                }
                                
                                //        }
                            }
                        }
                        
                        cell.blockSignature = { [unowned self] (data) in
                            certificateData = data
                            var i = 0
                            for item in certificateData {
                                if  item.signatureImg.isEmpty {
                                    print("your signature is empty \(i)")
                                }
                                else {
                                    print("your signature is having \(i)")
                                }
                                i = i + 1
                            }
                        }
                        
                        
                        return cell
                    }
                    
                }
                else {
                    if   let cell = tableView.dequeueReusableCell(withIdentifier: PE_FinalizeCell.identifier) as? PE_FinalizeCell {
                        
                        if peNewAssessmentArrayForCatQuest.count > indexPath.row {
                            cell.lblQuestion.text = peNewAssessmentArrayForCatQuest[indexPath.row].assDetail1
                            var resultMark = ""
                            var maxMark = ""
                            if peNewAssessmentArrayForCatQuest[indexPath.row].assStatus == 1 {
                                resultMark  = String(peNewAssessmentArrayForCatQuest[indexPath.row].assMaxScore ?? 0)
                                maxMark  = String(peNewAssessmentArrayForCatQuest[indexPath.row].assMaxScore ?? 0)
                            } else {
                                resultMark  = String(peNewAssessmentArrayForCatQuest[indexPath.row].assMinScore ?? 0)
                                maxMark  = String(peNewAssessmentArrayForCatQuest[indexPath.row].assMaxScore ?? 0)
                            }
                            var score = resultMark + "/" + maxMark
                            if(peNewAssessmentArrayForCatQuest[indexPath.row].sequenceNoo == 11){
                                score = "NA"
                            }
                            
                            cell.lblResult.text = score
                        }
                        return cell
                        
                        
                    }
                    
                }
            }
            else {
                if   let cell = tableView.dequeueReusableCell(withIdentifier: PE_FinalizeCell.identifier) as? PE_FinalizeCell {
                    
                    if peNewAssessmentArrayForCatQuest.count > indexPath.row {
                        cell.lblQuestion.text = peNewAssessmentArrayForCatQuest[indexPath.row].assDetail1
                        var resultMark = ""
                        var maxMark = ""
                        if peNewAssessmentArrayForCatQuest[indexPath.row].assStatus == 1 {
                            resultMark  = String(peNewAssessmentArrayForCatQuest[indexPath.row].assMaxScore ?? 0)
                            maxMark  = String(peNewAssessmentArrayForCatQuest[indexPath.row].assMaxScore ?? 0)
                        } else {
                            resultMark  = String(peNewAssessmentArrayForCatQuest[indexPath.row].assMinScore ?? 0)
                            maxMark  = String(peNewAssessmentArrayForCatQuest[indexPath.row].assMaxScore ?? 0)
                        }
                        
                        var score = resultMark + "/" + maxMark
                        
                        
                        cell.lblResult.text = score
                    }
                    return cell
                    
                    
                }
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toSet = !catArrayForCollectionIs[indexPath.section].isOpened
        catArrayForCollectionIs.forEach {
            $0.isOpened = false
        }
        tableView.isScrollEnabled = true
        peNewAssessmentArrayForCatQuest.removeAll()
        var first = peNewAssessmentArrayForCatQuest1[0]
        peNewAssessmentArrayForCatQuest1.removeAll()
        peNewAssessmentArrayForCatQuest1.append(first)
        catArrayForCollectionIs[indexPath.section].isOpened = toSet
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == catArrayForCollectionIs.count-1{
            
            let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
            
            if regionID != 3 {
                if showExtendedPE{
                    let footerView = UIView(frame: CGRect(x: 20, y: 10, width: tableView.frame.size.width, height: 40))
                    //                footerView.backgroundColor = UIColor.yellow
                    let labelFooter = UILabel(frame: footerView.frame)
                    labelFooter.text = ""
                    //                labelFooter.textColor = .red
                    footerView.addSubview(labelFooter)
                    return footerView
                }
                else{
                    return UIView()
                }
                
            }
            else{
                
                if showExtendedPE{
                    let footerView = UIView(frame: CGRect(x: 20, y: 10, width: tableView.frame.size.width, height: 40))
                    //                footerView.backgroundColor = UIColor.yellow
                    let labelFooter = UILabel(frame: footerView.frame)
                    labelFooter.text = "The extended microbial plate samples have been collected and results will be provided within 48 hours"
                    //                labelFooter.textColor = .red
                    footerView.addSubview(labelFooter)
                    return footerView
                }
                else{
                    return UIView()
                }
                
            }
            
        }
        else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == catArrayForCollectionIs.count-1{
            return 60
        }else{
            return 0
        }
    }
    
}
// MARK: - EXTENSION FOR SIGNATURE DELEGATE

extension PEFinishPopupViewController: YPSignatureDelegate {
    
    func didStart(_ view: YPDrawSignatureView) {
        
    }
    
    func didFinish(_ view: YPDrawSignatureView) {
        if view.tag == 16 {
            signatureView = view
        } else {
            signatureView2 = view
        }
    }
    func calculateResult(){
        var totalresultMark = 0
        var totalmaxMark = 0
        for arr in catArrayForCollectionIs{
            let resultMark  = arr.catResultMark ?? 0
            let maxMark  = arr.catMaxMark ?? 0
            totalresultMark = totalresultMark + resultMark
            totalmaxMark = totalmaxMark + maxMark
        }
        let score = String(totalresultMark) + "/" + String(totalmaxMark)
        totalResultLbl.text = score
    }
    
    func showExtendedMicroAlert(errorMsg: String, param: [String:String]){
        let alertController = UIAlertController(title: "Alert", message: errorMsg, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.validationSuccessFull?(param)
            self.dismiss(animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
            
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    func validate(){
        
        if let signatureImage = self.signatureView.getSignature(scale: 10) {
            DispatchQueue.main.async {
                if self.hatheryManagerName == "" {
                    self.hatcheryManagerNameView.layer.borderColor = UIColor.red.cgColor
                    self.hatcheryManagerNameView.layer.borderWidth = 2.0
                    self.showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
                    return
                }
                if self.txtEmployeeID.text == "" {
                    self.employeeIDView.layer.borderColor = UIColor.red.cgColor
                    self.employeeIDView.layer.borderWidth = 2.0
                    self.showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
                    return
                }
                let imageData = signatureImage.jpegData(compressionQuality: 0.1)
                var imageCountID = 0
                let imageCount = self.getImageCountInPEModule()
                if imageData != nil {
                    CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount+1, imageData: imageData!)
                }
                imageCountID = imageCount+1
                var param : [String:String] = ["sig":String(imageCountID),"sig_EmpID":self.txtEmployeeID.text ?? "","sig_EmpID2":self.txtEmployeeID2.text ?? "","sig_Name":self.hatheryManagerName ?? "","sig_Name2":self.hatheryManagerName2 ?? "","sig_Phone":self.txtPhone.text ?? "","sig_Date":Date().stringFormat(format: "MMM d, yyyy") ]
                let signatureImage2 = self.signatureView2.getSignature(scale: 10)
                
                let imageData2 = signatureImage2?.jpegData(compressionQuality: 0.1)
                if imageData2 != nil {
                    var imageCountID2 = 0
                    let imageCount2 = self.getImageCountInPEModule()
                    CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount2+1, imageData: imageData2!)
                    imageCountID2 = imageCount2+1
                    param  = ["sig":String(imageCountID),"sig2":String(imageCountID2),"sig_EmpID":self.txtEmployeeID.text ?? "","sig_EmpID2":self.txtEmployeeID2.text ?? "","sig_Name":self.hatheryManagerName ?? "","sig_Name2":self.hatheryManagerName2 ?? "","sig_Phone":self.txtPhone.text ?? "","sig_Date":Date().stringFormat(format: "MMM d, yyyy") ]
                }
                print("params are",param)

                
                if self.regionID == 3 {
                    if let microAvailable =  UserDefaults.standard.value(forKey: "extendedAvailable") as? Bool
                    {
                        if microAvailable == true
                        {
                            if let extendedValue = UserDefaults.standard.value(forKey: "ExtendedMicro") as? Bool
                            {
                                if extendedValue == true {
                                    self.showExtendedMicroAlert(errorMsg: "Your PE & Extended Microbial Assessment has been submitted successfully", param: param)
                                }
                                else {
                                    if self.regionID == 3
                                    {
                                        self.showExtendedMicroAlert(errorMsg: "Are you sure, you want to submit the assessment without Extended Microbial?", param: param)
                                    }
                                    
                                }
                            }
                        }
                        else
                        {
                            self.validationSuccessFull?(param)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        self.validationSuccessFull?(param)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                else {
                    self.validationSuccessFull?(param)
                    self.dismiss(animated: true, completion: nil)
                }
                
                  
            }
                
        } else {
            if hatheryManagerName == "" {
                hatcheryManagerNameView.layer.borderColor = UIColor.red.cgColor
                hatcheryManagerNameView.layer.borderWidth = 2.0
            }
            if self.txtEmployeeID.text == "" {
                self.employeeIDView.layer.borderColor = UIColor.red.cgColor
                self.employeeIDView.layer.borderWidth = 2.0
            }
            signatureView.layer.borderColor = UIColor.red.cgColor
            signatureView.layer.borderWidth = 2.0
            showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
            return
        }
    }

    private func saveImageInPEModule(imageData:Data)->Int{
        let allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_ImageEntity")
        let imageCount = getImageCountInPEModule()
        CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount+1, imageData: imageData)
        return imageCount+1
    }
    
    func getImageCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_ImageEntity")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "imageId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    
    
    func getAssessmentInOfflineFromDb() -> Int {
        var allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDFor(entityName: "PE_AssessmentInOffline")
        var carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "dataToSubmitNumber") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    
    func finishSession()  {
        cleanSession()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
    }
    
    private func cleanSession(){
        var peNewAssessmentSurrentIs =  CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
        if isFromDraft{
            peNewAssessmentSurrentIs =  CoreDataHandlerPE().getSavedDraftOnGoingAssessmentPEObject()
        }
        let peNewAssessmentNew = PENewAssessment()
        peNewAssessmentNew.siteId = peNewAssessmentSurrentIs.siteId
        peNewAssessmentNew.customerId = peNewAssessmentSurrentIs.customerId
        peNewAssessmentNew.complexId = peNewAssessmentSurrentIs.complexId
        peNewAssessmentNew.siteName = peNewAssessmentSurrentIs.siteName
        peNewAssessmentNew.userID = peNewAssessmentSurrentIs.userID
        peNewAssessmentNew.customerName = peNewAssessmentSurrentIs.customerName
        peNewAssessmentNew.firstname = peNewAssessmentSurrentIs.firstname
        peNewAssessmentNew.username = peNewAssessmentSurrentIs.username
        peNewAssessmentNew.evaluatorName = peNewAssessmentSurrentIs.evaluatorName
        peNewAssessmentNew.evaluationDate = peNewAssessmentSurrentIs.evaluationDate
        if isFromDraft {
            CoreDataHandler().deleteAllData("PE_AssessmentIDraftInProgress")
            CoreDataHandler().deleteAllData("PE_Refrigator")
            CoreDataHandlerPE().updateDraftAssessmentInProgressInDB(newAssessment:peNewAssessmentNew)
            
        } else {
            CoreDataHandler().deleteAllData("PE_Refrigator")
            CoreDataHandler().deleteAllData("PE_AssessmentInProgress",predicate: NSPredicate(format: "userID == %d AND serverAssessmentId = %@", peNewAssessmentNew.userID ?? 0, peNewAssessmentNew.serverAssessmentId ?? ""))
            
            CoreDataHandlerPE().updateAssessmentInProgressInDB(newAssessment:peNewAssessmentNew, serverAssessmentId: peNewAssessmentNew.serverAssessmentId ?? "")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
}

// MARK: - EXTENSION FOR TEXTFIELD DELEGATES

extension PEFinishPopupViewController: UITextFieldDelegate ,  UITextViewDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtManagerName{
            setUI(viewNew: hatcheryManagerNameView)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1{
            hatheryManagerName = textField.text ?? ""
        }
        if textField.tag == 6{
            hatheryManagerName2 = textField.text ?? ""
        }
        if textField.tag == 2{
            employeeID = textField.text ?? ""
        }
        if textField.tag == 7{
            employeeID2 = textField.text ?? ""
        }
        if textField.tag == 3{
            phone = textField.text ?? ""
        }
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      //  guard let text = textField.text else { return true }
        //  let newLength = text.count + string.count - range.length
       // return text.count <= 25
        return string.isEmpty || (textField.text?.count ?? 0) < 25
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 3{
            phone = textView.text ?? ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == txtPhone{
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            return numberOfChars < 501 // 10 Limit Value
        }
        
        return true
        
    }
    
}

// MARK: - EXTENSION FOR DATE

extension Date {
    func stringFormat(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
//        formatter.calendar = Calendar(identifier: .gregorian)
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
}


