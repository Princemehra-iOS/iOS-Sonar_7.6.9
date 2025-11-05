//
//  FrezerFooterViewCell.swift
//  Zoetis -Feathers
//
//  Created by ankur sangwan on 10/01/23.
//

import UIKit

class FrezerFooterViewCell: UITableViewHeaderFooterView ,UITextViewDelegate{

    @IBOutlet weak var textFieldView: UITextView!
    var noteCompletion:((_ textLabel: String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textFieldView.delegate = self
    }

    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    func setGraddientAndLayerQcCountextFieldView() {
        DispatchQueue.main.async {
            self.textFieldView.backgroundColor = UIColor.white
            self.textFieldView.layer.cornerRadius = 10
            self.textFieldView.layer.masksToBounds = true
            self.textFieldView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.textFieldView.layer.borderWidth = 2.0
            self.textFieldView.textContainer.lineFragmentPadding = 12
         }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        noteCompletion?(textView.text)
      
    }
}
