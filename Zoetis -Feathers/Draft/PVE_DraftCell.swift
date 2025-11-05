//
//  PVE_DraftCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/03/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

protocol DraftSNADelegate: AnyObject {
    func editClicked(clickedBtnIndPath: NSIndexPath)
    func deleteClicked(clickedBtnIndPath: NSIndexPath)
}

class PVE_DraftCell: UITableViewCell {

    weak var delegate: DraftSNADelegate?
    let sharedManager = PVEShared.sharedInstance
    var currentIndPath = NSIndexPath()

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
     
    
    @IBAction func editClicked(_ sender: Any) {

        delegate?.editClicked(clickedBtnIndPath: currentIndPath)


    }
    
    @IBAction func delClicked(_ sender: Any) {
        delegate?.deleteClicked(clickedBtnIndPath: currentIndPath)
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
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
}
