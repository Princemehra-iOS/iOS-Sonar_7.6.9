//
//  RefrigatorQuesCell.swift
//  Zoetis -Feathers
//
//  Created by ankur sangwan on 03/01/23.
//

import UIKit

class RefrigatorQuesCell: UITableViewCell {

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btn_Switch: UISwitch!
    
   
    @IBOutlet weak var btn_Camera: UIButton!
    @IBOutlet weak var btn_Info: UIButton!
    
    @IBOutlet weak var btn_Comment: UIButton!
    @IBOutlet weak var btn_ImageCount: UIButton!
    @IBOutlet weak var btn_NA: UIButton!
    var completion:((_ status: Bool?, _ error: String?) -> Void)?
    var cameraCompletion:((_ error: String?) -> Void)?
    var commentCompletion:((_ error: String?) -> Void)?
    var imagesCompletion:((_ error: String?) -> Void)?
    var infoCompletion:((_ error: String?) -> Void)?
    var btnNA:(()-> Void)?
    var openCamera:(()-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class var identifier: String {
        return String(describing: self)
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    @IBAction func na_BtnClicked(_ sender: Any) {
       btnNA?()
      }
    
    @IBAction func action_Camera(_ sender: Any) {
        cameraCompletion?(nil)
    }
    
    @IBAction func action_Switch(_ sender: UISwitch) {
 
        if sender.isOn{
            completion?(true,nil)
        } else{
            completion?(false,nil)
        }
    }
    
    @IBAction func action_Comment(_ sender: Any) {
        commentCompletion?(nil)
    }
    
    @IBAction func action_Info(_ sender: Any) {
        infoCompletion?(nil)
    }
    
    func switchClicked(status: Bool) {
        appDelegateObj.testFuntion()
    }
    
    
    @IBAction func imagesCountClicked(_ sender: Any) {
    imagesCompletion?(nil)
    }
    
    @IBAction func buttonTap(_ sender: Any) {
        print(appDelegateObj.testFuntion())
    }
    
}
