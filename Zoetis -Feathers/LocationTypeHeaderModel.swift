//
//  LocationTypeHeaderModel.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 18/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation

class LocationTypeHeaderModel {
    
    var isPlusButtonPressed = false
    var ischeckBoxSelected = false
    
    var noOfPlates = Int()
    var selectedLocationTypeId: Int?
    var selectedLocationType = "Select location type"
    var numberOfPlateIDCreated = [LocationTypeCellModel]()
    var section = -1
    var requisition_Id = ""
    var requisitionType: Int?
    
    var isHeaderIsCollapsed = false
    var timeStamp = ""
        
    init() {
        print("")
    }
    init(headerObject: Microbial_LocationTypeHeaders) {
        self.section = headerObject.section as? Int ?? -1
        self.noOfPlates =  headerObject.noOfPlates as? Int ?? 0
        self.selectedLocationType = headerObject.locationType ?? ""
        self.selectedLocationTypeId = headerObject.locationTypeId as? Int ?? nil
        let headerSection = headerObject.section as? Int ?? 0
        self.requisition_Id = headerObject.requisition_Id ?? ""
        self.requisitionType = headerObject.requisitionType  as? Int ?? nil
        self.numberOfPlateIDCreated = []
        
        let plates = CoreDataHandlerMicro().fetchEnviromentalLocationTypePlatesInfoFor(section: headerSection, locationTypeId: self.selectedLocationTypeId ?? -100)
        if plates.count > 0 {
            self.isPlusButtonPressed = true
            var totalHeaderPlates = [LocationTypeCellModel]()
            for plate in plates {
                var plateCell = LocationTypeCellModel()
                if let plateObject = plate as? Microbial_LocationTypeHeaderPlates {
                    plateCell = LocationTypeCellModel(plateObject: plateObject)
                }
                totalHeaderPlates.append(plateCell)
            }
            self.numberOfPlateIDCreated = totalHeaderPlates
        }
    }
    
    
    init(headerObject: Microbial_LocationTypeHeadersSubmitted) {
        self.section = headerObject.section as? Int ?? -1
        self.noOfPlates =  headerObject.noOfPlates as? Int ?? 0
        self.selectedLocationType = headerObject.locationType ?? ""
        self.selectedLocationTypeId = headerObject.locationTypeId as? Int ?? nil
        self.requisition_Id = headerObject.requisition_Id ?? ""
        self.requisitionType = headerObject.requisitionType  as? Int ?? nil
        self.timeStamp = headerObject.timeStamp ?? ""
        //let section = headerObject.section as? Int ?? 0
        
        let plates = CoreDataHandlerMicro().fetchEnviromentalPlatesWith(section: "\(self.section)", requisition_Id: self.requisition_Id , locationTypeId: NSNumber(value: self.selectedLocationTypeId ?? -100), timeStamp: self.timeStamp)
        
        if plates.count > 0 {
            self.isPlusButtonPressed = true
            var totalHeaderPlates = [LocationTypeCellModel]()
            for plate in plates {
                let plateCell = LocationTypeCellModel(plateObject: plate)
                totalHeaderPlates.append(plateCell)
            }
            self.numberOfPlateIDCreated = totalHeaderPlates
        }
    }
}
