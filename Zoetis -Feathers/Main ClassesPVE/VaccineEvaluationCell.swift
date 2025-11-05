//
//  VaccineEvaluationCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 02/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Foundation

//1. delegate method
protocol VacEvalDelegate: AnyObject {
    func reloadVacEvalContent()
}

class VaccineEvaluationCell: UITableViewCell {
    
    let sharedManager = PVEShared.sharedInstance
    weak var delegate: VacEvalDelegate?
    var typeStr = ""
    var timeStampStr = ""
    var isDeclineEditing: Bool = false
    
    @IBOutlet weak var yesBtnImg : UIImageView!
    @IBOutlet weak var noBtnImg : UIImageView!
    @IBOutlet weak var notetxtView: UITextView!
    
    @IBOutlet weak var injCenter_LeftWing_Field : UITextField!
    @IBOutlet weak var injWingBand_LeftWing_Field : UITextField!
    @IBOutlet weak var injMuscleHit_LeftWing_Field : UITextField!
    @IBOutlet weak var injMissed_LeftWing_Field : UITextField!
    
    @IBOutlet weak var injCenter_RightWing_Field : UITextField!
    @IBOutlet weak var injWingBand_RightWing_Field : UITextField!
    @IBOutlet weak var injMuscleHit_RightWing_Field : UITextField!
    @IBOutlet weak var injMissed_RightWing_Field : UITextField!
    
    @IBOutlet weak var subQLeftTotal : UILabel!
    @IBOutlet weak var subQRightTotal : UILabel!
    @IBOutlet weak var injCenter_LeftWing_Percent : UILabel!
    @IBOutlet weak var injWingBand_LeftWing_Percent : UILabel!
    @IBOutlet weak var injMuscleHit_LeftWing_Percent : UILabel!
    @IBOutlet weak var injMissed_LeftWing_Percent : UILabel!
    
    @IBOutlet weak var injCenter_RightWing_Percent : UILabel!
    @IBOutlet weak var injWingBand_RightWing_Percent : UILabel!
    @IBOutlet weak var injMuscleHit_RightWing_Percent : UILabel!
    @IBOutlet weak var injMissed_RightWing_Percent : UILabel!
    
    @IBOutlet weak var centerTotalLbl : UILabel!
    @IBOutlet weak var wingBandTotalLbl : UILabel!
    @IBOutlet weak var muscleHitTotalLbl : UILabel!
    @IBOutlet weak var missedTotalLbl : UILabel!
    @IBOutlet weak var leftRightInjTotalLbl : UILabel!
    @IBOutlet weak var injCenter_LeftRight_PercentLbl : UILabel!
    @IBOutlet weak var injWingBand_LeftRight_PercentLbl : UILabel!
    @IBOutlet weak var injMuscleHit_LeftRight_PercentLbl : UILabel!
    @IBOutlet weak var injMissed_LeftRight_PercentLbl : UILabel!
    
    
    //----------------- Inactivated Vaccine---20 Points-------------
    @IBOutlet weak var injMuscleHit_IntramusculerInj_Field : UITextField!
    @IBOutlet weak var injMissed_IntramusculerInj_Field : UITextField!
    @IBOutlet weak var injMuscleHit_SubcutaneousInj_Field : UITextField!
    @IBOutlet weak var injMissed_SubcutaneousInj_Field : UITextField!
    
    @IBOutlet weak var intraInjLeftTotal : UILabel!
    @IBOutlet weak var subInjRightTotal : UILabel!
    @IBOutlet weak var injMuscleHit_IntramusculerInj_Percent : UILabel!
    @IBOutlet weak var injMissed_IntramusculerInj_Percent : UILabel!
    @IBOutlet weak var injMuscleHit_SubcutaneousInj_Percent : UILabel!
    @IBOutlet weak var injMissed_SubcutaneousInj_Percent : UILabel!
    
