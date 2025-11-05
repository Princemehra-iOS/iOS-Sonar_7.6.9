//
//  ReviewerViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 08/06/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import CoreData
class ReviewerViewController: UIViewController {
    var reviewerDetails : [MicrobialSelectedUnselectedReviewer] = []{
        didSet{
            self.tableViewReviewer.reloadData()
        }
    }
    @IBOutlet weak var tableViewReviewer: UITableView!
    let cellReviewerIdentifier = "ReviewerSelectionTableViewCell"
    var cancelAction: ((Any) -> Void)?
    var doneAction: ((Any) -> Void)?
    var reviewerIdSelected: ((MicrobialSelectedUnselectedReviewer) -> Void)?
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.setTableAttributes()
    }
    
    private func setTableAttributes(){
        self.tableViewReviewer.delegate = self
        self.tableViewReviewer.dataSource = self
        self.tableViewReviewer.register(UINib(nibName: cellReviewerIdentifier, bundle: nil), forCellReuseIdentifier: cellReviewerIdentifier)
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.cancelAction?(sender)
    }
    @IBAction func okBtnAction(_ sender: UIButton) {
        self.doneAction?(sender)
    }
    
}


extension ReviewerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewerDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReviewerIdentifier, for: indexPath) as? ReviewerSelectionTableViewCell
        if reviewerDetails[indexPath.row].isSelected?.boolValue ?? false{
            cell!.checkUncheckReviewerButton.setImage(UIImage(named: "checkedIconReviewer"), for: .normal)
        }else{
            cell!.checkUncheckReviewerButton.setImage(UIImage(named: "uncheckedIconReviewer"), for: .normal)
        }
        cell!.checkUncheckReviewerButton.setTitle( reviewerDetails[indexPath.row].reviewerName ?? "", for: .normal)
        let userId = UserDefaults.standard.value(forKey:"Id") ?? 0
        let isReviewerSelectedAndDisabled = ((userId as! Int) == reviewerDetails[indexPath.row].reviewerId?.intValue ?? 0)
        cell!.checkUncheckReviewerButton.isEnabled = !isReviewerSelectedAndDisabled
        cell!.selectUnselectButton = { sender in
            self.reviewerIdSelected!(self.reviewerDetails[indexPath.row])
        }
//        cell.checkUncheckReviewerButton reviewerName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}
