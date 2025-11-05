//
//  PVEShared.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 02/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

public class PVEShared: NSObject {
    
    public static let sharedInstance = PVEShared()
    // --------------PVE Property Declaration-----
    public var sharedCustomerPVE: [CustomerPVE]?
    public var sharedCustomerNameArrPVE: [String]?
    
    public var sharedComplexResPVE: [PVEGetComplexRes]?
    public var sharedComplexResArrPVE: [String]?
    //public var sharedselectedComplexPVE: PVEGetComplexRes?
    
    
    public var sharedEvaluationTypeResPVE: [PVEEvaluationTypeRes]?
    public var sharedEvaluationTypeResArrPVE: [String]?
    public var selectedEvaluationTypePVE: String?
    public var sharedselectedEvaluationTypePVE: PVEEvaluationTypeRes?
    
    public var sharedEvaluationForResPVE: [PVEEvaluationForRes]?
    public var sharedEvaluationForResArrPVE: [String]?
    public var selectedEvaluationForPVE: String?
    public var sharedselectedEvaluationForPVE: PVEEvaluationForRes?
    
    public var sharedSiteIdNameResPVE: [PVESiteIdNameRes]?
    public var sharedSiteIdNameResArrPVE: [String]?
    public var selectedSiteIdNamePVE: String?
    public var sharedselectedSiteIdNamePVE: PVESiteIdNameRes?
    
    public var sharedAgeOfBirdsResPVE: [PVEAgeOfBirdsRes]?
    public var sharedAgeOfBirdsResArrPVE: [String]?
    public var selectedAgeOfBirdsPVE: String?
    public var sharedselectedAgeOfBirdsPVE: PVEAgeOfBirdsRes?
    
    public var sharedBreedOfBirdsResPVE: [PVEBreedOfBirdsRes]?
    public var sharedBreedOfBirdsResArrPVE: [String]?
    public var selectedBreedOfBirdsPVE: String?
    public var sharedselectedBreedOfBirdsPVE: PVEBreedOfBirdsRes?
    
    public var sharedHousingDetailsResPVE: [PVEGetHousingDetailsRes]?
    public var sharedHousingDetailsResArrPVE: [String]?
    public var selectedHousingDetailsPVE: String?
    public var sharedselectedHousingDetailsPVE: PVEGetHousingDetailsRes?
    
    public var sharedAssignUserDetailsResPVE: [PVEGetAssignUserDetailsRes]?
    public var sharedAssignUserDetailsResArrPVE: [String]?
    public var selectedAssignUserDetailsPVE: String?
    public var sharedselectedAssignUserDetailsPVE: PVEGetAssignUserDetailsRes?
    
    public var sharedEvaluatorDetailsResPVE: [PVEGetEvaluatorDetailsRes]?
    public var sharedEvaluatorDetailsResArrPVE: [String]?
    public var selectedEvaluatorDetailsResPVE: String?
    public var sharedselectedEvaluatorDetailsResPVE: PVEGetEvaluatorDetailsRes?
    
    public var sharedAssCategoriesDetailsResPVE: [PVEAssessmentCategoriesDetailsRes]?
    public var sharedAssCategoriesDetailsResArrPVE: [String]?
    public var selectedAssCategoriesDetailsResPVE: String?
    public var sharedselectedAssCategoriesDetailsPVE: PVEAssessmentCategoriesDetailsRes?
    
    
    public var sharedSerotypeDetailsResPVE: [PVESerotypeDetailsRes]?
    public var sharedSerotypeDetailsResArrPVE: [String]?
    public var selectedSerotypeDetailsResPVE: String?
    public var sharedselectedSerotypeDetailsResPVE: PVESerotypeDetailsRes?
    
    
    public var totalScore = Int()
    public var serveyNoStr = String()
    
    public var assessmentQuestionDataArr = [[String:Any]]()
    
    public var loggedoutUserId = Int()
    
    public var centerLTxtFieldValue = Int()
    public var wingLTxtFieldValue = Int()
    public var musculLTxtFieldValue = Int()
    public var missedLTxtFieldValue = Int()
    public var leftTotalLblValue = Int()
    
    public var centerRTxtFieldValue = Int()
    public var wingRTxtFieldValue = Int()
    public var musculRTxtFieldValue = Int()
    public var missedRTxtFieldValue = Int()
    public var rightTotalLblValue = Int()
    
    public var musculHitInstraLblValue = Int()
    public var missedInstraLblValue = Int()
    public var musculHitSubcutanousLblValue = Int()
    public var missedSubcutanousLblValue = Int()
    
    public var vaccineEvaluationScoreTotal = Double()
    
    func getCustomerAndSitePopupValueFromDB(key:String) -> Any {
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
    
    func getSessionValueForKeyFromDB(key:String) -> Any {
        let dataArr = CoreDataHandlerPVE().fetchCurrentSessionInDB()
        let arr = dataArr.value(forKey: key) as! NSArray
        return arr[0]
    }
    
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyyyyhhmmss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    func setBorderRedForMandatoryFiels(forBtn:UIButton) {
        
        let superviewCurrent =  forBtn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of:UIButton.self) {
                view.layer.borderColor = UIColor.red.cgColor
                view.layer.borderWidth = 2.0
            }
        }
    }
    
    func setBorderBlue(btn:UIButton) {
        let superviewCurrent =  btn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of:UIButton.self),view == btn {
                view.setDropdownStartAsessmentView(imageName:"dd")
            }
        }
    }
}
