//
//  EvaluationTypeResponse.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 18/12/19.
//  Copyright © 2019 . All rights reserved.
//


import Foundation
import SwiftyJSON

public struct EvaluationTypeResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let evaluationTypeArray: [EvaluationType]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        evaluationTypeArray = json["Data"].arrayValue.map { EvaluationType($0) }
    }
    
    func getAllEvaluationTypeNames(evaluationTypeArray:[EvaluationType]) -> [String] {
        var evaluationTypeNameArray : [String] = []
        for obj in evaluationTypeArray {
            evaluationTypeNameArray.append(obj.evaluationName ?? "")
        }
        return evaluationTypeNameArray
    }
    
}

public struct EvaluationType {
    
    let id: Int?
    let evaluationName: String?
    let hatModuleId: Int?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        evaluationName = json["EvaluationName"].stringValue
        hatModuleId = json["HatModuleId"].intValue
        
        let evaluationNameIs = evaluationName ?? ""
        let idN = id ?? 0
        let hatModuleIdIs = hatModuleId ?? 0
        CoreDataHandlerPE().saveEvaluationInDB(NSNumber(value: idN), evaluationName: evaluationNameIs, hatModuleId:NSNumber(value: hatModuleIdIs))
        
    }
}


public struct ManufacturerResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let manufacturerArray: [Manufacturer]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        manufacturerArray = json["Data"].arrayValue.map { Manufacturer($0) }
    }
    
    func getAllManufacturerNames(manufacturerArray:[Manufacturer]) -> [String] {
        var manufacturerNameArray : [String] = []
        for obj in manufacturerArray {
            manufacturerNameArray.append(obj.MFG_Name ?? "")
        }
        return manufacturerNameArray
    }
    
}

public struct Manufacturer {
    
    let MFG_Id: Int?
    let MFG_Name: String?
    
    init(_ json: JSON) {
        MFG_Id = json["MFG_Id"].intValue
        MFG_Name = json["MFG_Name"].stringValue
        
        let MFG_NameIs = MFG_Name ?? ""
        let MFG_IdIs = MFG_Id ?? 0
        CoreDataHandlerPE().saveManufacturerInDB(mFG_Id:NSNumber(value: MFG_IdIs),mFG_Name: MFG_NameIs)
        
    }
}



public struct BreedBirdResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let breedBirdArray: [BreedBird]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        breedBirdArray = json["Data"].arrayValue.map { BreedBird($0) }
    }
    
    func getAllbreedBirdNames(breedBirdArray:[BreedBird]) -> [String] {
        var  breedBirdNameArray : [String] = []
        for obj in breedBirdArray {
            breedBirdNameArray.append(obj.BirdBreedName ?? "")
        }
        return breedBirdNameArray
    }
    
}

public struct BreedBird {
    
    let BirdId: Int?
    let BirdBreedName: String?
    
    init(_ json: JSON) {
        BirdId = json["BirdId"].intValue
        BirdBreedName = json["BirdBreedName"].stringValue
        
        let BirdBreedNameIs = BirdBreedName ?? ""
        let BirdIdIs = BirdId ?? 0
        CoreDataHandlerPE().saveBreedBirdddInDB(birdId:NSNumber(value: BirdIdIs),birdBreedName: BirdBreedNameIs)
        
    }
}

public struct PEDoseResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let peDoseArray: [PEDose]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        peDoseArray = json["Data"].arrayValue.map { PEDose($0) }
    }
}

public struct PEDose {
    
    let ID: Int?
    let Dose: String?
    
    init(_ json: JSON) {
        ID = json["Id"].intValue
        Dose = json["Dose"].stringValue
        
        let DoseIs = Dose ?? ""
        let IDIs = ID ?? 0
        
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: IDIs),size: DoseIs,forEntityName:"PE_Dose",firstKey:"id",secondKey:"dose")
    }
}


public struct PECountryResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let peCountryArray: [PECountry]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        peCountryArray = json["Data"].arrayValue.map { PECountry($0) }
    }
}

public struct PECountry {
    
    let CountryId: Int?
    let CountryName: String?
    let RegionId: Int?
    init(_ json: JSON) {
        CountryId = json["CountryId"].intValue
        CountryName = json[Constants.countryNamStr].stringValue
        RegionId = json["RegionId"].intValue
        let countryIs = CountryName ?? ""
        let CountryIdIs = CountryId ?? 0
        let RegionIdIs = RegionId ?? 0
        CoreDataHandlerPE().saveCountriesInDB(id: NSNumber(value: CountryIdIs), country: countryIs, regionId: NSNumber(value: RegionIdIs), forEntityName: "AllCountriesPE", firstKey: "countryId", secondKey: Constants.countryNamStr, thirdKey: "regionId")
        
    }
}