    @IBOutlet weak var injMuscleHit_Total : UILabel!
    @IBOutlet weak var injMissed_Total : UILabel!
    @IBOutlet weak var injTotal_For_Inactivated : UILabel!
    @IBOutlet weak var injMuscleHit_Percent : UILabel!
    @IBOutlet weak var injMissed_Percent : UILabel!
    @IBOutlet weak var scoreCholeraVaccine : UILabel!
    @IBOutlet weak var scoreInactivatedVaccine : UILabel!
    
    
    func getDraftValueForKey(key:String) -> Any{
        let valuee = CoreDataHandlerPVE().fetchDraftForSyncId(type: typeStr, syncId: timeStampStr)
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
    //--------------------------------------------------------------
    
    fileprivate func extractedFunc(_ injCenter_LeftWing: Int, _ injWingBand_LeftWing: Int, _ injMuscleHit_LeftWing: Int, _ injMissed_LeftWing: Int) {
        //------------------------------------------------------------
        
        //----Getting Total of #Inj left Wing Web & percent calculations
        
        let totalOfLeftWingWeb : Int = injCenter_LeftWing + injWingBand_LeftWing + injMuscleHit_LeftWing + injMissed_LeftWing
        subQLeftTotal.text = "\(totalOfLeftWingWeb)"
        
        if injCenter_LeftWing != 0 && totalOfLeftWingWeb != 0{
            injCenter_LeftWing_Percent.text = getPercentOForLeftRightWingWeb(value: injCenter_LeftWing, total: totalOfLeftWingWeb)
        }
        if injWingBand_LeftWing != 0 && totalOfLeftWingWeb != 0{
            injWingBand_LeftWing_Percent.text = getPercentOForLeftRightWingWeb(value: injWingBand_LeftWing, total: totalOfLeftWingWeb)
        }
        if injMuscleHit_LeftWing != 0 && totalOfLeftWingWeb != 0{
            injMuscleHit_LeftWing_Percent.text = getPercentOForLeftRightWingWeb(value: injMuscleHit_LeftWing, total: totalOfLeftWingWeb)
        }
        if injMissed_LeftWing != 0 && totalOfLeftWingWeb != 0{
            injMissed_LeftWing_Percent.text = getPercentOForLeftRightWingWeb(value: injMissed_LeftWing, total: totalOfLeftWingWeb)
        }
    }
    
    fileprivate func extractedFunc1(_ totalOfRightWingWeb: Int, _ injCenter_RightWing: Int, _ injWingBand_RightWing: Int, _ injMuscleHit_RightWing: Int, _ injMissed_RightWing: Int) {
        subQRightTotal.text = "\(totalOfRightWingWeb)"
        
        if injCenter_RightWing != 0 && totalOfRightWingWeb != 0{
            injCenter_RightWing_Percent.text = getPercentOForLeftRightWingWeb(value: injCenter_RightWing, total: totalOfRightWingWeb)
        }
        if injWingBand_RightWing != 0 && totalOfRightWingWeb != 0{
            injWingBand_RightWing_Percent.text = getPercentOForLeftRightWingWeb(value: injWingBand_RightWing, total: totalOfRightWingWeb)
        }
        if injMuscleHit_RightWing != 0 && totalOfRightWingWeb != 0{
            injMuscleHit_RightWing_Percent.text = getPercentOForLeftRightWingWeb(value: injMuscleHit_RightWing, total: totalOfRightWingWeb)
        }
        if injMissed_RightWing != 0 && totalOfRightWingWeb != 0{
            injMissed_RightWing_Percent.text = getPercentOForLeftRightWingWeb(value: injMissed_RightWing, total: totalOfRightWingWeb)
        }
    }
    
    fileprivate func extractedFunc2() {
        if centerTotalLbl.text == "0"{
            centerTotalLbl.text = ""
        }
        if wingBandTotalLbl.text == "0"{
            wingBandTotalLbl.text = ""
        }
        if muscleHitTotalLbl.text == "0"{
            muscleHitTotalLbl.text = ""
        }
        if missedTotalLbl.text == "0"{
            missedTotalLbl.text = ""
        }
    }
    
    fileprivate func extractedFunc3(_ choleraVacScore: Double, _ inactivatedVacScore: Double) {
        // ----------------------------
        
        //----- Get Vaccine Evaluation Final Score -------
        
        let vacEvalFinalScore : Double = choleraVacScore * 10 + inactivatedVacScore * 20
        sharedManager.vaccineEvaluationScoreTotal = vacEvalFinalScore
        //----------------------
        resetFields()
        
        if timeStampStr.count > 0{
            saveOtherValuesForServerForDraft()
        }else{
            saveOtherValuesForServer()
        }
    }
    
    fileprivate func extractedFunc4(_ injMuscleHit_IntramusculerInj: Int, _ totalOfIntramusculerInj: Int, _ injMissed_IntramusculerInj: Int, _ injMuscleHit_SubcutaneousInj: Int, _ totalOfSubcutaneousInj: Int, _ injMissed_SubcutaneousInj: Int) {
        if injMuscleHit_IntramusculerInj != 0 && totalOfIntramusculerInj != 0{
            injMuscleHit_IntramusculerInj_Percent.text = getPercentOForLeftRightWingWeb(value: injMuscleHit_IntramusculerInj, total: totalOfIntramusculerInj)
        }
        if injMissed_IntramusculerInj != 0 && totalOfIntramusculerInj != 0{
            injMissed_IntramusculerInj_Percent.text = getPercentOForLeftRightWingWeb(value: injMissed_IntramusculerInj, total: totalOfIntramusculerInj)
        }
        if injMuscleHit_SubcutaneousInj != 0 && totalOfSubcutaneousInj != 0{
            injMuscleHit_SubcutaneousInj_Percent.text = getPercentOForLeftRightWingWeb(value: injMuscleHit_SubcutaneousInj, total: totalOfSubcutaneousInj)
        }
        if injMissed_SubcutaneousInj != 0 && totalOfSubcutaneousInj != 0{
            injMissed_SubcutaneousInj_Percent.text = getPercentOForLeftRightWingWeb(value: injMissed_SubcutaneousInj, total: totalOfSubcutaneousInj)
        }
    }
    
    fileprivate func extractedFunc10(_ injMuscleHit_LeftWing: Int, _ leftRightInjTotal: Int, _ injMuscleHit_RightWing: Int, _ injMissed_LeftWing: Int, _ injMissed_RightWing: Int) {
        if (injMuscleHit_LeftWing != 0 && leftRightInjTotal != 0) || (injMuscleHit_RightWing != 0 && leftRightInjTotal != 0){
            injMuscleHit_LeftRight_PercentLbl.text = getPercentOfInjLeftRight(leftValue: injMuscleHit_LeftWing, RightValue: injMuscleHit_RightWing, totalOfHashInjLeftRight: leftRightInjTotal)
        }
        if (injMissed_LeftWing != 0 && leftRightInjTotal != 0) || (injMissed_RightWing != 0 && leftRightInjTotal != 0){
            injMissed_LeftRight_PercentLbl.text = getPercentOfInjLeftRight(leftValue: injMissed_LeftWing, RightValue: injMissed_RightWing, totalOfHashInjLeftRight: leftRightInjTotal)
        }
    }

    
    fileprivate func extractedFunc5(_ input: PVEDataModel.WingInjectionData) {
        if (input.injCenter_LeftWing != 0 && input.leftRightInjTotal != 0) || (input.injCenter_RightWing != 0 && input.leftRightInjTotal != 0) {
            injCenter_LeftRight_PercentLbl.text = getPercentOfInjLeftRight(
                leftValue: input.injCenter_LeftWing,
                RightValue: input.injCenter_RightWing,
                totalOfHashInjLeftRight: input.leftRightInjTotal
            )
        }

        if (input.injWingBand_LeftWing != 0 && input.leftRightInjTotal != 0) || (input.injWingBand_RightWing != 0 && input.leftRightInjTotal != 0) {
            injWingBand_LeftRight_PercentLbl.text = getPercentOfInjLeftRight(
                leftValue: input.injWingBand_LeftWing,
                RightValue: input.injWingBand_RightWing,
                totalOfHashInjLeftRight: input.leftRightInjTotal
            )
        }

        extractedFunc10(
            input.injMuscleHit_LeftWing,
            input.leftRightInjTotal,
            input.injMuscleHit_RightWing,
            input.injMissed_LeftWing,
            input.injMissed_RightWing
        )
    }

    

    fileprivate func extractedFunc6(_ totalForMuscleMIssed: Int, _ injMuscleHit_IntramusculerInj: Int, _ injMuscleHit_SubcutaneousInj: Int, _ totalForMuscleHitInj: Int, _ injMissed_IntramusculerInj: Int, _ injMissed_SubcutaneousInj: Int, _ totalForMissedInj: Int) {
        injTotal_For_Inactivated.text = "\(totalForMuscleMIssed)"
        
        if injMuscleHit_IntramusculerInj + injMuscleHit_SubcutaneousInj != 0 && totalForMuscleMIssed != 0{
            injMuscleHit_Percent.text = getPercentOForLeftRightWingWeb(value: totalForMuscleHitInj, total: totalForMuscleMIssed)
        }
        if injMissed_IntramusculerInj + injMissed_SubcutaneousInj != 0 && totalForMuscleMIssed != 0{
            injMissed_Percent.text = getPercentOForLeftRightWingWeb(value: totalForMissedInj, total: totalForMuscleMIssed)
        }
    }
    
    func refreshVacEvalFields(){
        
        var injCenter_LeftWing = Int()
        var injWingBand_LeftWing = Int()
        var injMuscleHit_LeftWing = Int()
        var injMissed_LeftWing = Int()
        
        var injCenter_RightWing = Int()
        var injWingBand_RightWing = Int()
        var injMuscleHit_RightWing = Int()
        var injMissed_RightWing = Int()
        
        if timeStampStr.count > 0 {
            injCenter_LeftWing = getDraftValueForKey(key: "injCenter_LeftWing_Field") as! Int
            injWingBand_LeftWing = getDraftValueForKey(key: "injWingBand_LeftWing_Field") as! Int
            injMuscleHit_LeftWing = getDraftValueForKey(key: "injMuscleHit_LeftWing_Field") as! Int
            injMissed_LeftWing = getDraftValueForKey(key: "injMissed_LeftWing_Field") as! Int
            
            injCenter_RightWing = getDraftValueForKey(key: "injCenter_RightWing_Field") as! Int
            injWingBand_RightWing = getDraftValueForKey(key: "injWingBand_RightWing_Field") as! Int
            injMuscleHit_RightWing = getDraftValueForKey(key: "injMuscleHit_RightWing_Field") as! Int
            injMissed_RightWing = getDraftValueForKey(key: "injMissed_RightWing_Field") as! Int
            
        } else {
            injCenter_LeftWing = sharedManager.getSessionValueForKeyFromDB(key: "injCenter_LeftWing_Field") as! Int
            injWingBand_LeftWing = sharedManager.getSessionValueForKeyFromDB(key: "injWingBand_LeftWing_Field") as! Int
            injMuscleHit_LeftWing = sharedManager.getSessionValueForKeyFromDB(key: "injMuscleHit_LeftWing_Field") as! Int
            injMissed_LeftWing = sharedManager.getSessionValueForKeyFromDB(key: "injMissed_LeftWing_Field") as! Int
            
            injCenter_RightWing = sharedManager.getSessionValueForKeyFromDB(key: "injCenter_RightWing_Field") as! Int
            injWingBand_RightWing = sharedManager.getSessionValueForKeyFromDB(key: "injWingBand_RightWing_Field") as! Int
            injMuscleHit_RightWing = sharedManager.getSessionValueForKeyFromDB(key: "injMuscleHit_RightWing_Field") as! Int
            injMissed_RightWing = sharedManager.getSessionValueForKeyFromDB(key: "injMissed_RightWing_Field") as! Int
        }
        
        injCenter_LeftWing_Field.text = "\(injCenter_LeftWing)"
        injWingBand_LeftWing_Field.text = "\(injWingBand_LeftWing)"
        injMuscleHit_LeftWing_Field.text = "\(injMuscleHit_LeftWing)"
        injMissed_LeftWing_Field.text = "\(injMissed_LeftWing)"
        
        injCenter_RightWing_Field.text = "\(injCenter_RightWing)"
        injWingBand_RightWing_Field.text = "\(injWingBand_RightWing)"
        injMuscleHit_RightWing_Field.text = "\(injMuscleHit_RightWing)"
        injMissed_RightWing_Field.text = "\(injMissed_RightWing)"
        
        // ---------Set Left Right Total For #inj Value ---------------------
        centerTotalLbl.text = getTotalForHashInject(leftValue: injCenter_LeftWing, RightValue: injCenter_RightWing)
        wingBandTotalLbl.text = getTotalForHashInject(leftValue: injWingBand_LeftWing, RightValue: injWingBand_RightWing)
        muscleHitTotalLbl.text = getTotalForHashInject(leftValue: injMuscleHit_LeftWing, RightValue: injMuscleHit_RightWing)
        missedTotalLbl.text = getTotalForHashInject(leftValue: injMissed_LeftWing, RightValue: injMissed_RightWing)
        
        extractedFunc2()
        
        let leftRightInjTotal = injCenter_LeftWing + injCenter_RightWing + injWingBand_LeftWing + injWingBand_RightWing + injMuscleHit_LeftWing + injMuscleHit_RightWing + injMissed_LeftWing + injMissed_RightWing
        leftRightInjTotalLbl.text = "\(leftRightInjTotal)"
        if leftRightInjTotalLbl.text == "0"{
            leftRightInjTotalLbl.text = ""
        }
        
        
        let injectionData = PVEDataModel.WingInjectionData(
                injCenter_LeftWing: injCenter_LeftWing,
                leftRightInjTotal: leftRightInjTotal,
                injCenter_RightWing: injCenter_RightWing,
                injWingBand_LeftWing: injWingBand_LeftWing,
                injWingBand_RightWing: injWingBand_RightWing,
                injMuscleHit_LeftWing: injMuscleHit_LeftWing,
                injMuscleHit_RightWing: injMuscleHit_RightWing,
                injMissed_LeftWing: injMissed_LeftWing,
                injMissed_RightWing: injMissed_RightWing
        )

        extractedFunc5(injectionData)
        
        
        
        
        extractedFunc(injCenter_LeftWing, injWingBand_LeftWing, injMuscleHit_LeftWing, injMissed_LeftWing)
        
        //----------------------------------------------------------------------------------------------------
        
        //----Getting Total of #Inj Right Wing Web
        
        let totalOfRightWingWeb : Int = injCenter_RightWing + injWingBand_RightWing + injMuscleHit_RightWing + injMissed_RightWing
        extractedFunc1(totalOfRightWingWeb, injCenter_RightWing, injWingBand_RightWing, injMuscleHit_RightWing, injMissed_RightWing)
        
        var injMuscleHit_IntramusculerInj = Int()
        var injMissed_IntramusculerInj = Int()
        var injMuscleHit_SubcutaneousInj = Int()
        var injMissed_SubcutaneousInj = Int()
        
        
        if timeStampStr.count > 0 {
            injMuscleHit_IntramusculerInj = getDraftValueForKey(key: "injMuscleHit_IntramusculerInj_Field") as! Int
            injMissed_IntramusculerInj = getDraftValueForKey(key: "injMissed_IntramusculerInj_Field") as! Int
            injMuscleHit_SubcutaneousInj = getDraftValueForKey(key: "injMuscleHit_SubcutaneousInj_Field") as! Int
            injMissed_SubcutaneousInj = getDraftValueForKey(key: "injMissed_SubcutaneousInj_Field") as! Int
            
        }else{
            injMuscleHit_IntramusculerInj = sharedManager.getSessionValueForKeyFromDB(key: "injMuscleHit_IntramusculerInj_Field") as! Int
            injMissed_IntramusculerInj = sharedManager.getSessionValueForKeyFromDB(key: "injMissed_IntramusculerInj_Field") as! Int
            injMuscleHit_SubcutaneousInj = sharedManager.getSessionValueForKeyFromDB(key: "injMuscleHit_SubcutaneousInj_Field") as! Int
            injMissed_SubcutaneousInj = sharedManager.getSessionValueForKeyFromDB(key: "injMissed_SubcutaneousInj_Field") as! Int
        }
        
        injMuscleHit_IntramusculerInj_Field.text = "\(injMuscleHit_IntramusculerInj)"
        injMissed_IntramusculerInj_Field.text = "\(injMissed_IntramusculerInj)"
        injMuscleHit_SubcutaneousInj_Field.text = "\(injMuscleHit_SubcutaneousInj)"
        injMissed_SubcutaneousInj_Field.text = "\(injMissed_SubcutaneousInj)"
        
        let totalOfIntramusculerInj : Int = injMuscleHit_IntramusculerInj + injMissed_IntramusculerInj
        let totalOfSubcutaneousInj : Int = injMuscleHit_SubcutaneousInj + injMissed_SubcutaneousInj
        
        
        intraInjLeftTotal.text = "\(totalOfIntramusculerInj)"
        subInjRightTotal.text = "\(totalOfSubcutaneousInj)"
        
        extractedFunc4(injMuscleHit_IntramusculerInj, totalOfIntramusculerInj, injMissed_IntramusculerInj, injMuscleHit_SubcutaneousInj, totalOfSubcutaneousInj, injMissed_SubcutaneousInj)
        
        let totalForMuscleHitInj : Int = injMuscleHit_IntramusculerInj + injMuscleHit_SubcutaneousInj
        let totalForMissedInj : Int = injMissed_IntramusculerInj + injMissed_SubcutaneousInj
        injMuscleHit_Total.text = "\(totalForMuscleHitInj)"
        injMissed_Total.text = "\(totalForMissedInj)"
        let totalForMuscleMIssed : Int = totalForMuscleHitInj + totalForMissedInj
        extractedFunc6(totalForMuscleMIssed, injMuscleHit_IntramusculerInj, injMuscleHit_SubcutaneousInj, totalForMuscleHitInj, injMissed_IntramusculerInj, injMissed_SubcutaneousInj, totalForMissedInj)
        //-------------------------------
        
        var choleraVacScore = Double()
        if (injCenter_LeftWing != 0 && leftRightInjTotal != 0) || (injCenter_RightWing != 0 && leftRightInjTotal != 0){
            choleraVacScore = getScoreForCholeraVaccine(value: injCenter_LeftWing + injCenter_RightWing, total: leftRightInjTotal)
            scoreCholeraVaccine.text = "\(String(format: "%.2f", choleraVacScore  * 10))"
        }
        
        var inactivatedVacScore = Double()
        if (totalForMuscleHitInj != 0 && totalForMuscleMIssed != 0) || (totalForMissedInj != 0 && totalForMuscleMIssed != 0){
            inactivatedVacScore = getScoreForCholeraVaccine(value: totalForMuscleHitInj, total: totalForMuscleMIssed)
            scoreInactivatedVaccine.text = "\(String(format: "%.2f", inactivatedVacScore  * 20))"
        }
        extractedFunc3(choleraVacScore, inactivatedVacScore)
        
    }
    
    func getScoreForCholeraVaccine(value:Int, total:Int) -> Double{
        let dividedValue : Double = Double(value) / Double(total)
        return dividedValue
    }
    
    func saveOtherValuesForServer() {
                
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injCenter_LeftWing_Percent.text!) ?? 0, forAttribute: "injCenter_LeftWing_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injWingBand_LeftWing_Percent.text!) ?? 0, forAttribute: "injWingBand_LeftWing_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMuscleHit_LeftWing_Percent.text!) ?? 0, forAttribute: "injMuscleHit_LeftWing_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMissed_LeftWing_Percent.text!) ?? 0, forAttribute: "injMissed_LeftWing_Percent")
        
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injCenter_RightWing_Percent.text!) ?? 0, forAttribute: "injCenter_RightWing_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injWingBand_RightWing_Percent.text!) ?? 0, forAttribute: "injWingBand_RightWing_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMuscleHit_RightWing_Percent.text!) ?? 0, forAttribute: "injMuscleHit_RightWing_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMissed_RightWing_Percent.text!) ?? 0, forAttribute: "injMissed_RightWing_Percent")
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(centerTotalLbl.text!) ?? 0, forAttribute: "centerTotalLbl")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(wingBandTotalLbl.text!) ?? 0, forAttribute: "wingBandTotalLbl")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(muscleHitTotalLbl.text!) ?? 0, forAttribute: "muscleHitTotalLbl")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(missedTotalLbl.text!) ?? 0, forAttribute: "missedTotalLbl")
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injCenter_LeftRight_PercentLbl.text!) ?? 0, forAttribute: "injCenter_LeftRight_PercentLbl")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injWingBand_LeftRight_PercentLbl.text!) ?? 0, forAttribute: "injWingBand_LeftRight_PercentLbl")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMuscleHit_LeftRight_PercentLbl.text!) ?? 0, forAttribute: "injMuscleHit_LeftRight_PercentLbl")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMissed_LeftRight_PercentLbl.text!) ?? 0, forAttribute: "injMissed_LeftRight_PercentLbl")
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: Int(subQLeftTotal.text!) ?? 0, forAttribute: "subQLeftTotal")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Int(subQRightTotal.text!) ?? 0, forAttribute: "subQRightTotal")
        
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: Int(leftRightInjTotalLbl.text!) ?? 0, forAttribute: "leftRightInjTotalLbl")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMuscleHit_IntramusculerInj_Percent.text!) ?? 0, forAttribute: "injMuscleHit_IntramusculerInj_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMissed_IntramusculerInj_Percent.text!) ?? 0, forAttribute: "injMissed_IntramusculerInj_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMuscleHit_SubcutaneousInj_Percent.text!) ?? 0, forAttribute: "injMuscleHit_SubcutaneousInj_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMissed_SubcutaneousInj_Percent.text!) ?? 0, forAttribute: "injMissed_SubcutaneousInj_Percent")
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: Int(injMuscleHit_Total.text!) ?? 0, forAttribute: "injMuscleHit_Total")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Int(injMissed_Total.text!) ?? 0, forAttribute: "injMissed_Total")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Int(injTotal_For_Inactivated.text!) ?? 0, forAttribute: "injTotal_For_Inactivated")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMuscleHit_Percent.text!) ?? 0, forAttribute: "injMuscleHit_Percent")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(injMissed_Percent.text!) ?? 0, forAttribute: "injMissed_Percent")
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(scoreCholeraVaccine.text!) ?? 0, forAttribute: "scoreCholeraVaccine")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Double(scoreInactivatedVaccine.text!) ?? 0, forAttribute: "scoreInactivatedVaccine")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Int(intraInjLeftTotal.text!) ?? 0, forAttribute: "intraInjLeftTotal")
        CoreDataHandlerPVE().updateSessionDetails(1, text: Int(subInjRightTotal.text!) ?? 0, forAttribute: "subInjRightTotal")
        
    }
    
    
    func saveOtherValuesForServerForDraft() {
        
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injCenter_LeftWing_Percent.text!) ?? 0, forAttribute: "injCenter_LeftWing_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injWingBand_LeftWing_Percent.text!) ?? 0, forAttribute: "injWingBand_LeftWing_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMuscleHit_LeftWing_Percent.text!) ?? 0, forAttribute: "injMuscleHit_LeftWing_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMissed_LeftWing_Percent.text!) ?? 0, forAttribute: "injMissed_LeftWing_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injCenter_RightWing_Percent.text!) ?? 0, forAttribute: "injCenter_RightWing_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injWingBand_RightWing_Percent.text!) ?? 0, forAttribute: "injWingBand_RightWing_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMuscleHit_RightWing_Percent.text!) ?? 0, forAttribute: "injMuscleHit_RightWing_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMissed_RightWing_Percent.text!) ?? 0, forAttribute: "injMissed_RightWing_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(centerTotalLbl.text!) ?? 0, forAttribute: "centerTotalLbl")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(wingBandTotalLbl.text!) ?? 0, forAttribute: "wingBandTotalLbl")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(muscleHitTotalLbl.text!) ?? 0, forAttribute: "muscleHitTotalLbl")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(missedTotalLbl.text!) ?? 0, forAttribute: "missedTotalLbl")
        
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injCenter_LeftRight_PercentLbl.text!) ?? 0, forAttribute: "injCenter_LeftRight_PercentLbl")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injWingBand_LeftRight_PercentLbl.text!) ?? 0, forAttribute: "injWingBand_LeftRight_PercentLbl")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMuscleHit_LeftRight_PercentLbl.text!) ?? 0, forAttribute: "injMuscleHit_LeftRight_PercentLbl")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMissed_LeftRight_PercentLbl.text!) ?? 0, forAttribute: "injMissed_LeftRight_PercentLbl")
        
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(subQLeftTotal.text!) ?? 0, forAttribute: "subQLeftTotal")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(subQRightTotal.text!) ?? 0, forAttribute: "subQRightTotal")
        
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(leftRightInjTotalLbl.text!) ?? 0, forAttribute: "leftRightInjTotalLbl")
        
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMuscleHit_IntramusculerInj_Percent.text!) ?? 0, forAttribute: "injMuscleHit_IntramusculerInj_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMissed_IntramusculerInj_Percent.text!) ?? 0, forAttribute: "injMissed_IntramusculerInj_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMuscleHit_SubcutaneousInj_Percent.text!) ?? 0, forAttribute: "injMuscleHit_SubcutaneousInj_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMissed_SubcutaneousInj_Percent.text!) ?? 0, forAttribute: "injMissed_SubcutaneousInj_Percent")
        
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(injMuscleHit_Total.text!) ?? 0, forAttribute: "injMuscleHit_Total")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(injMissed_Total.text!) ?? 0, forAttribute: "injMissed_Total")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(injTotal_For_Inactivated.text!) ?? 0, forAttribute: "injTotal_For_Inactivated")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(injMissed_Total.text!) ?? 0, forAttribute: "injMissed_Total")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMuscleHit_Percent.text!) ?? 0, forAttribute: "injMuscleHit_Percent")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(injMissed_Percent.text!) ?? 0, forAttribute: "injMissed_Percent")
        
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(scoreCholeraVaccine.text!) ?? 0, forAttribute: "scoreCholeraVaccine")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Double(scoreInactivatedVaccine.text!) ?? 0, forAttribute: "scoreInactivatedVaccine")
        
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(intraInjLeftTotal.text!) ?? 0, forAttribute: "intraInjLeftTotal")
        CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(subInjRightTotal.text!) ?? 0, forAttribute: "subInjRightTotal")
        
    }
    
    fileprivate func leftRightWingPointTable() {
        if injCenter_LeftWing_Field.text == "0"{
            injCenter_LeftWing_Field.text = ""
        }
        if injWingBand_LeftWing_Field.text == "0"{
            injWingBand_LeftWing_Field.text = ""
        }
        if injMuscleHit_LeftWing_Field.text == "0"{
            injMuscleHit_LeftWing_Field.text = ""
        }
        if injMissed_LeftWing_Field.text == "0"{
            injMissed_LeftWing_Field.text = ""
        }
        if injCenter_RightWing_Field.text == "0"{
            injCenter_RightWing_Field.text = ""
        }
        if injWingBand_RightWing_Field.text == "0"{
            injWingBand_RightWing_Field.text = ""
        }
        if injMuscleHit_RightWing_Field.text == "0"{
            injMuscleHit_RightWing_Field.text = ""
        }
        if injMissed_RightWing_Field.text == "0"{
            injMissed_RightWing_Field.text = ""
        }
        if injCenter_LeftRight_PercentLbl.text == "0"{
            injCenter_LeftRight_PercentLbl.text = ""
        }
        if injWingBand_LeftRight_PercentLbl.text == "0"{
            injWingBand_LeftRight_PercentLbl.text = ""
        }
        if injMuscleHit_LeftRight_PercentLbl.text == "0"{
            injMuscleHit_LeftRight_PercentLbl.text = ""
        }
        if injMissed_LeftRight_PercentLbl.text == "0"{
            injMissed_LeftRight_PercentLbl.text = ""
        }
        if subQLeftTotal.text == "0"{
            subQLeftTotal.text = ""
        }
        if subQRightTotal.text == "0"{
            subQRightTotal.text = ""
        }
    }
    
    func resetFields(){
        
        leftRightWingPointTable()
        
        //------------ For 20 Pont Table----
        
        if injMuscleHit_IntramusculerInj_Field.text == "0"{
            injMuscleHit_IntramusculerInj_Field.text = ""
        }
        if injMissed_IntramusculerInj_Field.text == "0"{
            injMissed_IntramusculerInj_Field.text = ""
        }
        if injMuscleHit_SubcutaneousInj_Field.text == "0"{
            injMuscleHit_SubcutaneousInj_Field.text = ""
        }
        if injMissed_SubcutaneousInj_Field.text == "0"{
            injMissed_SubcutaneousInj_Field.text = ""
        }
        if intraInjLeftTotal.text == "0"{
            intraInjLeftTotal.text = ""
        }
        if subInjRightTotal.text == "0"{
            subInjRightTotal.text = ""
        }
        if injMuscleHit_IntramusculerInj_Percent.text == "0"{
            injMuscleHit_IntramusculerInj_Percent.text = ""
        }
        if injMissed_IntramusculerInj_Percent.text == "0"{
            injMissed_IntramusculerInj_Percent.text = ""
        }
        if injMuscleHit_SubcutaneousInj_Percent.text == "0"{
            injMuscleHit_SubcutaneousInj_Percent.text = ""
        }
        if injMissed_SubcutaneousInj_Percent.text == "0"{
            injMissed_SubcutaneousInj_Percent.text = ""
        }
        if injMuscleHit_Total.text == "0"{
            injMuscleHit_Total.text = ""
        }
        if injMissed_Total.text == "0"{
            injMissed_Total.text = ""
        }
        if injTotal_For_Inactivated.text == "0"{
            injTotal_For_Inactivated.text = ""
        }
        if injMuscleHit_Percent.text == "0"{
            injMuscleHit_Percent.text = ""
        }
        if injMissed_Percent.text == "0"{
            injMissed_Percent.text = ""
        }
    }
    
    func getPercentOfInjLeftRight(leftValue:Int, RightValue:Int, totalOfHashInjLeftRight:Int) -> String{
        var total:Double = Double(leftValue) + Double(RightValue)
        total = total*100/Double(totalOfHashInjLeftRight)
        return "\(String(format: "%.2f", total))"
    }
    
    func getTotalForHashInject(leftValue:Int, RightValue:Int) -> String{
        let total:Int = leftValue + RightValue
        return "\(total)"
    }
    
    func getPercentOForLeftRightWingWeb(value:Int, total:Int) -> String{
        let dividedValue : Double = Double(value) / Double(total)
        return "\(String(format: "%.2f", dividedValue  * 100))"
        
    }
    
    @IBAction func yesBtnTapped(sender: AnyObject) {
        yesBtnImg.image = UIImage(named: "radioActive")
        noBtnImg.image = UIImage(named: "radioInactive")
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: true, forAttribute: "vacEval_DyeAdded")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: true, forAttribute: "vacEval_DyeAdded")
        }
    }
    
    @IBAction func noBtnTapped(sender: AnyObject) {
        yesBtnImg.image = UIImage(named: "radioInactive")
        noBtnImg.image = UIImage(named: "radioActive")
        
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: true, text: false, forAttribute: "vacEval_DyeAdded")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: false, forAttribute: "vacEval_DyeAdded")
        }
    }
    
}


