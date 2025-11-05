//
//  PVEDraftViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/03/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

class PVEDraftViewController: BaseViewController {
    let sharedManager = PVEShared.sharedInstance
    @IBOutlet weak var headerView: UIView!
    
    var peHeaderViewController:PEHeaderViewController!
    @IBOutlet weak var lblCustomer: PEFormLabel!
    @IBOutlet weak var lblSite: PEFormLabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Draft"
        //
        tableview.register(PVE_DraftCell.nib, forCellReuseIdentifier: PVE_DraftCell.identifier)
        headerView.addSubview(peHeaderViewController.view)
        //
        topviewConstraint(vwTop: peHeaderViewController.view)
        let nibCatchers = UINib(nibName: "PVEDraftHeader", bundle: nil)
        tableview.register(nibCatchers, forHeaderFooterViewReuseIdentifier: "PVEDraftHeader")
        //
        tableview.tableFooterView = UIView()
        tableview.reloadData()
        
        lblCustomer.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customer") as? String
        lblSite.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "complexName") as? String
        
        
    }
    
    func getSubmitToSyncArrFromDb() -> NSArray {
        var getDataToSyncInDBArr = NSArray()
        
        let arrPVE_Sync = CoreDataHandlerPVE().fetchDetailsForTypeOfData(type: "draft")
        
        if arrPVE_Sync.count > 0{
            getDataToSyncInDBArr = CoreDataHandlerPVE().getDataToSyncInDB(type: "draft")
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            let sortedArray = getDataToSyncInDBArr.sorted {
                dateFormatter.date(from: (($0 as AnyObject).value(forKey: "evaluationDate") as? String)!)! < dateFormatter.date(from: (($1 as AnyObject).value(forKey: "evaluationDate") as? String)!)! }
            getDataToSyncInDBArr = sortedArray as NSArray
            tableview.isHidden = false
        }else{
            tableview.isHidden = true
        }
        return getDataToSyncInDBArr
    }
}

extension PVEDraftViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSubmitToSyncArrFromDb().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PVE_DraftCell.identifier) as? PVE_DraftCell{
            cell.delegate = self
            cell.currentIndPath = indexPath as NSIndexPath
            let dict = getSubmitToSyncArrFromDb()[indexPath.row]
            cell.config(dict: dict  as! NSObject)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    private func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showtoast(message: "In Dev")
    }
    
    //MARKS: DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PVEDraftHeader" ) as! PVEDraftHeader
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 77.0
    }
    
}

extension PVEDraftViewController: DraftSNADelegate{
    func editClicked(clickedBtnIndPath: NSIndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.pveStoryboard, bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVEDraftSNAssessment") as! PVEDraftSNAssessment
        let dict = getSubmitToSyncArrFromDb()[clickedBtnIndPath.row]
        let cuurentDict = dict as! NSObject
        let currentTimeStamp = cuurentDict.value(forKey: "syncId") as? String
        vc.currentTimeStamp =  currentTimeStamp ?? ""
        //   print("editClicked currentTimeStamp------***\(cuurentDict)")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteClicked(clickedBtnIndPath: NSIndexPath) {
        
        let errorMSg =  "Are you sure you want to delete the assessment in draft?"
        let alertController = UIAlertController(title: "Delete Assessment", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            let dict = self.getSubmitToSyncArrFromDb()[clickedBtnIndPath.row]
            let cuurentDict = dict as! NSObject
            let currentTimeStamp = cuurentDict.value(forKey: "syncId") as? String
            NSLog("OK Pressed--\(currentTimeStamp!)")
            CoreDataHandlerPVE().deleteDraftForSyncId(currentTimeStamp!)
            self.tableview.reloadData()
            //self.deleteDraft()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
