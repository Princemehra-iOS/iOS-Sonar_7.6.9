//
//  ZoetisDropdownShared.swift
//  Zoetis -Feathers
//
//  Created by Suraj Kumar Panday on 17/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation

public class ZoetisDropdownShared: NSObject {
    public static let sharedInstance = ZoetisDropdownShared()
    
// --------------PE Property Declaration-----
    
    public var sharedComplexPE: [Complex]?
    public var sharedCustomerPE: [Customer]?
    public var sharedSitePE: [Site]?
    public var sharedEvaluatorPE: [Evaluator]?
    public var sharedEvaluationTypePE: [EvaluationType]?
    public var sharedVisitTypePE: [VisitType]?
    
    public var sharedCustomerNamesPE: [String]?
    public var sharedComplexNamesPE: [String]?
    public var sharedSitesNamesPE: [String]?
    public var sharedEvaluatorNamesPE: [String]?
    public var sharedVisitTypeNamesPE: [String]?
    public var sharedEvaluationTypeNamesPE: [String]?
    
    public var selectedComplex: String?
    public var selectedCustomer: String?
    public var selectedSite: String?
    public var selectedEvaluator: String?
    public var selectedVisitType: String?
    public var selectedEvaluationType: String?
    
    public var sharedSelectedComplexPE: Complex?
    public var sharedSelectedCustomerPE: Customer?
    public var sharedSelectedSitePE: Site?
    public var sharedSelectedEvaluatorPE: Evaluator?
    public var sharedSelectedVisitTypePE: VisitType?
    public var sharedSelectedEvaluationTypePE: EvaluationType?
    
    

// --------------PVE Property Declaration-----

    public var sharedCustomerPVE: [CustomerPVE]?
    public var sharedCustomerNameArrPVE: [String]?

    public var sharedComplexResPVE: [PVEGetComplexRes]?
    public var sharedComplexResArrPVE: [String]?
    //public var selectedComplexResPVE: String?
    //public var sharedselectedComplexResPVE: PVEGetComplexRes?

    
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

    
    
// --------------Microbial Property Declaration-----
    
    public var sharedComplexMicroabial: [MicroabialCustomer]?
    public var sharedCustomerNameArrMicrobial: [String]?
    public var selectedCustomerMicrobial: String?
    public var sharedSelectedCustomerMicrobial: MicroabialCustomer?

    
}


