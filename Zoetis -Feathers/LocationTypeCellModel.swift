//
//  LocationTypeCellModel.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 18/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation

class LocationTypeCellModel {
   
    var row: Int?
    var section: Int?
    var prevSection: Int?
    var selectedLocationValueId: Int?
    var plateId = ""
    var selectedLocationValues = ""
    var selectedLocationTypeId: Int?
    var sampleDescription = ""
    var isBacterialChecked = false
    var isMicoscoreChecked = true
    var requisition_Id = ""
    var requisitionType: Int?
    var mediaTypeValue = ""
    var selectedMediaTypeId: Int?
    var samplingMethodTypeValue = ""
    var samplingMethodTypeId: Int?
    
    var notes = String()
    var isSelectedNote = false
    var sectionNote : Int?
    var isNoteButtonTag : Int?
    var tag :Int?
    var mediaDefault : String?
    var samplingDefault : String?

    init(placeId: String = "", isBacterialChecked:Bool = false) {
        self.plateId = placeId
        self.isBacterialChecked = isBacterialChecked
    }
    
    init(plateObject: Microbial_LocationTypeHeaderPlates) {
        self.row = plateObject.row as? Int ?? nil
        self.section = plateObject.section as? Int ?? nil
        self.isBacterialChecked = plateObject.isBacterialChecked == 1 ? true : false
        self.isMicoscoreChecked = true

        self.selectedLocationValues = plateObject.locationValue ?? ""
        self.sampleDescription = plateObject.sampleDescription ?? ""
        self.mediaTypeValue = plateObject.mediaTypeValue ?? ""
        self.selectedLocationTypeId = plateObject.locationTypeId  as? Int ?? nil
        self.requisition_Id = plateObject.requisition_Id ?? ""
        self.requisitionType = plateObject.requisitionType  as? Int ?? nil
        self.selectedMediaTypeId = plateObject.mediaTypeId  as? Int ?? nil
        self.notes = plateObject.notes ?? ""
        self.samplingMethodTypeValue = plateObject.samplingMethodTypeValue ?? ""
        self.samplingMethodTypeId = plateObject.samplingMethodTypeId as? Int ?? nil
      

    }
    
    
    init(plateObject: Microbial_LocationTypeHeaderPlatesSubmitted) {
        self.row = plateObject.row as? Int ?? nil
        self.section = plateObject.section as? Int ?? nil
        self.isBacterialChecked = plateObject.isBacterialChecked == 1 ? true : false
        self.isMicoscoreChecked = true
        self.plateId = plateObject.plateId ?? ""
        self.selectedLocationValues = plateObject.locationValue ?? ""
        self.sampleDescription = plateObject.sampleDescription ?? ""
        self.mediaTypeValue = plateObject.mediaTypeValue ?? ""
        self.selectedLocationTypeId = plateObject.locationTypeId  as? Int ?? -100
        self.requisition_Id = plateObject.requisition_Id ?? ""
        self.requisitionType = plateObject.requisitionType  as? Int ?? nil
        self.selectedLocationValueId = plateObject.locationValueId?.intValue ?? 0
        self.selectedMediaTypeId = plateObject.mediaTypeId?.intValue ?? 0
        self.notes = plateObject.notes ?? ""
        self.samplingMethodTypeValue = plateObject.samplingMethodTypeValue ?? ""
        self.samplingMethodTypeId = plateObject.samplingMethodTypeId as? Int ?? nil

    }
}

 
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)).flatMap { $0 as? [String: Any] }
    }
    
    
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
    
}
