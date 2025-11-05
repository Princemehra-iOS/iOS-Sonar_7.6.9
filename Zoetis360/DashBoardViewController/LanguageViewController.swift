//
//  LanguageViewController.swift
//  Zoetis -Feathers
//
//  Created by kuldeep Singh on 27/10/22.
//

import UIKit

class LanguageViewController: UIViewController {
    
    // MARK: - OUTLET
    @IBOutlet weak var lblLanguageChoose: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIABLES
    var arrayLanugage = ["English" , "French" , "Portuguese" ]
    var selectedIndex : Int?
    var arrayImg = [UIImage.init(named: "start_new_session") , UIImage.init(named: "open_existing_session") ,UIImage.init(named: "training&education") ]
    let messageprefLang = "Choose your Prefered Language"
    // MARK: 🟠 - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let  lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 1 {
            selectedIndex = 0
            lblLanguageChoose.text = NSLocalizedString(messageprefLang, comment: "")
        }
        else if lngId == 3 {
            selectedIndex = 1
            lblLanguageChoose.text = NSLocalizedString(messageprefLang, comment: "")
        }
        
        else {
            selectedIndex = 2
            lblLanguageChoose.text = NSLocalizedString(messageprefLang, comment: "")
        }
    }
    // MARK: 🟠 - IBACTION
    @IBAction func SideMenuButtonPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
}
// MARK: 🟠 - EXTENSION
extension LanguageViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let val = UserDefaults.standard.integer(forKey: "chick")
        if val == 4{
            return 3
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LangTableViewCell") as! LangTableViewCell
        cell.lblName.text = arrayLanugage[indexPath.row]
        if selectedIndex == indexPath.row {
            cell.imgView.image = UIImage.init(named: "checkTickBlue")
        }
        else {
            cell.imgView.image = UIImage.init(named: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        
        if arrayLanugage[indexPath.item] == "English" {
            UserDefaults.standard.set(1, forKey: "lngId")
            LanguageUtility.setAppleLAnguageTo(lang: "en")
            UserDefaults.standard.synchronize()
        }
        else if arrayLanugage[indexPath.item] == "Portuguese" {
            UserDefaults.standard.set(4, forKey: "lngId")
            LanguageUtility.setAppleLAnguageTo(lang: "pt-BR")
            UserDefaults.standard.synchronize()
        }
        else {
            UserDefaults.standard.set(3, forKey: "lngId")
            LanguageUtility.setAppleLAnguageTo(lang: "fr")
            UserDefaults.standard.synchronize()
        }
        
        let val = UserDefaults.standard.integer(forKey: "chick")
        if val  ==  4  {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DashView_Controller") as! DashViewController
            navigationController?.pushViewController(vc, animated: false)
        }
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DashViewControllerTurkey") as! DashViewControllerTurkey
            navigationController?.pushViewController(vc, animated: false)
        }
    }
}

