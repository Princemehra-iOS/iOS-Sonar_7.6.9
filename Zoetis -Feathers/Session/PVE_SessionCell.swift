//
//  PE_FinalizeCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 19/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

protocol SavedSessionDelegate: AnyObject {
    func viewClicked(clickedBtnIndPath: NSIndexPath, syncId:String)
}
class PVE_SessionCell: UITableViewCell {

    weak var delegate: SavedSessionDelegate?
    var currentIndPath = NSIndexPath()
    var syncId = String()
    
    @IBOutlet weak var lblAssessment: UILabel!
    @IBOutlet weak var lblEvaluationDate: UILabel!
    @IBOutlet weak var lblEvaluationType: UILabel!
    @IBOutlet weak var lblEvaluator: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    
    var editCompletion:((_ string: String?) -> Void)?
        var deleteCompletion:((_ string: String?) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
     
     override func layoutSubviews() {
         super.layoutSubviews()
      
     }
     
     class var identifier: String {
         return String(describing: self)
     }
     
     class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func config(dict:NSObject)  {
     
        lblEvaluationDate.text = dict.value(forKey: "evaluationDate") as? String
        lblEvaluationType.text = dict.value(forKey: "evaluationFor") as? String
        lblEvaluator.text = dict.value(forKey: "evaluator") as? String

        lblAssessment.text = "C-\(dict.value(forKey: "syncId") as? String ?? "")"
        syncId = dict.value(forKey: "syncId") as? String ?? ""
    }
   
    @IBAction func viewBtnClicked(_ sender: Any) {
        delegate?.viewClicked(clickedBtnIndPath: currentIndPath, syncId: syncId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
}
