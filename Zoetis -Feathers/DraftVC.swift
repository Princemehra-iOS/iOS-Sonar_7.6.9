//
//  DraftVCViewController.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 07/01/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class DraftVC : BaseViewController {
    
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var draftTableView: UITableView!
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        self.onSlideMenuButtonPressed(self.buttonMenu)
    }
}

extension DraftVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DraftInfoCell", for: indexPath) as! DraftInfoCell
        cell.requisitionNumberTxt.text = "1235478"
        cell.requisitionDateTxt.text = "12/12/2020"
        cell.surveyType.text = "######"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
}