public struct PEClorineResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let peClorineArray: [PEClorine]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        peClorineArray = json["Data"].arrayValue.map { PEClorine($0) }
    }
}

public struct PEClorine {
    
    let ClorineId: Int?
    let ClorineName: String?
    
    init(_ json: JSON) {
        ClorineId = json["Id"].intValue
        ClorineName = json["ChlorineName"].stringValue
        
        let clorineNameIs = ClorineName ?? ""
        let clorineIdIs = ClorineId ?? 0
        CoreDataHandlerPE().saveClorineInDB(id: NSNumber(value: clorineIdIs), clorineName: clorineNameIs, forEntityName: "AllClorinePE",firstKey: "clorineId", secondKey: "clorineName")
    }
    
    public struct PEStatesResponse {
        let success: Bool?
        let statusCode: Int?
        let message: String?
        let peStatesArray: [PEStates]?
        
        init(_ json: JSON) {
            success = json["Success"].boolValue
            statusCode = json["StatusCode"].intValue
            message = json["Message"].stringValue
            peStatesArray = json["Data"].arrayValue.map { PEStates($0) }
        }
    }

    public struct PEStates {
        let StateId: Int?
        let StateName: String?
        
        init(_ json: JSON) {
            StateId = json["StateId"].intValue
            StateName = json["StateName"].stringValue
            let StateIs = StateName ?? ""
            let StateIdIs = StateId ?? 0
            CoreDataHandlerPE().saveStatesInDB(id: NSNumber(value: StateIdIs), StateName: StateIs, forEntityName: "VaccinationStatesList", firstKey: "stateId", secondKey: "stateName")
        }
    }
}

public struct EggsResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let eggsArray: [Eggs]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        eggsArray = json["Data"].arrayValue.map { Eggs($0) }
    }
}

public struct Eggs {
    
    let EggId: Int?
    let EggCount: String?
    
    init(_ json: JSON) {
        EggId = json["EggId"].intValue
        EggCount = json["EggCount"].stringValue
        
        let eggCountIs = EggCount ?? ""
        let eggIdIs = EggId ?? 0
        CoreDataHandlerPE().saveEggsInDB(EggId:NSNumber(value: eggIdIs),EggCount: eggCountIs)
    }
}

public struct VManufacturerResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let vManufacturerArray: [VManufacturer]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        vManufacturerArray = json["Data"].arrayValue.map { VManufacturer($0) }
    }
    
    func getAllVManufacturerNames(vManufacturerArray:[VManufacturer]) -> [String] {
        var  vManufacturerArraysNameArray : [String] = []
        for obj in vManufacturerArray {
            vManufacturerArraysNameArray.append(obj.mfgName ?? "")
        }
        return vManufacturerArraysNameArray
    }
    
}

public struct VManufacturer {
    
    let id: Int?
    let mfgName: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        mfgName = json["MfgName"].stringValue
        
        let mfgNameIs = mfgName ?? ""
        let idIs = id ?? 0
        CoreDataHandlerPE().saveVManufacturerInDB(id:NSNumber(value: idIs),mfgName: mfgNameIs)
        
    }
}


public struct VNamesResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let vNamesArray: [VNames]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        vNamesArray = json["Data"].arrayValue.map { VNames($0) }
    }
    
    func getAllVNames(vNamesArray:[VNames]) -> [String] {
        var  vNamesArrayArraysNameArray : [String] = []
        for obj in vNamesArray {
            vNamesArrayArraysNameArray.append(obj.name ?? "")
        }
        return vNamesArrayArraysNameArray
    }
    
}

public struct VNames {
    
    let id: Int?
    let mfgId: Int?
    let name: String?
    
    
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        name = json["Name"].stringValue
        mfgId = json["MfgId"].intValue
        let nameIs = name ?? ""
        let idIs = id ?? 0
        let mfgIdIs = mfgId ?? 0
        CoreDataHandlerPE().saveVNamesInDB(id:NSNumber(value: idIs),mfgId:NSNumber(value: mfgIdIs),name: nameIs)
        
    }
}