extension VaccineEvaluationCell: UITextViewDelegate {
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.white
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }else{
            // //   print("text--\(text)")
            let newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
            
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: newString, forAttribute: "vacEval_Comment")
            }else{
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: newString, forAttribute: "vacEval_Comment")
            }
            
        }
        return true
    }
    
    
}



extension VaccineEvaluationCell: UITextFieldDelegate{
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func extractedFunc11(_ textField: UITextField, _ newString: String) {
        if textField == injMissed_LeftWing_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injMissed_LeftWing_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injMissed_LeftWing_Field")
            }
        }
    }
    
    fileprivate func extractedFunc7(_ textField: UITextField, _ newString: String) {
        //---- Left Wing Web ----
        if textField == injCenter_LeftWing_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injCenter_LeftWing_Field")
                setSyncStatus()
            } else {
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injCenter_LeftWing_Field")
            }
        }
        if textField == injWingBand_LeftWing_Field {
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injWingBand_LeftWing_Field")
                setSyncStatus()
            } else {
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injWingBand_LeftWing_Field")
            }
        }
        if textField == injMuscleHit_LeftWing_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injMuscleHit_LeftWing_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injMuscleHit_LeftWing_Field")
            }
        }
        extractedFunc11(textField, newString)
    }
    
    fileprivate func extractedFunc12(_ textField: UITextField, _ newString: String) {
        if textField == injMissed_RightWing_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injMissed_RightWing_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injMissed_RightWing_Field")
            }
        }
    }
    
    fileprivate func extractedFunc8(_ textField: UITextField, _ newString: String) {
        // --------------------------------------------------------------
        
        //---- Left Wing Web ----
        
        if textField == injCenter_RightWing_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injCenter_RightWing_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injCenter_RightWing_Field")
            }
        }
        if textField == injWingBand_RightWing_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injWingBand_RightWing_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injWingBand_RightWing_Field")
            }
        }
        if textField == injMuscleHit_RightWing_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injMuscleHit_RightWing_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injMuscleHit_RightWing_Field")
            }
        }
        extractedFunc12(textField, newString)
    }
    
    fileprivate func extractedFunc13(_ textField: UITextField, _ newString: String) {
        if textField == injMissed_SubcutaneousInj_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injMissed_SubcutaneousInj_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injMissed_SubcutaneousInj_Field")
            }
        }
    }
    
    fileprivate func extractedFunc9(_ textField: UITextField, _ newString: String) {
        if textField == injMuscleHit_IntramusculerInj_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injMuscleHit_IntramusculerInj_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injMuscleHit_IntramusculerInj_Field")
            }
        }
        if textField == injMissed_IntramusculerInj_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injMissed_IntramusculerInj_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injMissed_IntramusculerInj_Field")
            }
        }
        if textField == injMuscleHit_SubcutaneousInj_Field{
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "injMuscleHit_SubcutaneousInj_Field")
                setSyncStatus()
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "injMuscleHit_SubcutaneousInj_Field")
            }
        }
        extractedFunc13(textField, newString)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard CharacterSet(charactersIn: "1234567890").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        
        if newString.count > 8{
            return false
        }
        
        extractedFunc7(textField, newString)
        extractedFunc8(textField, newString)
        extractedFunc9(textField, newString)
        return true
    }
    
    
    func setSyncStatus() {
        
        UserDefaults.standard.set(false, forKey: "syncedStatus")
        
    }
    
    func updateSyncStatus() {
        let currentSyncedStatus =   UserDefaults.standard.bool(forKey:"syncedStatus")
        if currentSyncedStatus == false{
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: currentSyncedStatus, text: currentSyncedStatus, forAttribute: "syncedStatus")
            UserDefaults.standard.set(true, forKey: "syncedStatus")
        }
    }
}
