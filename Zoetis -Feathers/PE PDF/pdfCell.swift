//
//  pdfCell.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 14/05/24.
//

import UIKit

class pdfCell: UITableViewCell {

    static let identifier =  "pdfCell"
    class var classIdentifier: String {
        return String(describing: self)
    }
    
    @IBOutlet weak var fileName: UILabel!
    
    @IBOutlet weak var pdfFileBtn: UIButton!
    
    @IBOutlet weak var docxFileBtn: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}