public struct VSubNamesResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let vSubNamesArray: [VSubNames]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        vSubNamesArray = json["Data"].arrayValue.map { VSubNames($0) }
    }
    
    func getAllVNames(vNamesArray:[VNames]) -> [String] {
        var  vNamesArrayArraysNameArray : [String] = []
        for obj in vNamesArray {
            vNamesArrayArraysNameArray.append(obj.name ?? "")
        }
        return vNamesArrayArraysNameArray
    }
    
}

public struct VSubNames {
    
    let id: Int?
    let mfgId: Int?
    let name: String?
    let vaccineTypeId:Int?
    let vaccineTypeName:String?
    
    
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        name = json["Name"].stringValue
        mfgId = json["MfgId"].intValue
        vaccineTypeId = json["VaccineTypeId"].intValue
        vaccineTypeName = json["VaccineTypeName"].stringValue
        
        let nameIs = name ?? ""
        let idIs = id ?? 0
        let mfgIdIs = mfgId ?? 0
        let vaccineTypeIdIs = vaccineTypeId ?? 0
        let vaccineTypeNameIs = vaccineTypeName ?? ""
        CoreDataHandlerPE().saveVNamesInDB(id:NSNumber(value: idIs),mfgId:NSNumber(value: mfgIdIs),name: nameIs,isSubVaccine:true,vaccineTypeId: Int64(vaccineTypeIdIs), vaccineTypeName:vaccineTypeNameIs  )
        
    }
}





public struct DManufacturerResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let dManufacturerArray: [DManufacturer]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        dManufacturerArray = json["Data"].arrayValue.map { DManufacturer($0) }
    }
    
    
    
}

public struct DManufacturer {
    
    let diluentMfgId: Int?
    let diluentMfgName: String?
    
    
    
    init(_ json: JSON) {
        diluentMfgId = json["DiluentMfgId"].intValue
        diluentMfgName = json["DiluentMfgName"].stringValue
        let diluentMfgIdIs = diluentMfgId ?? 0
        let diluentMfgNameIs = diluentMfgName ?? ""
        CoreDataHandlerPE().saveDManufacturerInDB(diluentMfgId:NSNumber(value: diluentMfgIdIs),diluentMfgName: diluentMfgNameIs)
        
    }
}



public struct BagSizeResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let bagSizeArray: [BagSize]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        bagSizeArray = json["Data"].arrayValue.map { BagSize($0) }
    }
}

public struct BagSize {
    
    let id: Int?
    let size: String?
    
    
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        size = json["Size"].stringValue
        let idIs = id ?? 0
        let sizeIs = size ?? ""
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: idIs),size: sizeIs,forEntityName:"PE_BagSizes",firstKey:"id",secondKey:"size")
        
    }
}



public struct AmplePerBagResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let amplePerBagArray: [AmplePerBag]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        amplePerBagArray = json["Data"].arrayValue.map { AmplePerBag($0) }
    }
}

public struct AmplePerBag {
    
    let id: Int?
    let size: String?
    
    
    
    init(_ json: JSON) {
        id = json["BagId"].intValue
        size = json["BagNo"].stringValue
        let idIs = id ?? 0
        let sizeIs = size ?? ""
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: idIs),size: sizeIs,forEntityName:"PE_AmplePerBag",firstKey:"bagId",secondKey:"bagNo")
        
    }
}

public struct AmpleSizeResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let ampleSizeArray: [AmpleSize]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        ampleSizeArray = json["Data"].arrayValue.map { AmpleSize($0) }
    }
}

public struct AmpleSize {
    
    let id: Int?
    let size: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        size = json["Size"].stringValue
        let idIs = id ?? 0
        let sizeIs = size ?? ""
        let removingSpaceSize = sizeIs.replacingOccurrences(of: " ", with: "")
        
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: idIs),size: removingSpaceSize,forEntityName:"PE_AmpleSizes",firstKey:"id",secondKey:"size")
    }
}



public struct PERolesResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let arrayPERoles: [PERoles]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        arrayPERoles = json["Data"].arrayValue.map { PERoles($0) }
    }
}

public struct PERoles {
    
    let roleId: Int?
    let roleName: String?
    
