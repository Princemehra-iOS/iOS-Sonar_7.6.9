//
//  PlateTypesDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 05/11/20.
//

import Foundation
import CoreData
import UIKit

class PlateTypesDAO {
    
    static let sharedInstance = PlateTypesDAO()
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func getPlateTypeObj() -> PE_PlateTypes{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "PE_PlateTypes" , into: managedContext) as! PE_PlateTypes
        return vaccinationCertObj
    }
    
    // MARK: - Delete Existing Data
    func deleteExisitingData(entityName:String, predicate:NSPredicate?){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if predicate != nil{
            fetchRequest.predicate = predicate
        }
        var results: [NSManagedObject] = []
        do {
            results = try managedContext.fetch(fetchRequest)
            //Delete If exists
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
    
    // MARK: - Save Plates type
    func savePlateTypes(userId:String, plateTypeDTO:[PlateTypesDTO]){
        do{
            if plateTypeDTO.count > 0{
                deleteExisitingData(entityName: "PE_PlateTypes", predicate: NSPredicate(format:"userId = %@", userId))
                for plateTypeObj in plateTypeDTO{
                    let moObj = getPlateTypeObj()
                    convertDTOToMO(dtoObj: plateTypeObj, userId: userId, moObj: moObj)
                }
                try managedContext.save()
            }
        } catch{
            managedContext.rollback()
            print("Error while saving Upcoming Certifications in \(type(of: self))")
        }
    }
    
    func convertDTOToMO(dtoObj:PlateTypesDTO,userId:String, moObj:PE_PlateTypes){
        moObj.userId = userId
        if let id =  dtoObj.id{
            moObj.id = String(id)
        }
        moObj.text = dtoObj.text
        
    }
    
    func convertMoToVM(moObj:PE_PlateTypes)-> PlateTypeVM{
        let plateTypeObj = PlateTypeVM()
        plateTypeObj.id = moObj.id
        plateTypeObj.value = moObj.text
        
        return plateTypeObj
    }
    
    // MARK: - Fetch Plates type
    func fetchPlateTypes(userId:String)->[PlateTypeVM]{
        var vaccinationCertificationArr = [PE_PlateTypes]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_PlateTypes")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@", userId )
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_PlateTypes]
        } catch{
            print("Error while fetching PE Scheduled Assessments in \(type(of: self))")
        }
        
        var plateTypeArr = [PlateTypeVM]()
        for plate in vaccinationCertificationArr{
            let plateObj = convertMoToVM(moObj:plate)
            plateTypeArr.append(plateObj)
        }
        plateTypeArr.sort(by: {
            return $0.id! < $1.id!
        })
        
        return plateTypeArr
    }
}
