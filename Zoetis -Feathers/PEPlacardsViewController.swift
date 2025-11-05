//
//  PEDraftViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 28/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

import PDFKit

class PEPlacardsViewController: BaseViewController {
    
    var peHeaderViewController:PEHeaderViewController!
    var peAssessmentDraftArray : [PENewAssessment] = []
    
    var pdfArray : [String] =
    ["PLACARD1_5.2.pdf",
     "PLACARD2_6.1.pdf",
     "PLACARD3_5.1.pdf",
     "PLACARD4_6.1.pdf",
     "PLACARD5_5.1.pdf",
     "PLACARD6_5.1.pdf",
     "PLACARD9_4.1.pdf",
     "PLACARD12_5.1.pdf",
     "PLACARD30_2.1.pdf",
     "PLACARD31_1.1.pdf",
     "PLACARD33_1.1.pdf",
     "PLACARD34_1.1.pdf"]
    
    var pdfTextArray : [String] =
    ["DAILY, WEEKLY, MONTHLY CLEANING PROCEDURES",
     "HATCHERY CHECKLIST FOR EMBREX® INOVOJECT® BIODEVICES INSTALLATION AND USE",
     "INSTRUCTIONS FOR HAND-MIXING SANITATION FLUID/SANITIZER",
     "DAILY CLEANING FOR TRANSFER TABLE VACUUM PLATE",
     "MAREK DISEASE VACCINE PREPARATION AND INSTRUCTIONS FOR USE WITH EMBREX® INOVOJECT® BIODEVICES",
     "INOVOTABS® SANITIZER PREPARATION",
     "EMBREX® INOVOJECT® BIODEVICES PROCESS CHECKLIST",
     "EMBREX® INOVOJECT® BIODEVICES STARTUP PROCEDURE",
     "KEY HATCHERY MANAGEMENT CONSIDERATIONS - SANITATION",
     "KEY CONSIDERATIONS TO SUPPORT IN OVO VACCINE STERILITY",
     "DOCUMENT INFORMATION & PRINTING",
     "INSTRUCTIONS","PLACARD34"]
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var customerGradientView: UIView!
    @IBOutlet weak var coustomerView: UIView!
    @IBOutlet weak var lblCustomer: PEFormLabel!
    @IBOutlet weak var lblSite: PEFormLabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var topconstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Placards"
        
        tableview.register(PE_PlacardCell.nib, forCellReuseIdentifier: PE_PlacardCell.identifier)
        headerView.addSubview(peHeaderViewController.view)
        
        topviewConstraint(vwTop: peHeaderViewController.view)
        let nibCatchers = UINib(nibName: "PEPlacardsHeaderCell", bundle: nil)
        tableview.register(nibCatchers, forHeaderFooterViewReuseIdentifier: "PEPlacardsHeaderCell")
        
        tableview.tableFooterView = UIView()
        tableview.reloadData()
    }
    
    
    // MARK: - Get Drafted Assessment's Count
    func getDraftCountFromDb() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDForAny(entityName: "PE_AssessmentInDraft")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "draftNumber") as? NSArray ?? []
        var carColIdArray : [Int] = []
        
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
}

// MARK: - Extension of PE Placards View Controller & TableView Delegates
extension PEPlacardsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PE_PlacardCell.identifier) as? PE_PlacardCell{
            var text = pdfArray[indexPath.row]
            text  = text.replacingOccurrences(of: ".pdf", with: "")
            cell.lblAssessment.text = text
            cell.lblContent.text = pdfTextArray[indexPath.row]
            cell.pdfBtn.backgroundColor = .clear
            cell.pdfBtn.layer.cornerRadius = 17.5
            cell.pdfBtn.layer.borderWidth = 1
            cell.pdfBtn.layer.borderColor = UIColor.lightGray.cgColor
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PdfViewPopUpView") as? PdfViewPopUpView
        vc?.pdfName = pdfArray[indexPath.row]
        if vc != nil{
            self.navigationController?.present(vc!, animated: false, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PEPlacardsHeaderCell" ) as! PEPlacardsHeaderCell
        return headerView        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 77.0
    }
    
    // MARK: - DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
}
