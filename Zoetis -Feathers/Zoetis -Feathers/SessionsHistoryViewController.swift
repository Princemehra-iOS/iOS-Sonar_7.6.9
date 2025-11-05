//
//  SessionsHistoryViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 22/08/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class SessionsHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var filteredCandies = [AnyObject]()
    var postingId = Int()
    var objectArray = NSMutableArray()
    var feedProgramArray = NSMutableArray()
    var addVacArray = NSMutableArray()

    @IBAction func back_bttn(_ sender: AnyObject) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {

        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String

        self.navigationController?.isNavigationBarHidden = true

        postingId = UserDefaults.standard.integer(forKey: "postingId")
        self.objectArray = NSMutableArray()
        self.feedProgramArray = NSMutableArray()
        self.addVacArray = NSMutableArray()

        for i in 0..<postingId {
            self.objectArray =  CoreDataHandler().fetchAllPostingSession((i + 1) as NSNumber).mutableCopy() as! NSMutableArray

            self.feedProgramArray =   CoreDataHandler().FetchFeedProgram((i + 1) as NSNumber).mutableCopy() as! NSMutableArray
            self.addVacArray =   CoreDataHandler().fetchAddvacinationData((i  + 1) as NSNumber).mutableCopy() as! NSMutableArray
        }
        self.tableView.reloadData()
    }

    @IBAction func sliderBttn(_ sender: AnyObject) {

        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return objectArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SessionHistoryTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Session") as! SessionHistoryTableViewCell

        let vet: PostingSession = objectArray.object(at: indexPath.row) as! PostingSession
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.sessionDateLabel!.text = vet.sessiondate
        cell.sessionLabel!.text = vet.customerName
        cell.sessionType!.text = vet.sessionTypeName
        cell.typeComplexLabel!.text = vet.complexName

        if indexPath.row < addVacArray.count {
            let vaccination: HatcheryVac = addVacArray.object(at: indexPath.row) as! HatcheryVac
            cell.vetLabel!.text = vaccination.vaciNationProgram
        }

        if indexPath.row < feedProgramArray.count {

            let feed: FeedProgram = feedProgramArray.object(at: indexPath.row) as! FeedProgram

            cell.feedProgram!.text = feed.feddProgramNam
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //print("You selected cell #\(indexPath.row)!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
