//
//  RejectedAssessmentViewModel.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 09/07/21.
//

import Foundation
import Alamofire
import CoreData

class RejectedAssessmentViewModel{
    
    var modelObj: RejectedAssessmentModel?
    
    func getRejectedAssessmentListByUser(controller: UIViewController){
        ZoetisWebServices.shared.getRejectedAssessmentListByUser(controller: controller, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            let mainQueue = OperationQueue.main
            mainQueue.addOperation{
                print(appDelegateObj.testFuntion())
            }
        })
    }
    
    func callSaveApi(dataModel: RejectedAssessmentModel){
        for data in dataModel.data{
            for rejected in data.assessmentScoresPostingData {
                print(appDelegateObj.testFuntion())
            }
        }
    }
}
