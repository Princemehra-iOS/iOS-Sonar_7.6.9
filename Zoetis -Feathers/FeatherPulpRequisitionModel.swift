//
//  FeatherPulpRequisitionModel.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 06/03/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation


class FeatherPulpRequisitionModel {
    
      var requestor = ""
      var reasonForVisit = ""
      var sampleCollectedBy = ""
      var company = ""
      var companyId = Int()
      var site = ""
      var siteId = Int()
      var email = ""
      var reviewer = ""
      var surveyConductedOn = ""
      var sampleCollectionDate: String = {
          let formatter = DateFormatter()
          formatter.dateFormat = Constants.MMddyyyyStr
          let dateString = formatter.string(from: Date())
          return dateString
      }()
      var sampleCollectionDateWithTimeStamp = ""
      var timeStamp = ""
      var purposeOfSurvey = ""
      var transferIn = ""
      var barCode = ""
      var barCodeManualEntered = ""
      var notes = ""
    
    
}
