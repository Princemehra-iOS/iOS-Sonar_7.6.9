//
//  Constants.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 01/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
class VaccinationConstants{
    
    struct PEConstants{
        public static let WARNING_MSG_NEXTBTN_CLICK_SCHEDULED_DATE = "You won't be able to change Scheduled date. Are you sure, do you want to continue? Click cancel to make changes."
        public static let WARNING_MSG_NEXTBTN_CLICK_EXTENDED_MICROBIAL = "You won't be able to change Extended Microbial. Are you sure, do you want to continue? Click cancel to make changes."
        public static let WARNING_MSG_NEXTBTN_CLICK_BOTH_DATE_MICROBIAL = "You won't be able to make changes in Scheduled Date and Extended Microbial. Are you sure, do you want to continue? Click cancel to make changes."
      //  public static let ROLE_FSR_VAL = "FSR"
    }
    
    struct Roles{
        public static let ROLE_FSR_ID = "28"
        public static let ROLE_FSR_VAL = "FSR"
        
        public static let ROLE_FSM_ID = "38"
        public static let ROLE_FSM_VAL = "FSM"
        
        public static let ROLE_TSR_ID = "27"
        public static let ROLE_TSR_VAL = "TSR"
    }
    
    struct LookupMaster{
        
        // Orignally
        public static let ANNUAL_CERTIFICATION_TYPE_ID = "1"
        public static let RE_CERTIFICATION_TYPE_ID = "2"
        
        public static let OPERATOR_CERTIFICATION_TYPE_ID = "2"
        public static let SAFETY_CERTIFICATION_TYPE_ID = "1"
        
        public static let SAFETY_CERTIFICATION_CATEGORY_ID = "1"
        public static let SAFETY_CERTIFICATION_CATEGORY_VALUE = "Safety"
        
        public static let OPERATOR_CERTIFICATION_QUESTION_TYPE_ID = "9"
        public static let SAFETY_CERTIFICATION_QUESTION_TYPE_ID = "11"
        public static let SAFETY_AWARENESS_QUESTION_TYPE_ID = "10"
        public static let VACCINE_MIXING_TYPE_ID = "12"
        
    }
    
    struct VaccinationStatus{
        public static let COREDATA_SAVED_SUCCESSFULLY = "Saved Successfuly in Core Data"
        public static let COREDATA_FETCHED_SUCCESSFULLY = "Fetched from Core Data"
        public static let COREDATA_SAVE_FAILED = "Save operation Failed in Core Data"
    }
    
    
}