    init(_ json: JSON) {
        roleId = json["RoleId"].intValue
        roleName = json["RoleName"].stringValue
        let roleIdIs = roleId ?? 0
        let roleNameIs = roleName ?? ""
        let removingSpaceSize = roleNameIs.trimmingCharacters(in: .whitespacesAndNewlines)//.replacingOccurrences(of: " ", with: "")
        
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: roleIdIs),size: removingSpaceSize,forEntityName:"PE_Roles",firstKey:"roleId",secondKey:"roleName")
        
    }
}

public struct PEDOADiluentTypeResponce {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let arrayPEDOADiluentType: [PEDOADiluentType]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        arrayPEDOADiluentType = json["Data"].arrayValue.map { PEDOADiluentType($0) }
    }
}

public struct PEDOADiluentType {
    
    let diluentId: Int?
    let diluentName: String?
    
    init(_ json: JSON) {
        diluentId = json["DiluentId"].intValue
        diluentName = json["DiluentName"].stringValue
        let diluentIdIs = diluentId ?? 0
        let diluentNameIs = diluentName ?? ""
        let removingSpaceSize = diluentNameIs
        
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: diluentIdIs),size: removingSpaceSize,forEntityName:"PE_DOADiluentType",firstKey:"diluentId",secondKey:"diluentName")
        
    }
}

public struct PEFrequencyResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let arrayPEFrequency: [PEFrequency]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        arrayPEFrequency = json["Data"].arrayValue.map { PEFrequency($0) }
    }
}

public struct PEFrequency {
    
    let frequencyId: Int?
    let frequencyName: String?
    
    init(_ json: JSON) {
        frequencyId = json["FrequencyId"].intValue
        frequencyName = json["FrequencyName"].stringValue
        let roleIdIs = frequencyId ?? 0
        let roleNameIs = frequencyName ?? ""
        let removingSpaceSize = roleNameIs.replacingOccurrences(of: " ", with: "")
        
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: roleIdIs),size: removingSpaceSize,forEntityName:"PE_Frequency",firstKey:"frequencyId",secondKey:"frequencyName")
    }
}


public struct PEIncubationStyleResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let arrayPEIncubationStyle: [PEIncubationStyle]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        arrayPEIncubationStyle = json["Data"].arrayValue.map { PEIncubationStyle($0) }
    }
}

public struct  PEIncubationStyle {
    
    let incubationId: Int?
    let incubationStylesName: String?
    
    init(_ json: JSON) {
        incubationId = json["IncubationId"].intValue
        incubationStylesName = json["IncubationStylesName"].stringValue
        let incubationIdIs = incubationId ?? 0
        let incubationStylesNameIs = incubationStylesName ?? ""
        let removingSpaceSize = incubationStylesNameIs.replacingOccurrences(of: " ", with: "")
        
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: incubationIdIs),size: removingSpaceSize,forEntityName:"PE_IncubationStyle",firstKey:"incubationId",secondKey:"incubationStylesName")
        
    }
}

public struct PEDOASizesResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let arrayPEDOASizes: [PEDOASizes]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        arrayPEDOASizes = json["Data"].arrayValue.map { PEDOASizes($0) }
    }
}

public struct  PEDOASizes {
    
    let id: Int?
    let size: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        size = json["Size"].stringValue
        let idIs = id ?? 0
        let sizeIs = size ?? ""
        let removingSpaceSize = sizeIs
        
        CoreDataHandlerPE().saveBagSizeInDB(id:NSNumber(value: idIs),size: removingSpaceSize,forEntityName:"PE_DOASizes",firstKey:"id",secondKey:"size")
        
    }
}


public struct PEBlankAssessmentResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let PEBlankAssessmentArray: [PEBlankAssessment]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        PEBlankAssessmentArray = json["Data"].arrayValue.map { PEBlankAssessment($0) }
    }
}

public struct PEBlankAssessment {
    
    let Id: Int?
    let Name: String?
    let FileExtnsn: String?
    let DocxFileExtnsn: String?
    init(_ json: JSON) {
        Id = json["Id"].intValue
        Name = json["Name"].stringValue
        FileExtnsn = json["PDF"].stringValue
        DocxFileExtnsn = json["docx"].stringValue
        let fileNameIs = Name ?? ""
        let fileIdIs = Id ?? 0
        let FileExtnsnIs = FileExtnsn ?? ""
        let DocxFileExtnsnIs = DocxFileExtnsn ?? ""
        CoreDataHandlerPE().savePDFDetails(fileId: NSNumber(value: fileIdIs), fileName: fileNameIs, fileExtension: FileExtnsnIs , docxfile:DocxFileExtnsnIs )
        
    }
}
