//
//  PEDeletedDraftsDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 13/05/21.
//

import Foundation
import CoreData
import UIKit

class PEDeletedDraftsDAO {
    static let sharedInstance = PEDeletedDraftsDAO()
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func getDeletedAssessmentObj() -> PE_DeletedAssessments{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "PE_DeletedAssessments" , into: managedContext) as! PE_DeletedAssessments
        //vaccinationCertObj.us
        return vaccinationCertObj
    }
    
    func deleteExisitingData(_ entityName:String = "PE_DeletedAssessments", predicate:NSPredicate?){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if predicate != nil{
            fetchRequest.predicate = predicate
        }
        var results: [NSManagedObject] = []
        do {
            results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                for result in results {
                    managedContext.delete(result)
                }
                try managedContext.save()
            }
        } catch {
            managedContext.rollback()
            print("error executing fetch request: \(error)")
        }
    }
    
    func saveDeletedAssessmentsInfo(userId:String, serverAssessmentId:String?){
        do{
            let obj = getDeletedAssessmentObj()
            obj.userId = userId
            obj.serverId = serverAssessmentId
            obj.createdDate = Date()
            try managedContext.save()
        } catch{
            managedContext.rollback()
            print("Error while saving Deleted Draft Assesments in \(type(of: self))")
        }
    }
    
    func fetchDeletedAssessments(userId:String)->String {
        var vaccinationCertificationArr = [PE_DeletedAssessments]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_DeletedAssessments")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@", userId )
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_DeletedAssessments]
        } catch {
            print("Error while fetching PE Scheduled Assessments in \(type(of: self))")
        }
        
        var arr  = vaccinationCertificationArr.map{$0.serverId ?? "0"}
        let joinedStr = arr.joined(separator: ",")
        return joinedStr
    }
}
