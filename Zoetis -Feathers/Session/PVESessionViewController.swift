//
//  PEDraftViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 28/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PVESessionViewController: BaseViewController {
    let sharedManager = PVEShared.sharedInstance
    @IBOutlet weak var headerView: UIView!

    var peHeaderViewController:PEHeaderViewController!
    @IBOutlet weak var lblCustomer: PEFormLabel!
    @IBOutlet weak var lblSite: PEFormLabel!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Completed Assessments"
//
        tableview.register(PVE_SessionCell.nib, forCellReuseIdentifier: PVE_SessionCell.identifier)
        headerView.addSubview(peHeaderViewController.view)
//
        topviewConstraint(vwTop: peHeaderViewController.view)
        let nibCatchers = UINib(nibName: "PVESessionHeader", bundle: nil)
        tableview.register(nibCatchers, forHeaderFooterViewReuseIdentifier: "PVESessionHeader")
//
        tableview.tableFooterView = UIView()
        tableview.reloadData()

        lblCustomer.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customer") as? String
        lblSite.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "complexName") as? String
        
        if getSubmitToSyncArrFromDb().count > 0 {
            tableview.isHidden = false
        }else{
            tableview.isHidden = true
        }
        

    }
    
    
    func getSubmitToSyncArrFromDb() -> NSArray {
        var getDataToSyncInDBArr = NSArray()
        
        let arrPVE_Sync = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Sync")
        if arrPVE_Sync.count > 0{
            getDataToSyncInDBArr = CoreDataHandlerPVE().getDataToSyncInDB(type: "sync")
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            let sortedArray = getDataToSyncInDBArr.sorted {
                dateFormatter.date(from: (($0 as AnyObject).value(forKey: "evaluationDate") as? String)!)! < dateFormatter.date(from: (($1 as AnyObject).value(forKey: "evaluationDate") as? String)!)! }
            getDataToSyncInDBArr = sortedArray as NSArray

            }else{
            }
        return getDataToSyncInDBArr
    }
}


extension PVESessionViewController: UITableViewDelegate, UITableViewDataSource,SavedSessionDelegate{

    
    func viewClicked(clickedBtnIndPath: NSIndexPath, syncId:String) {
        
        let currentTimeStamp = syncId
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.pveStoryboard, bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVEViewSNASession") as! PVEViewSNASession
        vc.currentTimeStamp =  currentTimeStamp
        navigationController?.pushViewController(vc, animated: true)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSubmitToSyncArrFromDb().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 70
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PVE_SessionCell.identifier) as? PVE_SessionCell{
            
            let dict = getSubmitToSyncArrFromDb()[indexPath.row]
            cell.delegate = self
            cell.currentIndPath = indexPath as NSIndexPath
            cell.selectionStyle = .none
            cell.config(dict: dict  as! NSObject)
            return cell
        }
        return UITableViewCell()
    }
    
    private func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      showtoast(message: "Selected..")

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
      
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PVESessionHeader" ) as! PVESessionHeader
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 77.0
    }
   
    
}
