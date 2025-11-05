//
//  VaccinationHeaderView.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 13/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import UIKit

//@IBDesignable
class VaccinationHeaderView: BaseViewController {
    
    // MARK: - OUTLETS

    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var syncVw: UIView!
    @IBOutlet weak var endSyncVw: UIView!
    @IBOutlet weak var mainVwColor: UIView!
    
    init(){
        super.init(nibName: String(describing: "VaccinationHeaderView"), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - IBACTIONS
    @IBAction func sideMenuAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    
    override func awakeFromNib() {
         mainVwColor.setGradient(topGradientColor: UIColor.getViewHeaderTopGradient(), bottomGradientColor: UIColor.getHeaderLowerGradient())
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
         mainVwColor.setGradient(topGradientColor: UIColor.getViewHeaderTopGradient(), bottomGradientColor: UIColor.getHeaderLowerGradient())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                mainVwColor.setGradient(topGradientColor: UIColor.getViewHeaderTopGradient(), bottomGradientColor: UIColor.getHeaderLowerGradient())
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainVwColor.setGradient(topGradientColor: UIColor.getViewHeaderTopGradient(), bottomGradientColor: UIColor.getHeaderLowerGradient())

    }
    
    func hideSyncButtons(){
        syncVw.isHidden = true
        endSyncVw.isHidden = true
    }
    
}
