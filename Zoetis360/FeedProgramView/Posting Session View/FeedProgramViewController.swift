
//
//  FeedProgramViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 07/10/16.
//  Copyright © 2016 "". All rights reserved.
//f

import UIKit
import CoreData
import Alamofire
import Reachability
import Gigya
import GigyaTfa
import GigyaAuth

class FeedProgramViewController: UIViewController,popUPnavigation,userLogOut,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate , syncApi{
    
    // MARK: - VARIABLES
    var buttonPopUP : UIButton!
    var fetchDosage = NSArray()
    var isClickOnAnyField = Bool()
    let objApiSync = ApiSync()
    var datePicker : UIDatePicker!
    var exitPopUP :popUP!
    var buttonBg1 = UIButton()
    
    var buttoCocodaciVac = UIButton ()
    var flag = 1
    var strYesPop = String()
    var btnTagsave = Int()
    @objc var count:Int = 0
    var index = 10
    var feedArr = NSMutableArray()
    var feedNameArr = NSMutableArray()
    var farmArrayTrue = NSArray ()
    var feedIdFromFarm = Int()
    var backBtnnFrame = UIButton ()
    var mPid = Int()
    var finializeCount = NSNumber()
    var addFarmArrayWithUnCheckForm = NSMutableArray()
    var addFarmArray = NSMutableArray()
    var addFarmArray1 = NSMutableArray()
    var set = NSSet()
    var FarmArray = NSMutableArray()
    var postingIdFromExisting = Int()
    var FeedIdFromExisting = Int()
    var postingIdFromExistingNavigate = String()
    var languageId = NSInteger()
    var postingId = NSNumber()
    var CocoiVacId = NSNumber()
    var feedProgramArray = NSMutableArray()
    var arrTagetMetric = NSMutableArray ()
    var arrTargetImp = NSMutableArray ()
    var navigatePostingsession = String()
    var feedPostingId = Int ()
    var feedImpandMetric = String()
    var mySet = NSOrderedSet()
    var customPopView1 :popUP!
    let buttonbg = UIButton ()
    let buttonbg11 = UIButton ()
    var droperTableView  =  UITableView ()
    var timer = Timer()
    var cocciControlArray = NSArray()
    var AlternativeArray = NSArray()
    var AntiboticArray = NSArray()
    var MyCoxtinBindersArray = NSArray()
    var serviceDataHldArr = NSArray()
    var targetArray = NSArray()
    var cocodiceVacine = NSMutableArray()
    var btnTag = NSInteger()
    var Allbuttonbg = Int()
    var AllDosageTag = Int()
    var cocciControlArrayfromServer = NSMutableArray()
    var AlternativeArrayfromServer = NSMutableArray()
    var AntiboticArrayfromServer = NSMutableArray()
    var MyCoxtinBindersArrayfromServer = NSMutableArray()
    var serviceDataHldArrfromServer = NSMutableArray()
    var feedId = Int()
    var feedProgadd = String()
    var addfeed = String()
    let logoutViewbg = UIButton ()
    var logOutPopView1 :UserListView!
    var datCount = 0
    
    var firstMolID = Int()
    var secoundMolID = Int()
    var thirdMolID = Int()
    var fourthMolID = Int()
    var fifthMolID = Int()
    var sixthMolID = Int()
    // MARK: - OUTLET
    
    @IBOutlet weak var antiFromDurationFirstTextField: UITextField!
    @IBOutlet weak var antiFromDurationSecondTextField: UITextField!
    @IBOutlet weak var antiFromDurationThirdTextField: UITextField!
    @IBOutlet weak var antiFromDurationFourTextField: UITextField!
    
    @IBOutlet weak var antiToDurationFirstTextField: UITextField!
    @IBOutlet weak var antiToDurationSecondTextField: UITextField!
    @IBOutlet weak var antiToDurationThirdTextField: UITextField!
    @IBOutlet weak var antiToDurationFourTextField: UITextField!
    
    @IBOutlet weak var alterNativeView: UIView!
    
    @IBOutlet weak var alternativeStarterOutlet: UIButton!
    @IBOutlet weak var syncFinalizedCount: UILabel!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var feedProgrmTitle: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var farmTableView: UITableView!
    @IBOutlet weak var selectFarmsLabel: UILabel!
    @IBOutlet weak var addFarmSelectLbl: UILabel!
    @IBOutlet weak var addFarmDroper: UIImageView!
    @IBOutlet weak var addFarmBtnOutlet: UIButton!
    @IBOutlet weak var feedType5CocciOutlet: UIButton!
    @IBOutlet weak var feedType6CocciOutlet: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fivthMoleculelBL: UILabel!
    @IBOutlet weak var sixthMoleculeLbl: UILabel!
    @IBOutlet weak var feed5textField: UILabel!
    @IBOutlet weak var feed6TextField: UILabel!
    @IBOutlet weak var from5TextField: UITextField!
    @IBOutlet weak var from6teXTfield: UITextField!
    @IBOutlet weak var toFeed5TextFeidl: UITextField!
    @IBOutlet weak var toFeed6TextField: UITextField!
    @IBOutlet weak var moleculeFeedType1Alternativ: UITextField!
    @IBOutlet weak var moleculeFeedType2Alternativ: UITextField!
    @IBOutlet weak var moleculeFeedType3Alternativ: UITextField!
    @IBOutlet weak var moleculeFeedType4Alternativ: UITextField!
    @IBOutlet weak var moleculeFeedType5Alternativ: UITextField!
    @IBOutlet weak var moleculeFeedType6Alternativ: UITextField!
    @IBOutlet weak var altrNativeDosage5Text: UILabel!
    @IBOutlet weak var altrNativeDosage6Text: UILabel!
    @IBOutlet weak var from5TextAlternative: UITextField!
    @IBOutlet weak var from6TextAlternative: UITextField!
    @IBOutlet weak var to5TextAlternative: UITextField!
    @IBOutlet weak var to6TextAlternative: UITextField!
    @IBOutlet weak var moleculeFeedType1MyCoxtin: UITextField!
    @IBOutlet weak var moleculeFeedType2MyCoxtin: UITextField!
    @IBOutlet weak var moleculeFeedType3MyCoxtin: UITextField!
    @IBOutlet weak var moleculeFeedType4MyCoxtin: UITextField!
    @IBOutlet weak var moleculeFeedType5MyCoxtin: UITextField!
    @IBOutlet weak var moleculeFeedType6MyCoxtin: UITextField!
    @IBOutlet weak var feed5DisplayLblMycoxtin: UILabel!
    @IBOutlet weak var feed6DisplayLblMycoxtin: UILabel!
    @IBOutlet weak var myCoxtin5DosageTextField: UILabel!
    @IBOutlet weak var myCoxtin6DosageTextField: UILabel!
    @IBOutlet weak var from5TextFieldMycoxtin: UITextField!
    @IBOutlet weak var from6TextFieldMycoxtin: UITextField!
    @IBOutlet weak var to5TextFieldMycoxtin: UITextField!
    @IBOutlet weak var to6TextFieldMycoxtin: UITextField!
    
    @IBOutlet weak var antiMoleculeFeedType1: UITextField!
    @IBOutlet weak var antiMoleculeFeedType2: UITextField!
    @IBOutlet weak var antiMoleculeFeedType3: UITextField!
    @IBOutlet weak var antiMoleculeFeedType4: UITextField!
    @IBOutlet weak var antiMoleculeFeedType5: UITextField!
    @IBOutlet weak var antiMoleculeFeedType6: UITextField!
    
    @IBOutlet weak var antiDosageFivthTextField: UILabel!
    @IBOutlet weak var antiDosageSixTextField: UILabel!
    @IBOutlet weak var antiFromFivthTextField: UITextField!
    @IBOutlet weak var antiFromSixthTextField: UITextField!
    @IBOutlet weak var antiToDurationfivthTextField: UITextField!
    @IBOutlet weak var antiToDurationSixTextField: UITextField!
    @IBOutlet weak var sixMoleculeLabelAnti: UILabel!
    @IBOutlet weak var fivthMoleculeLabel: UILabel!
    
    @IBOutlet weak var coccidsisStartrDrinking: UILabel!
    @IBOutlet weak var coccidsisGrowerDrinking: UILabel!
    @IBOutlet weak var coccidiosisWdDrinking: UILabel!
    @IBOutlet weak var cocciFinisherDrinkingWater: UILabel!
    
    @IBOutlet weak var myCoxtinStarterDrinking: UILabel!
    @IBOutlet weak var myCoxtinGrowerDrinking: UILabel!
    @IBOutlet weak var myCoxtinFinisherDrinking: UILabel!
    @IBOutlet weak var myCoxtinWDDrinking: UILabel!
    /****************************************************/
    
    @IBOutlet weak var myCoxtinStarterDosage: UILabel!
    @IBOutlet weak var myCoxtinGrowerDosage: UILabel!
    @IBOutlet weak var myCoxtinFinisherDosge: UILabel!
    @IBOutlet weak var myCoxtinWDDosage: UILabel!
    
    /************************************************************/
    
    @IBOutlet weak var antiboticStarterDrinking: UILabel!
    @IBOutlet weak var antiboticGrowerDrink: UILabel!
    @IBOutlet weak var antiboticFinisherDrinking: UILabel!
    @IBOutlet weak var antiboticWDDrinking: UILabel!
    @IBOutlet weak var alternatieStarterDrinking: UILabel!
    @IBOutlet weak var alternatieGrowerDrink: UILabel!
    @IBOutlet weak var alternatieFinisherDrinking: UILabel!
    @IBOutlet weak var alternatieWDDrinking: UILabel!
    
    @IBOutlet weak var coccidiosisVaccineDrinkin: UILabel!
    
    @IBOutlet weak var uprTapViewOutlet: UIControl!
    @IBOutlet weak var finsiherDrinkingOutlet: UIButton!
    
    @IBOutlet weak var coccidiosisStarterDrinkingWater: UIButton!
    @IBOutlet weak var coccidiosisGrowerDrinkingWater: UIButton!
    @IBOutlet weak var cocciWDDrinkingWater: UIButton!
    @IBOutlet weak var antiboticGrowerDrinking: UIButton!
    @IBOutlet weak var antiboticWdDrinkingWater: UIButton!
    @IBOutlet weak var antiboticFinisherDrinkingWater: UIButton!
    @IBOutlet weak var antiboticStarterDrinkingWater: UIButton!
    @IBOutlet weak var myCoxGrowerDrinkingWater: UIButton!
    @IBOutlet weak var myCoxFinisherDrinkingWater: UIButton!
    
    @IBOutlet weak var myCoxiWdDrinking: UIButton!
    @IBOutlet weak var myCoxiStarterDrinking: UIButton!
    @IBOutlet weak var coccidiosisControlOutlet: UIButton!
    @IBOutlet weak var antiboticControlOutlet: UIButton!
    @IBOutlet weak var alternativeControlOutlet: UIButton!
    @IBOutlet weak var myCotoxiinOutlet: UIButton!
    @IBOutlet weak var targetWeightDrinkingOutlet: UIButton!
    @IBOutlet weak var coccidiosisVaccineOutlet: UIButton!
    
    @IBOutlet weak var drop1Icon: UIImageView!
    @IBOutlet weak var drop2Icon: UIImageView!
    @IBOutlet weak var drop3Icon: UIImageView!
    @IBOutlet weak var drop4Icon: UIImageView!
    @IBOutlet weak var drop5Icon: UIImageView!
    @IBOutlet weak var drop6Icon: UIImageView!
    @IBOutlet weak var feedProgramTextField: UITextField!
    @IBOutlet weak var startDatellbl: UILabel!
    @IBOutlet weak var FromstarterDurationTextField: UITextField!
    @IBOutlet weak var FromGrowerTextField: UITextField!
    @IBOutlet weak var fromFinisherTextField: UITextField!
    @IBOutlet weak var fromWDtextField: UITextField!
    
    @IBOutlet weak var toStarterTextField: UITextField!
    @IBOutlet weak var toGrowerTextField: UITextField!
    @IBOutlet weak var toFinisherTextField: UITextField!
    @IBOutlet weak var toWdTextField: UITextField!
    @IBOutlet weak var coccidiosisView: UIView!
    @IBOutlet weak var antiboticView: UIView!
    
    @IBOutlet weak var  myFromFirstTextField: UITextField!
    @IBOutlet weak var  myFromSecondTextField: UITextField!
    @IBOutlet weak var  myFromThirdTextField: UITextField!
    @IBOutlet weak var  myFromFourTextField: UITextField!
    
    @IBOutlet weak var  myToFirstTextField: UITextField!
    @IBOutlet weak var  myToSecondTextField: UITextField!
    @IBOutlet weak var  myToThirdTextField: UITextField!
    @IBOutlet weak var  myToFourTextField: UITextField!
    @IBOutlet weak var alternativeDosageFirstText: UILabel!
    @IBOutlet weak var alternativeDosageSecoondText: UILabel!
    @IBOutlet weak var alternativeDosageThirdText: UILabel!
    @IBOutlet weak var alternativeDosageFourText: UILabel!
    @IBOutlet weak var alternativeFromFirstTextField: UITextField!
    @IBOutlet weak var alternativeFromSecondTextField: UITextField!
    @IBOutlet weak var alternativeFromthirdTextField: UITextField!
    @IBOutlet weak var alternativeFromFourTextField: UITextField!
    @IBOutlet weak var alternativeToFirstTextField: UITextField!
    @IBOutlet weak var alternativeToSecondTextField: UITextField!
    @IBOutlet weak var alternativeTothirdTextField: UITextField!
    @IBOutlet weak var alternativeToFourTextField: UITextField!
    @IBOutlet weak var myCotoxinBindersView: UIView!
    
    @IBOutlet weak var myStarterCheckBox: UIButton!
    @IBOutlet weak var myGrowerCheckBox: UIButton!
    @IBOutlet weak var myFinisherCheckBox: UIButton!
    @IBOutlet weak var myWdCheckBox: UIButton!
    
    ///  Coccidios Dossgae text field
    @IBOutlet weak var cocciDosFirstTextField: UITextField!
    @IBOutlet weak var cocciDosSecTextField: UITextField!
    @IBOutlet weak var cocciDosThrdTextField: UITextField!
    @IBOutlet weak var cocciDosFourTextField: UITextField!
    
    @IBOutlet weak var cocciDosFiveTextField: UITextField!
    @IBOutlet weak var cocciDosSixTextField: UITextField!
    
    @IBOutlet weak var antiboticDosageFeed1Outlet: UIButton!
    @IBOutlet weak var antiboticDosageFeed2Outlet: UIButton!
    @IBOutlet weak var antiboticDosageFeed3Outlet: UIButton!
    @IBOutlet weak var antiboticDosageFeed4Outlet: UIButton!
    @IBOutlet weak var antiboticDosageFeed5Outlet: UIButton!
    @IBOutlet weak var antiboticDosageFeed6Outlet: UIButton!
    @IBOutlet weak var antiDosageFirstTextField: UILabel!
    @IBOutlet weak var antiDosageSecondTextField: UILabel!
    @IBOutlet weak var antiDosageThirdTextField: UILabel!
    @IBOutlet weak var antiDosageFourTextField: UILabel!
    
    /////Mycoxtin Binders
    
    @IBOutlet weak var coxtinDosageFeed1Outlet: UIButton!
    @IBOutlet weak var coxtinDosageFeed2Outlet: UIButton!
    @IBOutlet weak var coxtinDosageFeed3Outlet: UIButton!
    @IBOutlet weak var coxtinDosageFeed4Outlet: UIButton!
    @IBOutlet weak var coxtinDosageFeed5Outlet: UIButton!
    @IBOutlet weak var coxtinDosageFeed6Outlet: UIButton!
    
    //// aLTERNATIVE DOSAGE TEXT
    
    @IBOutlet weak var alternativeDosageFeed1Outlet: UIButton!
    @IBOutlet weak var alternativeDosageFeed2Outlet: UIButton!
    @IBOutlet weak var alternativeDosageFeed3Outlet: UIButton!
    @IBOutlet weak var alternativeDosageFeed4Outlet: UIButton!
    @IBOutlet weak var alternativeDosageFeed5Outlet: UIButton!
    @IBOutlet weak var alternativeDosageFeed6Outlet: UIButton!
    
    
    @IBOutlet weak var cocciDosageFeed1Outlet: UIButton!
    @IBOutlet weak var cocciDosageFeed2Outlet: UIButton!
    @IBOutlet weak var cocciDosageFeed3Outlet: UIButton!
    @IBOutlet weak var cocciDosageFeed4Outlet: UIButton!
    @IBOutlet weak var cocciDosageFeed5Outlet: UIButton!
    @IBOutlet weak var cocciDosageFeed6Outlet: UIButton!
    
    @IBOutlet weak var starterDosageTextField: UILabel!
    @IBOutlet weak var growerDosageCoccidiosisTEXT: UILabel!
    @IBOutlet weak var finisherDosageTxtField: UILabel!
    @IBOutlet weak var wdDosageTextField: UILabel!
    @IBOutlet weak var antiboticStarterCheckBoxOutlet: UIButton!
    @IBOutlet weak var antiboticGrowerCheckBoxOutlet: UIButton!
    @IBOutlet weak var antiboticWDcheckBoxOutlet: UIButton!
    @IBOutlet weak var alternativeGrowerOutlet: UIButton!
    @IBOutlet weak var antiboticFinisherCheckBoxoutlet: UIButton!
    @IBOutlet weak var alternativeFinsiherOutlet: UIButton!
    @IBOutlet weak var alternativeWdOutlet: UIButton!
    @IBOutlet weak var alternativeStarterMoleculeOutlet: UIButton!
    @IBOutlet weak var alternativeGrowerMoleculeOutlet: UIButton!
    @IBOutlet weak var alternativeFinisherMoleculeOutlet: UIButton!
    @IBOutlet weak var alternativeWDMoleculeOutlet: UIButton!
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    let selectedTextDefault = "- Sélectionner -"
    let placeholderText = " Digitar"
    let feedPrgramvalidationMsg = "Please enter feed program."
    let offlineDataMsg = Constants.offline
    let moleculeFeedMsg = "Please select the molecule feed."
    let syncCompletedMs = Constants.dataSyncCompleted
    let feedTypeOne = "Feed type 1"
    let feedTypeTwo = "Feed type 2"
    let feedTypeThree = "Feed type 3"
    let feedTypeFour = "Feed type 4"
    let feedTypeFive = "Feed type 5"
    let feedTypeSix = "Feed type 6"
    // MARK: - VIEW LIFE CYCLE
    fileprivate func setDefaultText() {
        
        
        let labels: [UILabel] = [
            myCoxtinStarterDosage, myCoxtinGrowerDosage, myCoxtinFinisherDosge, myCoxtinWDDosage,
            myCoxtin5DosageTextField, myCoxtin6DosageTextField,
            antiDosageFirstTextField, antiDosageSecondTextField, antiDosageThirdTextField,
            antiDosageFourTextField, antiDosageFivthTextField, antiDosageSixTextField,
            alternativeDosageFirstText, alternativeDosageSecoondText, alternativeDosageThirdText,
            alternativeDosageFourText, altrNativeDosage5Text, altrNativeDosage6Text
        ]
        
        for label in labels {
            if label.text == appDelegateObj.selectStr {
                label.text = selectedTextDefault
            }
        }
        
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        let lngIdIs = UserDefaults.standard.integer(forKey: "lngId")
        
        if addfeed == "addfeed" {
            feedId = UserDefaults.standard.integer(forKey:"feedId")
            feedId = feedId + 1
            UserDefaults.standard.set(feedId , forKey: "feedId")
            feedProgadd = "ExtingFeeed"
        }
        
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor.black.cgColor
        
        objApiSync.delegeteSyncApi = self
        addFarmBtnOutlet.isHidden = true
        addFarmSelectLbl.isHidden = true
        addFarmDroper.isHidden = true
        selectFarmsLabel.isHidden = true
        farmTableView.alpha = 0
        alternativeToFourTextField.tag = 11
        alternativeTothirdTextField.tag = 12
        alternativeToFirstTextField.tag = 13
        alternativeToSecondTextField.tag = 14
        alternativeDosageFirstText.tag = 15
        alternativeDosageSecoondText.tag = 16
        alternativeDosageThirdText.tag = 17
        alternativeDosageFourText.tag = 18
        alternativeFromFirstTextField.tag = 19
        alternativeFromthirdTextField.tag = 20
        alternativeFromFourTextField.tag = 21
        cocciDosFirstTextField.tag = 23
        cocciDosSecTextField.tag = 22
        cocciDosThrdTextField.tag = 24
        cocciDosFourTextField.tag = 25
        cocciDosFiveTextField.tag = 112
        cocciDosSixTextField.tag = 113
        FromstarterDurationTextField.tag = 26
        FromGrowerTextField.tag = 27
        fromFinisherTextField.tag = 28
        fromWDtextField.tag = 29
        toStarterTextField.tag = 30
        toGrowerTextField.tag = 31
        toFinisherTextField.tag = 32
        toWdTextField.tag = 33
        myCoxtinStarterDosage.tag = 34
        myCoxtinGrowerDosage.tag = 35
        myCoxtinFinisherDosge.tag = 36
        myCoxtinWDDosage.tag = 37
        myFromFirstTextField.tag = 38
        myFromSecondTextField.tag = 39
        myFromThirdTextField.tag = 40
        myFromFourTextField.tag = 41
        myToFirstTextField.tag = 42
        myToSecondTextField.tag = 43
        myToThirdTextField.tag = 44
        myFromFourTextField.tag = 45
        myToFourTextField.tag = 46
        antiDosageFirstTextField.tag = 47
        antiDosageSecondTextField.tag = 48
        antiDosageThirdTextField.tag = 49
        antiDosageFourTextField.tag = 50
        antiFromDurationFourTextField.tag = 51
        antiFromDurationFirstTextField.tag = 52
        antiFromDurationThirdTextField.tag = 53
        antiFromDurationSecondTextField.tag = 54
        antiToDurationFourTextField.tag = 55
        antiToDurationFirstTextField.tag = 56
        antiToDurationThirdTextField.tag = 57
        antiToDurationSecondTextField.tag = 58
        FromstarterDurationTextField.tag = 104
        FromGrowerTextField.tag = 105
        fromFinisherTextField.tag = 106
        fromWDtextField.tag = 107
        toStarterTextField.tag = 108
        toGrowerTextField.tag = 109
        toFinisherTextField.tag = 110
        toWdTextField.tag = 111
        
        from5TextField.tag = 114
        from6teXTfield.tag = 115
        toFeed5TextFeidl.tag = 116
        toFeed6TextField.tag = 117
        altrNativeDosage5Text.tag = 118
        altrNativeDosage6Text.tag = 119
        from5TextAlternative.tag = 120
        from6TextAlternative.tag = 121
        to5TextAlternative.tag = 122
        to6TextAlternative.tag = 123
        myCoxtin5DosageTextField.tag = 124
        myCoxtin6DosageTextField.tag = 125
        from5TextFieldMycoxtin.tag = 126
        from6TextFieldMycoxtin.tag = 127
        to5TextFieldMycoxtin.tag = 128
        
        to6TextFieldMycoxtin.tag = 129
        antiDosageFivthTextField.tag = 130
        antiDosageSixTextField.tag = 131
        antiFromFivthTextField.tag = 132
        antiFromSixthTextField.tag = 133
        antiToDurationfivthTextField.tag = 134
        alternativeFromSecondTextField.tag = 136
        antiToDurationSixTextField.tag = 135
        
        feedProgramTextField.delegate = self
        alternativeToFourTextField.delegate = self
        alternativeTothirdTextField.delegate = self
        alternativeToFirstTextField.delegate = self
        alternativeToSecondTextField.delegate = self
        alternativeFromFirstTextField.delegate = self
        alternativeFromthirdTextField.delegate = self
        alternativeFromFourTextField.delegate = self
        FromstarterDurationTextField.delegate = self
        FromGrowerTextField.delegate = self
        fromFinisherTextField.delegate = self
        fromWDtextField.delegate = self
        toStarterTextField.delegate = self
        toGrowerTextField.delegate = self
        toFinisherTextField.delegate = self
        toWdTextField.delegate = self
        myFromFirstTextField.delegate = self
        myFromSecondTextField.delegate = self
        myFromThirdTextField.delegate = self
        myFromFourTextField.delegate = self
        myToFirstTextField.delegate = self
        myToSecondTextField.delegate = self
        myToThirdTextField.delegate = self
        myFromFourTextField.delegate = self
        myToFourTextField.delegate = self
        antiFromDurationFourTextField.delegate = self
        antiFromDurationFirstTextField.delegate = self
        antiFromDurationThirdTextField.delegate = self
        antiFromDurationSecondTextField.delegate = self
        antiToDurationFourTextField.delegate = self
        antiToDurationFirstTextField.delegate = self
        antiToDurationThirdTextField.delegate = self
        antiToDurationSecondTextField.delegate = self
        FromstarterDurationTextField.delegate = self
        FromGrowerTextField.delegate = self
        fromFinisherTextField.delegate = self
        fromWDtextField.delegate = self
        toStarterTextField.delegate = self
        toGrowerTextField.delegate = self
        toFinisherTextField.delegate = self
        toWdTextField.delegate = self
        
        moleculeFeedType1Alternativ.delegate = self
        moleculeFeedType2Alternativ.delegate = self
        moleculeFeedType3Alternativ.delegate = self
        moleculeFeedType4Alternativ.delegate = self
        moleculeFeedType5Alternativ.delegate = self
        moleculeFeedType5Alternativ.delegate = self
        from5TextField.delegate = self
        from6teXTfield.delegate = self
        toFeed5TextFeidl.delegate = self
        toFeed6TextField.delegate = self
        from5TextAlternative.delegate = self
        from6TextAlternative.delegate = self
        to5TextAlternative.delegate = self
        to6TextAlternative.delegate = self
        antiFromFivthTextField.delegate = self
        antiFromSixthTextField.delegate = self
        antiToDurationfivthTextField.delegate = self
        antiToDurationSixTextField.delegate = self
        antiMoleculeFeedType1.delegate = self
        antiMoleculeFeedType2.delegate = self
        antiMoleculeFeedType3.delegate = self
        antiMoleculeFeedType4.delegate = self
        antiMoleculeFeedType5.delegate = self
        antiMoleculeFeedType6.delegate = self
        to6TextFieldMycoxtin.delegate = self
        to5TextFieldMycoxtin.delegate = self
        from5TextFieldMycoxtin.delegate = self
        from6TextFieldMycoxtin.delegate = self
        moleculeFeedType1MyCoxtin.delegate = self
        moleculeFeedType2MyCoxtin.delegate = self
        moleculeFeedType3MyCoxtin.delegate = self
        moleculeFeedType4MyCoxtin.delegate = self
        moleculeFeedType5MyCoxtin.delegate = self
        moleculeFeedType6MyCoxtin.delegate = self
        to6TextFieldMycoxtin.delegate = self
        from6TextFieldMycoxtin.delegate = self
        moleculeFeedType6MyCoxtin.delegate = self
        
        if postingIdFromExistingNavigate == "Exting"{
            postingId = postingIdFromExisting as NSNumber
        }
        else if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            postingId =  UserDefaults.standard.integer(forKey: "postingId") as NSNumber
        }
        else{
            postingId = UserDefaults.standard.integer(forKey: "postingId") as NSNumber
        }
        
        btnTag = 0
        coccidiosisControlOutlet.layer.cornerRadius = 7
        myCotoxiinOutlet.layer.cornerRadius = 7
        alternativeControlOutlet.layer.cornerRadius = 7
        antiboticControlOutlet.layer.cornerRadius = 7
        
        styleButton(addFarmBtnOutlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coccidiosisStarterDrinkingWater, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coccidiosisGrowerDrinkingWater, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(finsiherDrinkingOutlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(cocciWDDrinkingWater, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(feedType5CocciOutlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(feedType6CocciOutlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(cocciDosageFeed1Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(cocciDosageFeed2Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(cocciDosageFeed3Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(cocciDosageFeed4Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(cocciDosageFeed5Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(cocciDosageFeed6Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coxtinDosageFeed1Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coxtinDosageFeed2Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coxtinDosageFeed3Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coxtinDosageFeed4Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coxtinDosageFeed5Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coxtinDosageFeed6Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(coccidiosisVaccineOutlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(antiboticDosageFeed1Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(antiboticDosageFeed2Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(antiboticDosageFeed3Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(antiboticDosageFeed4Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(antiboticDosageFeed5Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(antiboticDosageFeed6Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(alternativeDosageFeed1Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(alternativeDosageFeed2Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(alternativeDosageFeed3Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(alternativeDosageFeed4Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(alternativeDosageFeed5Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        styleButton(alternativeDosageFeed6Outlet, cornerRadius: 3.5, borderColor: .black, borderWidth: 1.0)
        
        coccidiosisView.isHidden = false
        antiboticView.isHidden = true
        alterNativeView.isHidden = true
        myCotoxinBindersView.isHidden = true
        
        serviceDataHldArr = (UserDefaults.standard.value(forKey: "Molucule") as? NSArray)!
        
        self.callSaveMethod(commonAray: serviceDataHldArr,tag: btnTag)
        
        cocodiceVacine =  CoreDataHandler().fetchCociVacLngId(lngId: lngIdIs as NSNumber).mutableCopy() as! NSMutableArray
        
        targetArray =  (UserDefaults.standard.value(forKey:"target") as? NSArray)!
        
        
        if lngIdIs == 3 {
            
            feedProgrmTitle.text = "Programme alimentaire"
            startDatellbl.text = "Date de début"
            lblDate.text =  "Sélectionner une date"
            
            setDefaultText()
            
            
            if lngIdIs == 1 {
                let labels: [UILabel] = [
                    starterDosageTextField,
                    growerDosageCoccidiosisTEXT,
                    finisherDosageTxtField,
                    wdDosageTextField,
                    feed5textField,
                    feed6TextField
                ]
                
                for label in labels {
                    if label.text == appDelegateObj.selectStr {
                        label.text = selectedTextDefault
                    }
                }
            }
            
        }
        
        if lngIdIs == 4 {
            cocciDosFirstTextField.placeholder = placeholderText
            cocciDosSecTextField.placeholder   = placeholderText
            cocciDosThrdTextField.placeholder  = placeholderText
            cocciDosFourTextField.placeholder  = placeholderText
            cocciDosFiveTextField.placeholder  = placeholderText
            cocciDosSixTextField.placeholder   = placeholderText
        }
        
        
    }
    
    
    fileprivate func handleViewWillAppearRefactor0() {
        for i in 0..<targetArray.count {
            let scaleType = (targetArray.value(forKey:"ScaleType") as AnyObject).object(at:i) as! String
            
            if "Metric" == scaleType {
                arrTagetMetric.add((targetArray.value(forKey:"TargetWeightProcessingName") as AnyObject).object(at:i) as! String)
            } else if("Imperial" == scaleType) {
                arrTargetImp.add((targetArray.value(forKey:"TargetWeightProcessingName") as AnyObject).object(at:i) as! String)
            }
        }
        
        if navigatePostingsession == "PostingFeedProgram" {
            cocciControlArray = CoreDataHandler().fetchAllCocciControl(feedPostingId as NSNumber)
            AntiboticArray = CoreDataHandler().fetchAntibotic(feedPostingId as NSNumber)
            AlternativeArray = CoreDataHandler().fetchAlternative(feedPostingId as NSNumber)
            MyCoxtinBindersArray = CoreDataHandler().fetchMyBinders(feedPostingId as NSNumber)
        }
        
        else if postingIdFromExistingNavigate == "Exting" {
            if addfeed == "addfeed" {
                feedProgadd = "ExtingFeeed"
            } else {
                
                cocciControlArray = CoreDataHandler().fetchAllCocciControl(self.FeedIdFromExisting as NSNumber)
                AntiboticArray = CoreDataHandler().fetchAntibotic(self.FeedIdFromExisting as NSNumber)
                AlternativeArray = CoreDataHandler().fetchAlternative(self.FeedIdFromExisting as NSNumber)
                MyCoxtinBindersArray = CoreDataHandler().fetchMyBinders(self.FeedIdFromExisting as NSNumber)
            }
        } else {
            
            feedId =   UserDefaults.standard.integer(forKey: "feedId")
            cocciControlArray = CoreDataHandler().fetchAllCocciControl(feedId as NSNumber)
            AntiboticArray = CoreDataHandler().fetchAntibotic(feedId as NSNumber)
            AlternativeArray = CoreDataHandler().fetchAlternative(feedId as NSNumber)
            MyCoxtinBindersArray = CoreDataHandler().fetchMyBinders(feedId as NSNumber)
            
        }
    }
    
    fileprivate func handleCoociControleArrayValidations(_ i: Int) {
        if cocciControlArray.count == 1 {
            coccidiosisVaccineDrinkin.text = (cocciControlArray.value(forKey:"coccidiosisVaccine") as AnyObject).object(at:i) as? String
        } else {
            coccidiosisVaccineDrinkin.text = (cocciControlArray.value(forKey:"coccidiosisVaccine") as AnyObject).object(at:0) as? String
        }
        if cocciControlArray.count == 1 {
            feedProgramTextField.text = (cocciControlArray.value(forKey:"feedProgram") as AnyObject).object(at:i) as? String
        } else {
            feedProgramTextField.text = (cocciControlArray.value(forKey:"feedProgram") as AnyObject).object(at:0) as? String
        }
        if cocciControlArray.count == 1 {
            lblDate.text = (cocciControlArray.value(forKey:"feedDate") as AnyObject).object(at:i) as? String
        } else {
            lblDate.text = (cocciControlArray.value(forKey:"feedDate") as AnyObject).object(at:0) as? String
        }
    }
    
    fileprivate func handleLanguageFieldsValidations(_ labelFields: [UILabel?], _ dosageArray: [String], _ textFields: [UITextField?]) {
        // Loop through indices to set values properly
        for i in 0..<min(labelFields.count, dosageArray.count) {
            if languageId == 1 {
                labelFields[i]?.text = dosageArray[i]  // Assign to UILabel
            } else if languageId == 4 {
                textFields[i]?.text = dosageArray[i]   // Assign to UITextField
            } else {
                labelFields[i]?.text = dosageArray[i]  // Default case
            }
        }
    }
    
    fileprivate func handleViewWillAppearRefactor1() {
        if cocciControlArray.count > 0 {
            
            for i in 0..<cocciControlArray.count {
                self.setupCocciMoleculeData()
                
                /// *********************** Dossage fields data setup for Coccidiosis ****************************************
                let dosageArray = cocciControlArray.value(forKey: "dosage") as? [String] ?? []
                
                let labelFields: [UILabel?] = [
                    starterDosageTextField,
                    growerDosageCoccidiosisTEXT,
                    finisherDosageTxtField,
                    wdDosageTextField,
                    feed5textField,
                    feed6TextField
                ]
                
                let textFields: [UITextField?] = [
                    cocciDosFirstTextField,
                    cocciDosSecTextField,
                    cocciDosThrdTextField,
                    cocciDosFourTextField,
                    cocciDosFiveTextField,
                    cocciDosSixTextField
                ]
                
                handleLanguageFieldsValidations(labelFields, dosageArray, textFields)
                
                /// *********************** to & From fields data setup for Coccidiosis ****************************************
                ///
                let fromTextFields: [UITextField] = [
                    FromstarterDurationTextField, FromGrowerTextField, fromFinisherTextField,
                    fromWDtextField, from5TextField, from6teXTfield
                ]
                
                let toTextFields: [UITextField] = [
                    toStarterTextField, toGrowerTextField, toFinisherTextField,
                    toWdTextField, toFeed5TextFeidl, toFeed6TextField
                ]
                
                if let fromDaysArray = cocciControlArray.value(forKey: "fromDays") as? [String],
                   let toDaysArray = cocciControlArray.value(forKey: "toDays") as? [String] {
                    
                    for (indexFromTextField, textField) in fromTextFields.enumerated() {
                        textField.text = fromDaysArray.indices.contains(indexFromTextField) ? fromDaysArray[indexFromTextField] : nil
                    }
                    
                    for (indexToTxtFld, textField) in toTextFields.enumerated() {
                        textField.text = toDaysArray.indices.contains(indexToTxtFld) ? toDaysArray[indexToTxtFld] : nil
                    }
                }
                
                handleCoociControleArrayValidations(i)
            }
        }
    }
    
    fileprivate func handleAndPopulateDataOnTextFieldsViewWillAppear(_ molecules: [String], _ dosages: [String], _ fromDays: [String], _ toDays: [String]) {
        let alternativeMoleculeFields = [moleculeFeedType1Alternativ, moleculeFeedType2Alternativ, moleculeFeedType3Alternativ,
                                         moleculeFeedType4Alternativ, moleculeFeedType5Alternativ, moleculeFeedType6Alternativ]
        
        let alternativeDosageFields = [alternativeDosageFirstText, alternativeDosageSecoondText, alternativeDosageThirdText,
                                       alternativeDosageFourText, altrNativeDosage5Text, altrNativeDosage6Text]
        
        let alternativeFromDurationFields = [alternativeFromFirstTextField, alternativeFromSecondTextField, alternativeFromthirdTextField,
                                             alternativeFromFourTextField, from5TextAlternative, from6TextAlternative]
        
        let alternativetToDurationFields = [alternativeToFirstTextField, alternativeToSecondTextField, alternativeTothirdTextField,
                                            alternativeToFourTextField, to5TextAlternative, to6TextAlternative]
        
        for i in 0..<min(AlternativeArray.count, 6) {
            if let molecule = molecules[safe: i] {
                alternativeMoleculeFields[i]?.text = molecule
            }
            if let dosage = dosages[safe: i] {
                alternativeDosageFields[i]?.text = dosage
            }
            if let fromDay = fromDays[safe: i] {
                alternativeFromDurationFields[i]?.text = fromDay
            }
            if let toDay = toDays[safe: i] {
                alternativetToDurationFields[i]?.text = toDay
            }
        }
    }
    
    fileprivate func handleViewWillAppearRefactor2() {
        /*********************  Antibiotic Data Bind  ****************************/
        if AntiboticArray.count > 0 {
            
            guard let molecules = AntiboticArray.value(forKey: "molecule") as? [String],
                  let dosages = AntiboticArray.value(forKey: "dosage") as? [String],
                  let fromDays = AntiboticArray.value(forKey: "fromDays") as? [String],
                  let toDays = AntiboticArray.value(forKey: "toDays") as? [String],
                  let feedPrograms = AntiboticArray.value(forKey: "feedProgram") as? [String] else { return }
            
            let moleculeFields = [antiMoleculeFeedType1, antiMoleculeFeedType2, antiMoleculeFeedType3,
                                  antiMoleculeFeedType4, antiMoleculeFeedType5, antiMoleculeFeedType6]
            
            let dosageFields = [antiDosageFirstTextField, antiDosageSecondTextField, antiDosageThirdTextField,
                                antiDosageFourTextField, antiDosageFivthTextField, antiDosageSixTextField]
            
            let fromDurationFields = [antiFromDurationFirstTextField, antiFromDurationSecondTextField, antiFromDurationThirdTextField,
                                      antiFromDurationFourTextField, antiFromFivthTextField, antiFromSixthTextField]
            
            let toDurationFields = [antiToDurationFirstTextField, antiToDurationSecondTextField, antiToDurationThirdTextField,
                                    antiToDurationFourTextField, antiToDurationfivthTextField, antiToDurationSixTextField]
            
            
            for i in 0..<min(AntiboticArray.count, 6) {
                moleculeFields[i]?.text = molecules[safe: i]
                dosageFields[i]?.text = dosages[safe: i]
                fromDurationFields[i]?.text = fromDays[safe: i]
                toDurationFields[i]?.text = toDays[safe: i]
            }
            
            feedProgramTextField.text = feedPrograms.first
            
        }
        /*********************  Alternative Data Bind  ****************************/
        if AlternativeArray.count > 0 {
            
            guard let molecules = AlternativeArray.value(forKey: "molecule") as? [String],
                  let dosages = AlternativeArray.value(forKey: "dosage") as? [String],
                  let fromDays = AlternativeArray.value(forKey: "fromDays") as? [String],
                  let toDays = AlternativeArray.value(forKey: "toDays") as? [String],
                  let feedPrograms = AlternativeArray.value(forKey: "feedProgram") as? [String] else { return }
            
            handleAndPopulateDataOnTextFieldsViewWillAppear(molecules, dosages, fromDays, toDays)
            
            feedProgramTextField.text = feedPrograms.first
            
        }
    }
    
    fileprivate func handleAddFarmelectLblTextOnUIViewWillAppear(_ ftitle: NSMutableString) {
        for i in 0..<feedNameArr.count {
            let farms = feedNameArr.object(at:i) as! CaptureNecropsyData
            let strfarmName = farms.farmName! as String
            // addFarmSelectLbl.text = strfarmName
            var label:UILabel
            if (i == 0) {
                label = UILabel()
                label.frame = CGRect(x: 50, y: 519, width: 111, height: 21)
                ftitle.append( strfarmName + " " )
            } else {
                label  = UILabel()
                label.frame = CGRect(x: 50, y: 519, width: 111*(CGFloat(i)+1)+10, height: 21)
                ftitle.append(", " + strfarmName + " " )
            }
            
            label.textAlignment = NSTextAlignment.center
            label.backgroundColor = UIColor.red
            addFarmSelectLbl.text = ftitle as String
        }
    }
    
    fileprivate func handleViewWillAppearRefactor3() {
        if (UserDefaults.standard.bool(forKey:"Unlinked") == true) {
            
            addFarmBtnOutlet.isHidden = false
            addFarmSelectLbl.isHidden = false
            addFarmDroper.isHidden = false
            selectFarmsLabel.isHidden = false
            
            if feedProgramTextField.text != "" {
                let necId =  UserDefaults.standard.integer(forKey:("necUnLinked"))
                
                if (navigatePostingsession == "PostingFeedProgram"){
                    
                    feedNameArr = CoreDataHandler().FetchFarmNameOnNecropsystep1neccId(necId as NSNumber, feedProgramName: feedProgramTextField.text!,feedId : feedPostingId as NSNumber).mutableCopy()as! NSMutableArray
                } else {
                    feedNameArr = CoreDataHandler().FetchFarmNameOnNecropsystep1neccId(necId as NSNumber, feedProgramName: feedProgramTextField.text!,feedId : feedId as NSNumber).mutableCopy() as! NSMutableArray
                }
                
                if (feedNameArr.count > 0) {
                    let ftitle = NSMutableString()
                    handleAddFarmelectLblTextOnUIViewWillAppear(ftitle)
                }
            }
        } else {
            addFarmBtnOutlet.isHidden = true
            addFarmSelectLbl.isHidden = true
            addFarmDroper.isHidden = true
            selectFarmsLabel.isHidden = true
        }
    }
    
    fileprivate func handleMyCoxinBinderArrayValidations(_ molecules: [String], _ dosages: [String], _ fromDays: [String], _ toDays: [String]) {
        let mycotoxinMoleculeFields = [moleculeFeedType1MyCoxtin, moleculeFeedType2MyCoxtin, moleculeFeedType3MyCoxtin,
                                       moleculeFeedType4MyCoxtin, moleculeFeedType5MyCoxtin, moleculeFeedType6MyCoxtin]
        
        let mycotoxinDosageFields = [myCoxtinStarterDosage, myCoxtinGrowerDosage, myCoxtinFinisherDosge,
                                     myCoxtinWDDosage, myCoxtin5DosageTextField, myCoxtin6DosageTextField]
        
        let mycotoxinFromDurationFields = [myFromFirstTextField, myFromSecondTextField, myFromThirdTextField,
                                           myFromFourTextField, from5TextFieldMycoxtin, from6TextFieldMycoxtin]
        
        let mycotoxinToDurationFields = [myToFirstTextField, myToSecondTextField, myToThirdTextField,
                                         myToFourTextField, to5TextFieldMycoxtin, to6TextFieldMycoxtin]
        
        for i in 0..<min(MyCoxtinBindersArray.count, 6) {
            if let molecule = molecules[safe: i] {
                mycotoxinMoleculeFields[i]?.text = molecule
            }
            if let dosage = dosages[safe: i] {
                mycotoxinDosageFields[i]?.text = dosage
            }
            if let fromDay = fromDays[safe: i] {
                mycotoxinFromDurationFields[i]?.text = fromDay
            }
            if let toDay = toDays[safe: i] {
                mycotoxinToDurationFields[i]?.text = toDay
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        spacingInTxtField()
        self.printSyncLblCount()
        languageId = UserDefaults.standard.integer(forKey: "lngId")
        
        if languageId == 4 {
            self.hideTextField(hide: false)
            self.hideDropButtons(hide: true)
        } else {
            self.hideTextField(hide: true)
            self.hideDropButtons(hide: false)
        }
        
        feedProgramTextField.isUserInteractionEnabled = true
        coccidiosisView.isUserInteractionEnabled = true
        alterNativeView.isUserInteractionEnabled = true
        antiboticView.isUserInteractionEnabled = true
        myCotoxinBindersView.isUserInteractionEnabled = true
        doneBtnOutlet.isHidden = false
        
        userNameLabel.text! = UserDefaults.standard.value(forKey:"FirstName") as! String
        arrTargetImp.removeAllObjects()
        arrTagetMetric.removeAllObjects()
        handleViewWillAppearRefactor0()
        handleViewWillAppearRefactor1()
        handleViewWillAppearRefactor2()
        
        /*********************  MyBlinder  ****************************/
        
        if MyCoxtinBindersArray.count > 0 {
            guard let molecules = MyCoxtinBindersArray.value(forKey: "molecule") as? [String],
                  let dosages = MyCoxtinBindersArray.value(forKey: "dosage") as? [String],
                  let fromDays = MyCoxtinBindersArray.value(forKey: "fromDays") as? [String],
                  let toDays = MyCoxtinBindersArray.value(forKey: "toDays") as? [String],
                  let feedPrograms = MyCoxtinBindersArray.value(forKey: "feedProgram") as? [String] else { return }
            
            handleMyCoxinBinderArrayValidations(molecules, dosages, fromDays, toDays)
            feedProgramTextField.text = feedPrograms.first
        }
        
        handleViewWillAppearRefactor3()
        coccidiosisControlOutlet.setTitle(NSLocalizedString(Constants.coccidioStr, comment: ""), for: .normal)
        antiboticControlOutlet.setTitle(NSLocalizedString("Antibiotic", comment: ""), for: .normal)
        alternativeControlOutlet.setTitle(NSLocalizedString("Alternative", comment: ""), for: .normal)
        myCotoxiinOutlet.setTitle(NSLocalizedString(Constants.mytoxinStr, comment: ""), for: .normal)
        
        coccidiosisControlOutlet.setTitle(NSLocalizedString(Constants.coccidioStr, comment: ""), for: .selected)
        antiboticControlOutlet.setTitle(NSLocalizedString("Antibiotic", comment: ""), for: .selected)
        alternativeControlOutlet.setTitle(NSLocalizedString("Alternative", comment: ""), for: .selected)
        myCotoxiinOutlet.setTitle(NSLocalizedString(Constants.mytoxinStr, comment: ""), for: .selected)
        
    }
    
    func setupCocciMoleculeData() {
        let dosageKey = "molecule"
        let moleculeIDKey = "dosemoleculeId"
        
        let moleculeLabels = [
            coccidsisStartrDrinking,
            coccidsisGrowerDrinking,
            cocciFinisherDrinkingWater,
            coccidiosisWdDrinking,
            fivthMoleculelBL,
            sixthMoleculeLbl
        ]
        
        var moleculeIDs = [Int?](repeating: nil, count: moleculeLabels.count)
        
        guard let molecules = cocciControlArray.value(forKey: dosageKey) as? [String] else {
            print("Error: 'molecule' key is missing or not an array")
            return
        }
        
        guard let moleculeIDsArray = cocciControlArray.value(forKey: moleculeIDKey) as? [Int] else {
            print("Error: 'dosemoleculeId' key is missing or not an array")
            return
        }
        
        for moleculeIndex in 0..<moleculeLabels.count {
            let molecule = moleculeIndex < molecules.count ? molecules[moleculeIndex] : ""
            let moleculeID = moleculeIndex < moleculeIDsArray.count ? moleculeIDsArray[moleculeIndex] : 0
            
            if molecule.isEmpty {
                moleculeLabels[moleculeIndex]?.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            } else {
                moleculeLabels[moleculeIndex]?.text = molecule
                moleculeIDs[moleculeIndex] = moleculeID
            }
        }
        
        // Assign molecule IDs to respective variables
        firstMolID = moleculeIDs[0] ?? 0
        secoundMolID = moleculeIDs[1] ?? 0
        thirdMolID = moleculeIDs[2] ?? 0
        fourthMolID = moleculeIDs[3] ?? 0
        fifthMolID = moleculeIDs[4] ?? 0
        sixthMolID = moleculeIDs[5] ?? 0
    }
    
    // MARK: - Set Corner Radius , color & Border Width of button's
    func styleButton(_ button: UIButton, cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        button.layer.cornerRadius = cornerRadius
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = borderWidth
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func hideTextField(hide: Bool){
        cocciDosFirstTextField.isHidden = hide
        cocciDosSecTextField.isHidden = hide
        cocciDosThrdTextField.isHidden = hide
        cocciDosFourTextField.isHidden = hide
        cocciDosFiveTextField.isHidden = hide
        cocciDosSixTextField.isHidden = hide
        
        cocciDosFirstTextField.isUserInteractionEnabled = !hide
        cocciDosSecTextField.isUserInteractionEnabled = !hide
        cocciDosThrdTextField.isUserInteractionEnabled = !hide
        cocciDosFourTextField.isUserInteractionEnabled = !hide
        cocciDosFiveTextField.isUserInteractionEnabled = !hide
        cocciDosSixTextField.isUserInteractionEnabled = !hide
    }
    
    func hideDropButtons(hide: Bool){
        cocciDosageFeed1Outlet.isHidden = hide
        cocciDosageFeed2Outlet.isHidden = hide
        cocciDosageFeed3Outlet.isHidden = hide
        cocciDosageFeed4Outlet.isHidden = hide
        cocciDosageFeed5Outlet.isHidden = hide
        cocciDosageFeed6Outlet.isHidden = hide
        
        cocciDosageFeed1Outlet.isUserInteractionEnabled = !hide
        cocciDosageFeed2Outlet.isUserInteractionEnabled = !hide
        cocciDosageFeed3Outlet.isUserInteractionEnabled = !hide
        cocciDosageFeed4Outlet.isUserInteractionEnabled = !hide
        cocciDosageFeed5Outlet.isUserInteractionEnabled = !hide
        cocciDosageFeed6Outlet.isUserInteractionEnabled = !hide
        
        starterDosageTextField.isHidden = hide
        growerDosageCoccidiosisTEXT.isHidden = hide
        finisherDosageTxtField.isHidden = hide
        wdDosageTextField.isHidden = hide
        feed5textField.isHidden = hide
        feed6TextField.isHidden = hide
        
        drop1Icon.isHidden = hide
        drop2Icon.isHidden = hide
        drop3Icon.isHidden = hide
        drop4Icon.isHidden = hide
        drop5Icon.isHidden = hide
        drop6Icon.isHidden = hide
    }
    
    
    @IBAction func dateAction(sender: AnyObject) {
        view.endEditing(true)
        // btnDate.layer.borderColor = UIColor.black.cgColor
        let buttons  = CommonClass.sharedInstance.pickUpDateFeed()
        buttonBg1  = buttons.0
        buttonBg1.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonBg1.addTarget(self, action: #selector(FeedProgramViewController.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        
        donebutton.action =  #selector(FeedProgramViewController.doneClick)
        
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(FeedProgramViewController.cancelClick)
        
        datePicker = buttons.4
        self.view.addSubview(buttonBg1)
    }
    @objc func doneClick() {
        
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 3{
            let dateFormatter2 = DateFormatter()
            //            dateFormatter2.calendar = Calendar(identifier: .gregorian)
            //            dateFormatter2.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter2.dateFormat=Constants.ddMMyyyStr
            lblDate.text = dateFormatter2.string(from: datePicker.date) as String
        }
        else{
            let dateFormatter2 = DateFormatter()
            //            dateFormatter2.calendar = Calendar(identifier: .gregorian)
            //            dateFormatter2.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter2.dateFormat=Constants.MMddyyyyStr
            lblDate.text = dateFormatter2.string(from: datePicker.date) as String
        }
        buttonBg1.removeFromSuperview()
    }
    @objc func cancelClick() {
        buttonBg1.removeFromSuperview()
    }
    
    @objc func buttonPressed() {
        buttonBg1.removeFromSuperview()
    }
    @IBAction func backBtnAction(sender: AnyObject) {
        btnTagsave = 2
        callSaveMethod(btnTagSave: btnTagsave)
    }
    
    @IBAction func cancelBtnAct(sender: AnyObject) {
        
        self.navigationController?.popViewController(animated:true)
    }
    @IBAction func coccidiosisControlBtnActoin(sender: AnyObject) {
        flag = 1
        self.view.endEditing(true)
        btnTag = 0
        
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt.titleLabel?.text == NSLocalizedString(Constants.coccidioStr, comment: "") {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        
        coccidiosisView.isHidden = false
        antiboticView.isHidden = true
        alterNativeView.isHidden = true
        myCotoxinBindersView.isHidden = true
        
        serviceDataHldArr = (UserDefaults.standard.value(forKey:"Molucule") as? NSArray)!
        //        ////print(serviceDataHldArr)
        
        if (cocciControlArrayfromServer.count == 0){
            self.callSaveMethod(commonAray: serviceDataHldArr,tag: btnTag)
        }
        
    }
    
    /***************************** Save Data in to DataBase ************************************************/
    
    func callSaveMethod( commonAray : NSArray , tag : Int) {
        CoreDataHandler().deleteAllData("MoleCuleFeed")
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let dict = commonAray[tag] as AnyObject
        
        let arrayMoleculeDetails = dict["MoleculeDetails"] as AnyObject
        
        
        for i in 0 ..< arrayMoleculeDetails.count {
            
            let tempDict = arrayMoleculeDetails.object(at:i) as AnyObject
            let mid = tempDict["MoleculeId"] as? Int
            let lngId =   tempDict["LanguageId"] as? Int
            let catId =  tempDict["FeedProgramCategoryId"] as? Int
            let desc =  tempDict["MoleculeDescription"] as? String
            CoreDataHandler().saveMoleCule(catId!, decscMolecule: desc!, moleculeId: mid!, lngId: lngId!)
        }
        
        if (tag == 0 ){
            
            cocciControlArrayfromServer =  CoreDataHandler().fetchMoleCuleLngId(lngId:lngId as NSNumber).mutableCopy() as! NSMutableArray
            print(cocciControlArrayfromServer)
        }
        else if (tag == 1){
            AlternativeArrayfromServer = CoreDataHandler().fetchMoleCuleLngId(lngId:lngId as NSNumber).mutableCopy() as! NSMutableArray
        }
        else if (tag == 2){
            AntiboticArrayfromServer = CoreDataHandler().fetchMoleCuleLngId(lngId:lngId as NSNumber).mutableCopy() as! NSMutableArray
        }
        else if (tag == 3){
            MyCoxtinBindersArrayfromServer = CoreDataHandler().fetchMoleCuleLngId(lngId:lngId as NSNumber).mutableCopy() as! NSMutableArray
        }
        else{
            serviceDataHldArrfromServer = CoreDataHandler().fetchMoleCuleLngId(lngId:lngId as NSNumber).mutableCopy() as! NSMutableArray
        }
    }
    /******* Create Custom TableView ************************************/
    func tableViewpop()  {
        
        buttonbg.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        buttonbg.isUserInteractionEnabled = true
        buttonbg.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        droperTableView.delegate = self
        droperTableView.dataSource = self
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.black.cgColor
        buttonbg.addSubview(droperTableView)
    }
    
    @objc func dismissPopUp() {
        buttonbg.removeFromSuperview()
    }
    
    func buttonPressed1() {
        buttonbg.removeFromSuperview()
    }
    // MARK:  IBACTION
    @IBAction func myCoxtinBtnAction(sender: AnyObject) {
        
        flag = 4
        self.view.endEditing(true)
        btnTag = 3
        
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt.titleLabel?.text == NSLocalizedString(Constants.mytoxinStr, comment: "") {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        coccidiosisView.isHidden = true
        antiboticView.isHidden = true
        alterNativeView.isHidden = true
        myCotoxinBindersView.isHidden = false
    }
    
    @IBAction func alternativeBtnAction(sender: AnyObject) {
        flag = 3
        self.view.endEditing(true)
        
        btnTag =  1
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt.titleLabel?.text == NSLocalizedString("Alternative", comment: "") {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        
        coccidiosisView.isHidden = true
        antiboticView.isHidden = true
        alterNativeView.isHidden = false
        myCotoxinBindersView.isHidden = true
        
    }
    
    @IBAction func antoboticBtnAction(sender: AnyObject) {
        flag = 2
        self.view.endEditing(true)
        
        btnTag =  2
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt.titleLabel?.text == NSLocalizedString("Antibiotic", comment: "") {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        
        coccidiosisView.isHidden = true
        antiboticView.isHidden = false
        alterNativeView.isHidden = true
        myCotoxinBindersView.isHidden = true
        
    }
    
    @IBAction func starterCheckBoxAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func growerCheckBoxAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func finisherCoccidiosisCheckBoxAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func wdCoccidiosisAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    
    @IBAction func starterDrinkngWaterAction(sender: AnyObject) {
        
        view.endEditing(true)
        btnTag = 0
        
        Allbuttonbg = 0
        buttonbg.removeFromSuperview()
        tableViewpop()
        if  Bundle.main.versionNumber > "7.5.1"
        {
            starterDosageTextField.text = appDelegateObj.selectStr
        }
        
        
        droperTableView.frame = CGRect(x: 183,y: 309,width: 237,height: 150)
        droperTableView.reloadData()
    }
    
    @IBAction func growerDrinkingWater(sender: AnyObject) {
        view.endEditing(true)
        btnTag = 0
        Allbuttonbg = 1
        buttonbg.removeFromSuperview()
        tableViewpop()
        if  Bundle.main.versionNumber > "7.5.1"
        {
            growerDosageCoccidiosisTEXT.text = appDelegateObj.selectStr
        }
        
        droperTableView.frame = CGRect(x: 183,y: 365,width: 237,height: 150)
        droperTableView.reloadData()
        
    }
    
    @IBAction func finisherDrinkingWaterAction(sender: AnyObject) {
        view.endEditing(true)
        btnTag = 0
        
        Allbuttonbg = 2
        buttonbg.removeFromSuperview()
        tableViewpop()
        if  Bundle.main.versionNumber > "7.5.1"
        {
            finisherDosageTxtField.text = appDelegateObj.selectStr
        }
        
        droperTableView.frame = CGRect(x: 183,y: 422,width: 237,height: 150)
        droperTableView.reloadData()
    }
    
    @IBAction func wdDrinkingWaterAction(sender: AnyObject) {
        view.endEditing(true)
        btnTag = 0
        
        Allbuttonbg = 3
        buttonbg.removeFromSuperview()
        tableViewpop()
        if  Bundle.main.versionNumber > "7.5.1"
        {
            wdDosageTextField.text =  appDelegateObj.selectStr
        }
        
        droperTableView.frame = CGRect(x: 183,y: 477,width: 237,height: 150)
        droperTableView.reloadData()
        
    }
    
    @IBAction func feedType5CoccidiosisA(sender: AnyObject) {
        btnTag = 0
        
        view.endEditing(true)
        Allbuttonbg = 40
        buttonbg.removeFromSuperview()
        tableViewpop()
        if  Bundle.main.versionNumber > "7.5.1"
        {
            feed5textField.text = appDelegateObj.selectStr
        }
        
        droperTableView.frame = CGRect(x: 183,y: 530,width: 237,height: 150)
        droperTableView.reloadData()
        
    }
    
    
    @IBAction func feedType6CoccidiosisA(sender: AnyObject) {
        view.endEditing(true)
        btnTag = 0
        
        Allbuttonbg = 50
        buttonbg.removeFromSuperview()
        tableViewpop()
        if  Bundle.main.versionNumber > "7.5.1"
        {
            feed6TextField.text = appDelegateObj.selectStr
        }
        
        droperTableView.frame = CGRect(x: 183,y: 580,width: 237,height: 150)
        droperTableView.reloadData()
    }
    
    
    @IBAction func coccidiosisVaccineAction(sender: AnyObject) {
        view.endEditing(true)
        btnTag = 4
        btnCocoTagetPopp()
        
        droperTableView.frame = CGRect(x: 450,y: 455,width: 245,height: 150)
        droperTableView.reloadData()
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func targetWeightDrinkingWaterAction(sender: AnyObject) {
        view.endEditing(true)
        
        btnTag = 5
        btnCocoTagetPopp()
        droperTableView.frame = CGRect(x: 420,y: 410,width: 245,height: 150)
        droperTableView.reloadData()
    }
    
    @IBAction func uperTapView(sender: AnyObject) {
        
        coccidiosisView.endEditing(true)
        antiboticView.endEditing(true)
        alterNativeView.endEditing(true)
        myCotoxinBindersView.endEditing(true)
        uprTapViewOutlet.endEditing(true)
        
        
    }
    
    
    @IBAction func antiboticStarterCheckBoxAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func antiboticGrowerAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func antiboticFinisherAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func antiboticWDAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    
    @IBAction func antiFinisherDrinkingWater(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 6
        buttonbg.removeFromSuperview()
        tableViewpop()
        
        droperTableView.frame = CGRect(x: 220,y: 432,width: 245,height: 150)
        
        droperTableView.reloadData()
        
    }
    
    
    @IBAction func antiWdDrinkingWater(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 7
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 220,y: 492,width: 245,height: 150)
        
        droperTableView.reloadData()
    }
    
    @IBAction func alternativeStartrAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func altrnativeGrowerAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func alternativeFinisherAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func alternativeWdAction(sender: AnyObject) {print(appDelegateObj.testFuntion())}
    
    @IBAction func alternativeStarterMoleculeAction(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 8
        buttonbg.removeFromSuperview()
        tableViewpop()
        
        droperTableView.frame = CGRect(x: 220,y: 318,width: 245,height: 150)
        droperTableView.reloadData()
    }
    
    
    @IBAction func alternativeGrowerMoleculeAction(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 9
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 220,y: 375,width: 245,height: 150)
        
        droperTableView.reloadData()
    }
    
    
    @IBAction func alternativeFinisherMoleculeAction(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 10
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 220,y: 432,width: 245,height: 150)
        
        droperTableView.reloadData()
        
    }
    
    @IBAction func alternativeWDMoleculeAction(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 11
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 220,y: 492,width: 245,height: 150)
        
        droperTableView.reloadData()
    }
    
    @IBAction func myStarterDrinkingWaterAction(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 12
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 220,y: 318,width: 245,height: 150)
        
        droperTableView.reloadData()
    }
    
    @IBAction func myGrowerDrinkingWaterAction(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 13
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 220,y: 375,width: 245,height: 150)
        
        droperTableView.reloadData()
    }
    
    @IBAction func myFinisherDrinkingWaterAction(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 14
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 220,y: 432,width: 245,height: 150)
        droperTableView.reloadData()
    }
    @IBAction func myWDDrinkingWaterAction(sender: AnyObject) {
        view.endEditing(true)
        
        Allbuttonbg = 15
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 220,y: 492,width: 245,height: 150)
        
        droperTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func tapOnView(sender: AnyObject) {
        coccidiosisView.endEditing(true)
    }
    @IBAction func tapOnViewAntobotic(sender: AnyObject) {
        antiboticView.endEditing(true)
    }
    @IBAction func tapOnViewAlternative(sender: AnyObject) {
        alterNativeView.endEditing(true)
    }
    @IBAction func tapOnViewMyCotoxin(sender: AnyObject) {
        myCotoxinBindersView.endEditing(true)
    }
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        
        btnTagsave = 1
        isClickOnAnyField = true
        callSaveMethod(btnTagSave: btnTagsave)
        
        
        let allCocciControl = CoreDataHandler().fetchAllCocciControlviaPostingid(postingId as NSNumber)
        
        let outerDict = NSMutableDictionary()
        
        let FinalArray = NSMutableArray()
        
        for i in 0..<allCocciControl.count
                
        {
            
            let mainDict = NSMutableDictionary()
            
            let cocciControl = allCocciControl.object(at:i) as! CoccidiosisControlFeed
            
            let coccidiosisVaccine = cocciControl.coccidiosisVaccine
            
            let dosage = cocciControl.dosage
            
            let coccifeedId = cocciControl.feedId
            
            let feedProgram = cocciControl.feedProgram
            
            
            let fromDays = cocciControl.fromDays
            
            let molecule = cocciControl.molecule
            
            let toDays = cocciControl.toDays
            
            let moleculeId = cocciControl.moleculeId
            
            let cocoId = cocciControl.coccidiosisVaccineId
            let feedType = cocciControl.feedType
            
            mainDict.setValue(coccidiosisVaccine, forKey: "coccidiosisVaccine")
            
            mainDict.setValue(dosage, forKey: "dose")
            
            mainDict.setValue(coccifeedId, forKey: "feedId")
            
            mainDict.setValue(feedProgram, forKey: "feedName")
            
            mainDict.setValue(fromDays, forKey: "durationFrom")
            
            mainDict.setValue(molecule, forKey: "molecule")
            
            mainDict.setValue(toDays, forKey: "durationTo")
            
            mainDict.setValue(5, forKey: "feedProgramCategoryId")
            
            mainDict.setValue(moleculeId, forKey: "moleculeId")
            
            mainDict.setValue(cocoId, forKey: "cocciVaccineId")
            mainDict.setValue(feedType, forKey: "feedType")
            
            FinalArray.add(mainDict)
            
        }
        
        let fetchAntibotic = CoreDataHandler().fetchAntiboticViaPostingId(postingId as NSNumber)
        
        
        for i in 0..<fetchAntibotic.count
                
        {
            
            let mainDict = NSMutableDictionary()
            
            let antiboticFeed = fetchAntibotic.object(at:i) as! AntiboticFeed
            
            
            let dosage = antiboticFeed.dosage
            
            let antibioticFeedId = antiboticFeed.feedId
            
            let feedProgram = antiboticFeed.feedProgram
            
            
            let fromDays = antiboticFeed.fromDays
            
            let molecule = antiboticFeed.molecule
            
            let toDays = antiboticFeed.toDays
            let feedType = antiboticFeed.feedType
            
            
            mainDict.setValue(dosage, forKey: "dose")
            
            mainDict.setValue(antibioticFeedId, forKey: "feedId")
            
            mainDict.setValue(feedProgram, forKey: "feedName")
            
            mainDict.setValue(fromDays, forKey: "durationFrom")
            
            mainDict.setValue(molecule, forKey: "molecule")
            
            mainDict.setValue(toDays, forKey: "durationTo")
            
            mainDict.setValue(12, forKey: "feedProgramCategoryId")
            
            mainDict.setValue(0, forKey: "moleculeId")
            mainDict.setValue(feedType, forKey: "feedType")
            
            FinalArray.add(mainDict)
        }
        
        
        let fetchAlternative = CoreDataHandler().fetchAlternativeFeedPostingid(postingId as NSNumber)
        
        for i in 0..<fetchAlternative.count
                
        {
            
            let mainDict = NSMutableDictionary()
            
            let antiboticFeed = fetchAlternative.object(at:i) as! AlternativeFeed
                        
            let dosage = antiboticFeed.dosage
            
            let antibioticFeedId = antiboticFeed.feedId
            
            let feedProgram = antiboticFeed.feedProgram
                        
            let fromDays = antiboticFeed.fromDays
            
            
            let molecule = antiboticFeed.molecule
            
            let toDays = antiboticFeed.toDays
            let feedType = antiboticFeed.feedType
            
            mainDict.setValue(dosage, forKey: "dose")
            
            mainDict.setValue(antibioticFeedId, forKey: "feedId")
            
            mainDict.setValue(feedProgram, forKey: "feedName")
            
            mainDict.setValue(fromDays, forKey: "durationFrom")
            
            mainDict.setValue(molecule, forKey: "molecule")
            
            mainDict.setValue(toDays, forKey: "durationTo")
            
            mainDict.setValue(6, forKey: "feedProgramCategoryId")
            
            mainDict.setValue(0, forKey: "moleculeId")
            mainDict.setValue(feedType, forKey: "feedType")
            
            FinalArray.add(mainDict)
            
        }
        
        let fetchMyBinde = CoreDataHandler().fetchMyBindersViaPostingId(postingId as NSNumber)
        
        for i in 0..<fetchMyBinde.count
                
        {
            
            let mainDict = NSMutableDictionary()
            
            let antiboticFeed = fetchMyBinde.object(at:i) as! MyCotoxinBindersFeed
            
            let dosage = antiboticFeed.dosage
            let antibioticFeedId = antiboticFeed.feedId
            let feedProgram = antiboticFeed.feedProgram
            let fromDays = antiboticFeed.fromDays
            
            let molecule = antiboticFeed.molecule
            
            let toDays = antiboticFeed.toDays
            let feedType = antiboticFeed.feedType
            mainDict.setValue(dosage, forKey: "dose")
            
            mainDict.setValue(antibioticFeedId, forKey: "feedId")
            
            mainDict.setValue(feedProgram, forKey: "feedName")
            
            mainDict.setValue(fromDays, forKey: "durationFrom")
            
            mainDict.setValue(molecule, forKey: "molecule")
            
            mainDict.setValue(toDays, forKey: "durationTo")
            
            mainDict.setValue(18, forKey: "feedProgramCategoryId")
            
            mainDict.setValue(0, forKey: "moleculeId")
            mainDict.setValue(feedType, forKey: "feedType")
            
            
            FinalArray.add(mainDict)
            
        }
        
        outerDict.setValue(postingId as NSNumber, forKey: "sessionId")
        
        let udid = UserDefaults.standard.value(forKey:"ApplicationIdentifier")!
        let sessionGUID1 = "iOS" + (udid as! String) +  "_" + String(describing: postingId)
        outerDict.setValue(sessionGUID1, forKey: "deviceSessionId")
        
        let id = UserDefaults.standard.integer(forKey:("Id"))
        
        outerDict.setValue(id, forKey: "UserId")
        
        outerDict.setValue(false, forKey: "finalized")
        
        outerDict.setValue(FinalArray, forKey: "feedProgramDetail")
       
        
    }
    
    
    @IBAction func toStarterTextField(sender: AnyObject) {
        print("toStarterTextField")
    }
    
    @IBAction func fromStarterTextField(sender: AnyObject) {
        
        if antiFromDurationFirstTextField.text?.isEmpty == true {
            
            antiToDurationFirstTextField.isUserInteractionEnabled = true
            
        }
        
    }
    
    
    @IBAction func toAntiboticSecondTextField(sender: AnyObject) {
        debugPrint("toAntiboticSecondTextField")
    }
    
    @IBAction func toAntiboticThreeTextField(sender: AnyObject) {
        debugPrint("toAntiboticThreeTextField")
    }
    
    @IBAction func toAntiboticFourTextField(sender: AnyObject) {
        debugPrint("toAntiboticFourTextField")
    }
    
    @IBAction func toAntiboticFiveTextField(sender: AnyObject) {
        debugPrint("toAntiboticFiveTextField")
    }
    
    @IBAction func toAntiboticSixTextField(sender: AnyObject) {
        debugPrint("toAntiboticSixTextField")
    }
    
    
    
    @IBAction func syncBttnAction(sender: AnyObject) {
        let feedProgramWithIdArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        let farms = CoreDataHandler().fetchNecropsystep1neccIdFeedProgram(postingId as NSNumber)
        if feedProgramWithIdArray.count < 1  {
            // Create the alert controller
            if feedProgramTextField.text == ""{
                Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: NSLocalizedString(feedPrgramvalidationMsg, comment: ""))
                return
            }
            
            else if farms.count > 0 {
                self.showExitAlertWith(msg: "Please connect \(farms.count) farm(s) with feed program. Do you want not do it now?", tag: 10)
                
                return
            }
            else{
                self.showExitAlertWith(msg: "Do you want to add more information to this page?", tag: 10)
                return
                
            }
            
        }
        else if farms.count > 0{
            self.showExitAlertWith(msg: "Please connect \(farms.count) farm(s) with feed program. Do you want not do it now?", tag: 10)
        }
        else{
            if self.allSessionArr().count > 0
            {
                if ConnectionManager.shared.hasConnectivity() {
                    
                    btnTagsave = 2
                    callSaveMethod(btnTagSave: btnTagsave)
                    
                    Helper.showGlobalProgressHUDWithTitle(self.view,title : NSLocalizedString("Data syncing...", comment: ""))
                    self.callSyncApi()
                }
                else {
                    
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineDataMsg, comment: ""))
                }
            } else{
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
            }
            
        }
    }
    
    
    @IBAction func cocciDosageFeed1(_ sender: Any) {
        
        if  Bundle.main.versionNumber > "7.5.1"
        {
            if coccidsisStartrDrinking.text == appDelegateObj.selectStr
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(moleculeFeedMsg, comment: ""))
                return
            }
            
            fetchDosage = CoreDataHandler().fetchDossgaeWithMoleculeId(firstMolID as NSNumber)
            
            if fetchDosage.count == 0
            {
                fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
            }
            
        }
        else
        {
            
            fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        }
        
        
        view.endEditing(true)
        btnTag = 101
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 309,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    
    @IBAction func cocciDosageFeed2(_ sender: Any) {
        
        if  Bundle.main.versionNumber > "7.5.1"
        {
            
            if coccidsisGrowerDrinking.text == appDelegateObj.selectStr
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(moleculeFeedMsg, comment: ""))
                return
            }
            fetchDosage = CoreDataHandler().fetchDossgaeWithMoleculeId(secoundMolID as NSNumber)
            if fetchDosage.count == 0
            {
                fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
            }
            
        }
        else
        {
            
            fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        }
        view.endEditing(true)
        btnTag = 102
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 365,width: 230,height: 150)
        droperTableView.reloadData()
    }
    
    @IBAction func cocciDosageFeed3(_ sender: Any) {
        
        if  Bundle.main.versionNumber > "7.5.1"
        {
            if cocciFinisherDrinkingWater.text == appDelegateObj.selectStr
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(moleculeFeedMsg, comment: ""))
                return
            }
            fetchDosage = CoreDataHandler().fetchDossgaeWithMoleculeId(thirdMolID as NSNumber)
            if fetchDosage.count == 0
            {
                fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
            }
            
        }
        else
        {
            
            fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        }
        view.endEditing(true)
        btnTag = 103
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 421,width: 230,height: 150)
        droperTableView.reloadData()
        
        
        
    }
    
    @IBAction func cocciDosageFeed4(_ sender: Any) {
        
        
        if  Bundle.main.versionNumber > "7.5.1"
        {
            if coccidiosisWdDrinking.text == appDelegateObj.selectStr
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(moleculeFeedMsg, comment: ""))
                return
            }
            fetchDosage = CoreDataHandler().fetchDossgaeWithMoleculeId(fourthMolID as NSNumber)
            if fetchDosage.count == 0
            {
                fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
            }
            
        }
        else
        {
            
            fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        }
        view.endEditing(true)
        btnTag = 104
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 477,width: 230,height: 150)
        droperTableView.reloadData()
        
        
    }
    
    @IBAction func cocciDosageFeed5(_ sender: Any) {
        
        
        if  Bundle.main.versionNumber > "7.5.1"
        {
            if fivthMoleculelBL.text == appDelegateObj.selectStr
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(moleculeFeedMsg, comment: ""))
                return
            }
            fetchDosage = CoreDataHandler().fetchDossgaeWithMoleculeId(fifthMolID as NSNumber)
            if fetchDosage.count == 0
            {
                fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
            }
            
        }
        else
        {
            
            fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        }
        
        view.endEditing(true)
        btnTag = 105
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 533,width: 230,height: 150)
        droperTableView.reloadData()
        
        
    }
    
    @IBAction func cocciDosageFeed6(_ sender: Any) {
        
        if  Bundle.main.versionNumber > "7.5.1"
        {
            if sixthMoleculeLbl.text == appDelegateObj.selectStr
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(moleculeFeedMsg, comment: ""))
                return
            }
            fetchDosage = CoreDataHandler().fetchDossgaeWithMoleculeId(sixthMolID as NSNumber)
            if fetchDosage.count == 0
            {
                fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
            }
            
        }
        else
        {
            fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        }
        
        view.endEditing(true)
        btnTag = 106
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 589,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    
    @IBAction func alternativeDosageFeed1(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        btnTag = 111
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 320,width: 230,height: 150)
        droperTableView.reloadData()
        
        
    }
    @IBAction func alternativeDosageFeed2(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        btnTag = 112
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 376,width: 230,height: 150)
        droperTableView.reloadData()
        
        
    }
    @IBAction func alternativeDosageFeed3(_ sender: Any) {
        view.endEditing(true)
        btnTag = 113
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 432,width: 230,height: 150)
        droperTableView.reloadData()
        
        
    }
    @IBAction func alternativeDosageFeed4(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        btnTag = 114
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 489,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func alternativeDosageFeed5(_ sender: Any) {
        view.endEditing(true)
        btnTag = 115
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 544,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func alternativeDosageFeed6(_ sender: Any) {
        view.endEditing(true)
        btnTag = 116
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 600,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    
    @IBAction func coxtinDosageFeed1(_ sender: Any) {
        view.endEditing(true)
        btnTag = 121
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 320,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func coxtinDosageFeed2(_ sender: Any) {
        view.endEditing(true)
        btnTag = 122
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 376,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func coxtineDosageFeed3(_ sender: Any) {
        view.endEditing(true)
        btnTag = 123
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 432,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func coxtinDosageFeed4(_ sender: Any) {
        view.endEditing(true)
        btnTag = 124
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 489,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func coxtinDosageFeed5(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        btnTag = 125
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 544,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func coxtinDosageFeed6(_ sender: Any) {
        view.endEditing(true)
        btnTag = 126
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 445,y: 600,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    
    @IBAction func antiboticDosageFeed1(_ sender: Any) {
        view.endEditing(true)
        btnTag = 131
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 443,y: 320,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func antiboticDosageFeed2(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        btnTag = 132
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 443,y: 376,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func antiboticDosageFeed3(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        
        btnTag = 133
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 443,y: 438,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func antiboticDosageFeed4(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        btnTag = 134
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 443,y: 498,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func antiboticDosageFeed5(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        btnTag = 135
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 443,y: 559,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    @IBAction func antiboticDosageFeed6(_ sender: Any) {
        view.endEditing(true)
        fetchDosage = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetDosage")
        
        btnTag = 136
        buttonbg.removeFromSuperview()
        tableViewpop()
        droperTableView.frame = CGRect(x: 443,y: 610,width: 230,height: 150)
        droperTableView.reloadData()
        
    }
    
    // MARK: - METHODS AND FUNCTIONS
    
    func showExitAlertWith(msg: String,tag: Int) {
        
        exitPopUP = popUP.loadFromNibNamed("popUP") as? popUP
        exitPopUP.lblFedPrgram.text = msg
        exitPopUP.tag = tag
        exitPopUP.lblFedPrgram.textAlignment = .center
        exitPopUP.delegatenEW = self
        exitPopUP.center = self.view.center
        self.view.addSubview(exitPopUP)
        
    }
    func callSyncApi()
    {
        objApiSync.feedprogram()
    }
    
    func failWithError(statusCode:Int)
    {
        
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            
            if languageId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
                
            } else if languageId == 3 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alerte", comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
                
            }
        }
    }
    func failWithErrorInternal(){
        
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection. Please try again!", comment: ""))
    }
    
    func didFinishApi() {
        
        self.printSyncLblCount()
        
        Helper.dismissGlobalHUD(self.view)
        if (exitPopUP != nil){
            if exitPopUP.tag == 10{
                exitPopUP.tag = 11
                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
                self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(syncCompletedMs, comment: ""))
            }
            else{
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(syncCompletedMs, comment: ""))
                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
                self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
                
            }
        }
        else{
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(syncCompletedMs, comment: ""))
        }
    }
    func failWithInternetConnection()
    {
        
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineDataMsg, comment: ""))
    }
    
    func printSyncLblCount()
    {
        syncFinalizedCount.text = String(self.allSessionArr().count)
    }
    func btnCocoTagetPopp(){
        
        buttoCocodaciVac.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        buttoCocodaciVac.addTarget(self, action: #selector(FeedProgramViewController.buttonCocotarget), for: .touchUpInside)
        buttoCocodaciVac.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttoCocodaciVac)
        
        droperTableView.delegate = self
        droperTableView.dataSource = self
        
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.black.cgColor
        buttoCocodaciVac.addSubview(droperTableView)
    }
    
    @objc func buttonCocotarget(){
        btnTag = 0
        buttoCocodaciVac.removeFromSuperview()
    }
    fileprivate func saveAlternateDB(_ status: Bool) {
        if status == true {
            
            self.saveMyCoxtinDatabase(feedId: self.feedPostingId,postingId: Int(self.postingId), completion: { (status) -> Void in
                debugPrint(postingId)
            })
        }
    }
    
    fileprivate func saveCocooiControleDB(_ status: Bool) {
        if status == true {
            
            self.saveAntibioticDatabase(feedId: self.feedPostingId,postingId: Int(self.postingId),  completion: { (status) -> Void in
                if status == true {
                    self.saveAlternativeDatabase(feedId: self.feedPostingId,postingId: Int(self.postingId), completion: { (status) -> Void in
                        saveAlternateDB(status)
                    })
                }
            })
        }
    }
    
    fileprivate func saveClickedFeedProgramData() {
        self.saveFeedProgrameInDatabase(feedId: feedPostingId,postingId: Int(postingId as NSNumber) ,completion: { (status) -> Void in
            
            if status == true {
                
                self.saveCoccoiControlDatabase(feedId: self.feedPostingId,postingId: Int(self.postingId), completion: { (status) -> Void in
                    
                    saveCocooiControleDB(status)
                })
            }
        })
    }
    
    fileprivate func handleSaveAlternativeDB(_ status: Bool, feedexist: Int) {
        guard status else { return }

        self.saveMyCoxtinDatabase(feedId: feedexist, postingId: Int(self.postingId)) { status in
            if status, self.postingIdFromExistingNavigate == "Exting" {
                CoreDataHandler().updateisSyncTrueOnPostingSession(self.postingId)
            }
        }
    }

    
    fileprivate func handleSaveCoccoiControlDatabase(_ status: Bool,feedexist:Int) {
        if status == true {
            self.saveAntibioticDatabase(feedId: feedexist ,postingId: Int(self.postingId), completion: { (status) -> Void in
                if status == true {
                    self.saveAlternativeDatabase(feedId: feedexist ,postingId: Int(self.postingId), completion: { (status) -> Void in
                        handleSaveAlternativeDB(status,feedexist: feedexist)
                    })
                }
            })
        }
    }
    
    fileprivate func saveExistedSessionFeedProgramData() {
        var feedexist = Int()
        if feedProgadd == "ExtingFeeed" {
            feedexist = feedId
        } else {
            feedexist = self.FeedIdFromExisting
        }
        
        self.saveFeedProgrameInDatabase(feedId: feedexist ,postingId: Int(self.postingId), completion: { (status) -> Void in
            
            if status == true {
                
                self.saveCoccoiControlDatabase(feedId: feedexist,postingId: Int(self.postingId), completion: { (status) -> Void in
                    handleSaveCoccoiControlDatabase(status, feedexist: feedexist)
                })
            }
        })
    }
    
    fileprivate func handleSaveMyCoxtinDatabase(_ status: Bool) {
        if status == true {
            self.saveMyCoxtinDatabase(feedId: self.feedId,postingId: Int(self.postingId), completion: { (status) -> Void in
                if status == true {
                    UserDefaults.standard.set(false, forKey: "isNewPostingId")
                    UserDefaults.standard.synchronize()
                }
            })
        }
    }
    
    fileprivate func handleSaveCoccoiAPIResponse(_ status: Bool) {
        if status == true {
            
            self.saveAntibioticDatabase(feedId: self.feedId,postingId: Int(self.postingId), completion: { (status) -> Void in
                if status == true {
                    self.saveAlternativeDatabase(feedId: self.feedId,postingId: Int(self.postingId), completion: { (status) -> Void in
                        handleSaveMyCoxtinDatabase(status)
                    })
                }
            })
        }
    }
    
    fileprivate func saveUnlinkedSessionFeedData() {
        if UserDefaults.standard.bool(forKey:"Unlinked") == true {
            postingId = UserDefaults.standard.integer(forKey:"necUnLinked") as NSNumber
            
        } else {
            postingId = UserDefaults.standard.integer(forKey: "postingId") as NSNumber
        }
        
        self.saveFeedProgrameInDatabase(feedId: feedId,postingId: Int(self.postingId), completion: { (status) -> Void in
            
            if status == true {
                
                self.saveCoccoiControlDatabase(feedId: self.feedId,postingId: Int(self.postingId), completion: { (status) -> Void in
                    self.handleSaveCoccoiAPIResponse(status)
                })
            }})
    }
    
    fileprivate func handleStrYesPop(_ feed: inout Int, _ feeid: Int) {
        if (strYesPop == NSLocalizedString("Yes", comment: "")) {
            feed = feeid
        } else {
            if (navigatePostingsession == "PostingFeedProgram") {
                feed = feeid
            } else {
                feed = feeid-1
            }
        }
    }
    
    fileprivate func handleBtnSaveTag(_ btnTagSave: Int, _ feed: inout Int) {
        if (btnTagSave == 2) {
            let feeid  = UserDefaults.standard.integer(forKey:("feedId"))
            
            if (feeid == 0 ) {
                UserDefaults.standard.set("feed0", forKey: "feed0")
                UserDefaults.standard.synchronize()
                feed = 0
            } else {
                handleStrYesPop(&feed, feeid)
                UserDefaults.standard.set(" ", forKey: "feed0")
                UserDefaults.standard.synchronize()
            }
            UserDefaults.standard.set(feed, forKey: "feedId")
            UserDefaults.standard.set("back", forKey: "back")
            UserDefaults.standard.synchronize()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.isFeedProgramClick = true
            appDelegate.sendFeedVariable = "Feed"
            appDelegate.strImpFedd = feedImpandMetric
            appDelegate.newColor = datCount + 1
            
            UserDefaults.standard.set(true, forKey: "isNewPostingId")
            UserDefaults.standard.synchronize()
            
            self.navigationController?.popViewController(animated:true)
            UserDefaults.standard.set(0, forKey: "isBackWithoutFedd")
            UserDefaults.standard.synchronize()
        } else {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(feedPrgramvalidationMsg, comment: ""))
        }
    }
    
    fileprivate func handleExitPopup() {
        if self.exitPopUP.tag == 10 {
            if self.allSessionArr().count > 0 {
                if ConnectionManager.shared.hasConnectivity() {
                    Helper.showGlobalProgressHUDWithTitle(self.view,title : NSLocalizedString("Data syncing...", comment: ""))
                    self.callSyncApi()
                } else {
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineDataMsg, comment: ""))
                }
            } else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
            }
            
        } else if self.exitPopUP.tag == 20 {
            self.clickHelp()
        } else {
            self.navigationController?.popViewController(animated:true)
        }
    }
    
    fileprivate func handleIsClickedAnyField() {
        if (isClickOnAnyField == true) {
            isClickOnAnyField = false
            if (navigatePostingsession == "PostingFeedProgram") {
                saveClickedFeedProgramData()
            } else if postingIdFromExistingNavigate == "Exting" {
                saveExistedSessionFeedProgramData()
            } else {
                saveUnlinkedSessionFeedData()
            }
        }
    }
    
    fileprivate func handleBtnTagsave() {
        if btnTagsave == 1 {
            self.clickHelpPopUp()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.isFeedProgramClick = true
            appDelegate.sendFeedVariable = "Feed"
            appDelegate.strImpFedd = feedImpandMetric
            appDelegate.newColor = datCount + 1
            if (exitPopUP != nil){
                self.handleExitPopup()
            } else {
                self.navigationController?.popViewController(animated:true)}
        }
    }
    
    func callSaveMethod (btnTagSave : Int) {
        var feed = Int ()
        var trimmedString = feedProgramTextField.text!.trimmingCharacters(in: .whitespaces)
        trimmedString = trimmedString.replacingOccurrences(of: ".", with: "", options:
                                                            NSString.CompareOptions.literal, range: nil)
        feedProgramTextField.text = trimmedString
        if (trimmedString == "" ) {
            handleBtnSaveTag(btnTagSave, &feed)
        } else {
            if (btnTagSave == 2) {
                bckButtonCall()
            }
            handleIsClickedAnyField()
            
            handleBtnTagsave()
            UserDefaults.standard.set("notback", forKey: "back")
            UserDefaults.standard.set(1, forKey: "isBackWithoutFedd")
            UserDefaults.standard.synchronize()
        }
    }
    
    func saveFeedProgrameInDatabase(feedId : Int,postingId :Int, completion: (_ status: Bool) -> Void) {
        
        var tempArr = CoreDataHandler().FetchFeedProgramAll()
        
        feedProgramArray = tempArr.mutableCopy() as! NSMutableArray
        
        if feedProgramArray.count == 0 {
            
            
            
            let feedData = chickenCoreDataHandlerModels.saveChickenFeedProgramData(postingId: postingId as NSNumber,
                                           sessionId: 1,
                                           feedProgrameName: feedProgramTextField.text!,
                                           feedId: feedId as NSNumber,
                                           dbArray: feedProgramArray,
                                           index: 0,
                                           formName: addFarmSelectLbl.text!,
                                           isSync: true,
                                           lngId: languageId as NSNumber)
            
            CoreDataHandler().SaveFeedProgram(feedData)
            
            
            CoreDataHandler().updateisSyncTrueOnPostingSession(postingId as NSNumber)
        }
        else {
            
            if navigatePostingsession == "PostingFeedProgram"{
                
                CoreDataHandler().updateFeedProgram(feedId as NSNumber, isSync: true, feedProgrameName: feedProgramTextField.text!, formName: addFarmSelectLbl.text!)
                
                
                CoreDataHandler().updateisSyncTrueOnPostingSession(postingId as NSNumber)
            }
            
            else if postingIdFromExistingNavigate == "Exting"{
                if   feedProgadd == "ExtingFeeed"{
                    
                    feedProgramArray.removeAllObjects()
                                        
                    let feedData = chickenCoreDataHandlerModels.saveChickenFeedProgramData(postingId: postingId as NSNumber,
                                                                                           sessionId: 1,
                                                                                           feedProgrameName: feedProgramTextField.text!,
                                                                                           feedId: feedId as NSNumber,
                                                                                           dbArray: feedProgramArray,
                                                                                           index: feedId,
                                                                                           formName: addFarmSelectLbl.text!,
                                                                                           isSync: true,
                                                                                           lngId: languageId as NSNumber)
                    
                    CoreDataHandler().SaveFeedProgram(feedData)
                    
                    
                    
                    CoreDataHandler().updateisSyncTrueOnPostingSession(postingId as NSNumber)
                }
                else{
                    CoreDataHandler().updateFeedProgram(feedId as NSNumber, isSync: true, feedProgrameName: feedProgramTextField.text!, formName: addFarmSelectLbl.text!)
                    CoreDataHandler().updateisSyncTrueOnPostingSession(postingId as NSNumber)
                    CoreDataHandler().updateFeddProgramInStep1(postingId as NSNumber, feedname: feedProgramTextField.text!, feedId: feedId as NSNumber)
                    CoreDataHandler().updateisSyncOnAllCocciControlviaFeedProgram(postingId as NSNumber , feedId : feedId as NSNumber,feedProgram:feedProgramTextField.text!)
                    CoreDataHandler().updateisSyncOnMyCotxinViaFeedProgram(postingId: postingId as NSNumber, feedId: feedId as NSNumber, feedProgram: feedProgramTextField.text!)
                    CoreDataHandler().updateisSyncOnAlterNativeViaFeedProgram(postingId: postingId as NSNumber, feedId:  feedId as NSNumber, feedProgram: feedProgramTextField.text!)
                    CoreDataHandler().updateisSyncOnAntiboticViaFeedProgram(postingId: postingId as NSNumber, feedId: feedId as NSNumber, feedProgram: feedProgramTextField.text!)
                }
            }
            
            else{
                
                feedProgramArray.removeAllObjects()
                                        
                let feedData = chickenCoreDataHandlerModels.saveChickenFeedProgramData( postingId: postingId as NSNumber,
                                                                                                sessionId: 1,
                                                                                                feedProgrameName: feedProgramTextField.text!,
                                                                                                feedId: feedId as NSNumber,
                                                                                                dbArray: feedProgramArray,
                                                                                                index: feedId,
                                                                                                formName: addFarmSelectLbl.text!,
                                                                                                isSync: true,
                                                                                                lngId: languageId as NSNumber
                                                                                               )
                        
                        CoreDataHandler().SaveFeedProgram(feedData)
                
                
                CoreDataHandler().updateisSyncTrueOnPostingSession(postingId as NSNumber)
            }
            
        }
        
        
        completion (true)
    }
    
    fileprivate func handleSaveCoccoiControlDatabaseCase0(_ postingId: Int, _ i: Int, _ feedId: Int) {
        if coccidsisStartrDrinking.text == NSLocalizedString(appDelegateObj.selectStr, comment: ""){
            coccidsisStartrDrinking.text = ""
        }
        if languageId == 4 {
            
            let coccidiosisData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: coccidsisStartrDrinking.text ?? "",
                dosage: cocciDosFirstTextField.text ?? "",
                fromDays: FromstarterDurationTextField.text ?? "",
                toDays: toStarterTextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",  // You can update this if needed
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeOne,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: firstMolID
            )
            
            CoreDataHandler().saveCoccoiControlDatabase(coccidiosisData)
        } else {
            let cocciData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: coccidsisStartrDrinking.text ?? "",
                dosage: starterDosageTextField.text ?? "",
                fromDays: FromstarterDurationTextField.text ?? "",
                toDays: toStarterTextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeOne,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: firstMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(cocciData)
        }
    }
    
    fileprivate func handleSaveCoccoiControlDatabaseCase1(_ postingId: Int, _ i: Int, _ feedId: Int) {
        if coccidsisGrowerDrinking.text == NSLocalizedString(appDelegateObj.selectStr, comment: ""){
            coccidsisGrowerDrinking.text = ""
        }
        if languageId == 4 {
            let cocciData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: coccidsisGrowerDrinking.text ?? "",
                dosage: cocciDosSecTextField.text ?? "",
                fromDays: FromGrowerTextField.text ?? "",
                toDays: toGrowerTextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeTwo,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: secoundMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(cocciData)
        } else {
            let growerCocciData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: coccidsisGrowerDrinking.text ?? "",
                dosage: growerDosageCoccidiosisTEXT.text ?? "",
                fromDays: FromGrowerTextField.text ?? "",
                toDays: toGrowerTextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeTwo,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: secoundMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(growerCocciData)
        }
    }
    
    fileprivate func handleSaveCoccoiControlDatabaseCase2(_ postingId: Int, _ i: Int, _ feedId: Int) {
        if cocciFinisherDrinkingWater.text == NSLocalizedString(appDelegateObj.selectStr, comment: ""){
            cocciFinisherDrinkingWater.text = ""
        }
        if languageId == 4 {
            let finisherCocciData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: cocciFinisherDrinkingWater.text ?? "",
                dosage: cocciDosThrdTextField.text ?? "",
                fromDays: fromFinisherTextField.text ?? "",
                toDays: toFinisherTextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeThree,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: thirdMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(finisherCocciData)
        } else {
            let finisherData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: cocciFinisherDrinkingWater.text ?? "",
                dosage: finisherDosageTxtField.text ?? "",
                fromDays: fromFinisherTextField.text ?? "",
                toDays: toFinisherTextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeThree,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: thirdMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(finisherData)
        }
    }
    
    fileprivate func handleSaveCoccoiControlDatabaseCase3(_ postingId: Int, _ i: Int, _ feedId: Int) {
        if coccidiosisWdDrinking.text == NSLocalizedString(appDelegateObj.selectStr, comment: ""){
            coccidiosisWdDrinking.text = ""
        }
        if languageId == 4 {
            let wdData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: coccidiosisWdDrinking.text ?? "",
                dosage: cocciDosFourTextField.text ?? "",
                fromDays: fromWDtextField.text ?? "",
                toDays: toWdTextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeFour,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: fourthMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(wdData)

        } else {
            let wdData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: coccidiosisWdDrinking.text ?? "",
                dosage: wdDosageTextField.text ?? "",
                fromDays: from5TextField.text ?? "",
                toDays: toWdTextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeFour,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: fourthMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(wdData)
        }
    }
    
    fileprivate func handleSaveCoccoiControlDatabaseCase4(_ postingId: Int, _ i: Int, _ feedId: Int) {
        if fivthMoleculelBL.text == NSLocalizedString(appDelegateObj.selectStr, comment: ""){
            fivthMoleculelBL.text = ""
        }
        if languageId == 4 {
            let fifthMoleculeData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: fivthMoleculelBL.text ?? "",
                dosage: cocciDosFiveTextField.text ?? "",
                fromDays: from5TextField.text ?? "",
                toDays: toFeed5TextFeidl.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeFive,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: fifthMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(fifthMoleculeData)
            
        } else {
            let fifthMoleculeData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: fivthMoleculelBL.text ?? "",
                dosage: feed5textField.text ?? "",
                fromDays: from5TextField.text ?? "",
                toDays: toFeed5TextFeidl.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeFive,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: fifthMolID
            )
            
            CoreDataHandler().saveCoccoiControlDatabase(fifthMoleculeData)

        }
    }
    
    fileprivate func handleSaveCoccoiControlDatabaseCase5(_ postingId: Int, _ i: Int, _ feedId: Int) {
        if sixthMoleculeLbl.text == NSLocalizedString(appDelegateObj.selectStr, comment: ""){
            sixthMoleculeLbl.text = ""
        }
        if languageId == 4 {
            let sixthMoleculeData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: sixthMoleculeLbl.text ?? "",
                dosage: cocciDosSixTextField.text ?? "",
                fromDays: from6teXTfield.text ?? "",
                toDays: toFeed6TextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeSix,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: sixthMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(sixthMoleculeData)
        } else {
            let sixthMoleculeData = CoccidiosisControlData(
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                molecule: sixthMoleculeLbl.text ?? "",
                dosage: feed6TextField.text ?? "",
                fromDays: from6teXTfield.text ?? "",
                toDays: toFeed6TextField.text ?? "",
                coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                targetWeight: "",
                index: i,
                dbArray: cocciControlArray,
                feedId: feedId as NSNumber,
                feedProgram: feedProgramTextField.text ?? "",
                formName: addFarmSelectLbl.text ?? "",
                isSync: true,
                feedType: feedTypeSix,
                cocoVacId: CocoiVacId,
                lngId: languageId as NSNumber,
                lbldate: lblDate.text ?? "",
                doseMoleculeId: sixthMolID
            )
            CoreDataHandler().saveCoccoiControlDatabase(sixthMoleculeData)
        }
    }
    
    func saveCoccoiControlDatabase(feedId : Int,postingId : Int, completion: (_ status: Bool) -> Void) {
        for i in 0..<7 {
            if i == 0 {
                handleSaveCoccoiControlDatabaseCase0(postingId, i, feedId)
            } else if i == 1 {
                handleSaveCoccoiControlDatabaseCase1(postingId, i, feedId)
            } else if i == 2 {
                handleSaveCoccoiControlDatabaseCase2(postingId, i, feedId)
            } else if i == 3 {
                handleSaveCoccoiControlDatabaseCase3(postingId, i, feedId)
            } else if i == 4 {
                handleSaveCoccoiControlDatabaseCase4(postingId, i, feedId)
            } else if i == 5 {
                handleSaveCoccoiControlDatabaseCase5(postingId, i, feedId)
            } else if i == 6 {
                let emptyData = CoccidiosisControlData(
                    loginSessionId: 1,
                    postingId: postingId as NSNumber,
                    molecule: "",  // Empty value
                    dosage: "",    // Empty value
                    fromDays: "",  // Empty value
                    toDays: "",    // Empty value
                    coccidiosisVaccine: coccidiosisVaccineDrinkin.text ?? "",
                    targetWeight: "",
                    index: i,
                    dbArray: cocciControlArray,
                    feedId: feedId as NSNumber,
                    feedProgram: feedProgramTextField.text ?? "",
                    formName: addFarmSelectLbl.text ?? "",
                    isSync: true,
                    feedType: "",  // Empty value
                    cocoVacId: CocoiVacId,
                    lngId: languageId as NSNumber,
                    lbldate: lblDate.text ?? "",
                    doseMoleculeId: sixthMolID
                )
                CoreDataHandler().saveCoccoiControlDatabase(emptyData)
            }
        }
        completion (true)
    }
    
    func saveAntibioticDatabase ( feedId : Int, postingId :Int, completion: (_ status: Bool) -> Void) {
        
        for i in 0..<6 {
            
            if i == 0 {
                
                // Create an instance of AntibioticFeedData
                let feedData = chickenCoreDataHandlerModels.saveChknAntibioticFeedData(
                       loginSessionId: 1,
                       postingId: postingId as NSNumber,
                       molecule: antiMoleculeFeedType1.text ?? "",
                       dosage: antiDosageFirstTextField.text ?? "",
                       fromDays: antiFromDurationFirstTextField.text ?? "",
                       toDays: antiToDurationFirstTextField.text ?? "",
                       index: i,
                       dbArray: AntiboticArray,
                       feedId: feedId as NSNumber,
                       feedProgram: feedProgramTextField.text ?? "",
                       formName: addFarmSelectLbl.text ?? "",
                       isSync: true,
                       feedType: feedTypeOne,
                       cocoVacId: CocoiVacId,
                       lngId: languageId as NSNumber,
                       lblDate: lblDate.text ?? ""
                )

                // Call the refactored function with the AntibioticFeedData instance
                CoreDataHandler().saveAntiboticDatabase(feedData: feedData)
            } else if i == 1 {
                                
                let feedData = chickenCoreDataHandlerModels.saveChknAntibioticFeedData(
                        loginSessionId: 1,
                        postingId: postingId as NSNumber,
                        molecule: antiMoleculeFeedType2.text ?? "",
                        dosage: antiDosageSecondTextField.text ?? "",
                        fromDays: antiFromDurationSecondTextField.text ?? "",
                        toDays: antiToDurationSecondTextField.text ?? "",
                        index: i,
                        dbArray: AntiboticArray,
                        feedId: feedId as NSNumber,
                        feedProgram: feedProgramTextField.text ?? "",
                        formName: addFarmSelectLbl.text ?? "",
                        isSync: true,
                        feedType: feedTypeTwo,
                        cocoVacId: CocoiVacId,
                        lngId: languageId as NSNumber,
                        lblDate: lblDate.text ?? ""
                )

                CoreDataHandler().saveAntiboticDatabase(feedData: feedData)
                
            } else if i == 2 {
                
                
                let feedData = chickenCoreDataHandlerModels.saveChknAntibioticFeedData(
                     loginSessionId: 1,
                     postingId: postingId as NSNumber,
                     molecule: antiMoleculeFeedType3.text ?? "",
                     dosage: antiDosageThirdTextField.text ?? "",
                     fromDays: antiFromDurationThirdTextField.text ?? "",
                     toDays: antiToDurationThirdTextField.text ?? "",
                     index: i,
                     dbArray: AntiboticArray,
                     feedId: feedId as NSNumber,
                     feedProgram: feedProgramTextField.text ?? "",
                     formName: addFarmSelectLbl.text ?? "",
                     isSync: true,
                     feedType: feedTypeThree,
                     cocoVacId: CocoiVacId,
                     lngId: languageId as NSNumber,
                     lblDate: lblDate.text ?? ""
                )

                CoreDataHandler().saveAntiboticDatabase(feedData: feedData)
                
                
            } else if i == 3 {
                
                
                let feedData = chickenCoreDataHandlerModels.saveChknAntibioticFeedData(
                        loginSessionId: 1,
                        postingId: postingId as NSNumber,
                        molecule: antiMoleculeFeedType4.text ?? "",
                        dosage: antiDosageFourTextField.text ?? "",
                        fromDays: antiFromDurationFourTextField.text ?? "",
                        toDays: antiToDurationFourTextField.text ?? "",
                        index: i,
                        dbArray: AntiboticArray,
                        feedId: feedId as NSNumber,
                        feedProgram: feedProgramTextField.text ?? "",
                        formName: addFarmSelectLbl.text ?? "",
                        isSync: true,
                        feedType: feedTypeFour,
                        cocoVacId: CocoiVacId,
                        lngId: languageId as NSNumber,
                        lblDate: lblDate.text ?? ""
                )

                CoreDataHandler().saveAntiboticDatabase(feedData: feedData)
                
            } else if i == 4 {
                
                let feedData = chickenCoreDataHandlerModels.saveChknAntibioticFeedData(
                       loginSessionId: 1,
                       postingId: postingId as NSNumber,
                       molecule: antiMoleculeFeedType5.text ?? "",
                       dosage: antiDosageFivthTextField.text ?? "",
                       fromDays: antiFromFivthTextField.text ?? "",
                       toDays: antiToDurationfivthTextField.text ?? "",
                       index: i,
                       dbArray: AntiboticArray,
                       feedId: feedId as NSNumber,
                       feedProgram: feedProgramTextField.text ?? "",
                       formName: addFarmSelectLbl.text ?? "",
                       isSync: true,
                       feedType: feedTypeFive,
                       cocoVacId: CocoiVacId,
                       lngId: languageId as NSNumber,
                       lblDate: lblDate.text ?? ""
                )

                CoreDataHandler().saveAntiboticDatabase(feedData: feedData)
                
                
            } else if i == 5 {
                                
                let feedData = chickenCoreDataHandlerModels.saveChknAntibioticFeedData(
                    loginSessionId: 1,
                    postingId: postingId as NSNumber,
                    molecule: antiMoleculeFeedType6.text ?? "",
                    dosage: antiDosageSixTextField.text ?? "",
                    fromDays: antiFromSixthTextField.text ?? "",
                    toDays: antiToDurationSixTextField.text ?? "",
                    index: i,
                    dbArray: AntiboticArray,
                    feedId: feedId as NSNumber,
                    feedProgram: feedProgramTextField.text ?? "",
                    formName: addFarmSelectLbl.text ?? "",
                    isSync: true,
                    feedType: feedTypeSix,
                    cocoVacId: CocoiVacId,
                    lngId: languageId as NSNumber,
                    lblDate: lblDate.text ?? ""
                )

                CoreDataHandler().saveAntiboticDatabase(feedData: feedData)
            }
        }
        completion (true)
    }
    
    func saveAlternativeDatabase ( feedId : Int,postingId: Int, completion: (_ status: Bool) -> Void) {
        
        for i in 0..<6 {
            
            if i == 0 {
                
                let alternativeFeedData = AlternativeFeedData(
                    loginSessionId: 1,
                    postingId: postingId as NSNumber,
                    molecule: moleculeFeedType1Alternativ.text ?? "",
                    dosage: alternativeDosageFirstText.text ?? "",
                    fromDays: alternativeFromFirstTextField.text ?? "",
                    toDays: alternativeToFirstTextField.text ?? "",
                    feedId: feedId as NSNumber,
                    feedProgram: feedProgramTextField.text ?? "",
                    formName: addFarmSelectLbl.text ?? "",
                    isSync: true,
                    feedType: feedTypeOne,
                    cocoVacId: CocoiVacId,
                    lngId: languageId as NSNumber,
                    lblDate: lblDate.text ?? ""
                )

                CoreDataHandler().saveAlternativeDatabase(alternativeFeedData, index: i, dbArray: AlternativeArray)

                
            } else if i == 1 {
                let alternativeFeedData = AlternativeFeedData(
                    loginSessionId: 1,
                    postingId: postingId as NSNumber,
                    molecule: moleculeFeedType2Alternativ.text ?? "",
                    dosage: alternativeDosageSecoondText.text ?? "",
                    fromDays: alternativeFromSecondTextField.text ?? "",
                    toDays: alternativeToSecondTextField.text ?? "",
                    feedId: feedId as NSNumber,
                    feedProgram: feedProgramTextField.text ?? "",
                    formName: addFarmSelectLbl.text ?? "",
                    isSync: true,
                    feedType: feedTypeTwo,
                    cocoVacId: CocoiVacId,
                    lngId: languageId as NSNumber,
                    lblDate: lblDate.text ?? ""
                )
                CoreDataHandler().saveAlternativeDatabase(alternativeFeedData, index: i, dbArray: AlternativeArray)
                
            } else if i == 2 {
                let alternativeFeedData = AlternativeFeedData(
                    loginSessionId: 1,
                    postingId: postingId as NSNumber,
                    molecule: moleculeFeedType3Alternativ.text ?? "",
                    dosage: alternativeDosageThirdText.text ?? "",
                    fromDays: alternativeFromthirdTextField.text ?? "",
                    toDays: alternativeTothirdTextField.text ?? "",
                    feedId: feedId as NSNumber,
                    feedProgram: feedProgramTextField.text ?? "",
                    formName: addFarmSelectLbl.text ?? "",
                    isSync: true,
                    feedType: feedTypeThree,
                    cocoVacId: CocoiVacId,
                    lngId: languageId as NSNumber,
                    lblDate: lblDate.text ?? ""
                )
                CoreDataHandler().saveAlternativeDatabase(alternativeFeedData, index: i, dbArray: AlternativeArray)

            } else if i == 3 {
                
                let alternativeFeedData = AlternativeFeedData(
                    loginSessionId: 1,
                    postingId: postingId as NSNumber,
                    molecule: moleculeFeedType4Alternativ.text ?? "",
                    dosage: alternativeDosageFourText.text ?? "",
                    fromDays: alternativeFromFourTextField.text ?? "",
                    toDays: alternativeToFourTextField.text ?? "",
                    feedId: feedId as NSNumber,
                    feedProgram: feedProgramTextField.text ?? "",
                    formName: addFarmSelectLbl.text ?? "",
                    isSync: true,
                    feedType: feedTypeFour,
                    cocoVacId: CocoiVacId,
                    lngId: languageId as NSNumber,
                    lblDate: lblDate.text ?? ""
                )
                CoreDataHandler().saveAlternativeDatabase(alternativeFeedData, index: i, dbArray: AlternativeArray)
            } else if i == 4 {
                
                let alternativeFeedData = AlternativeFeedData(
                    loginSessionId: 1,
                    postingId: postingId as NSNumber,
                    molecule: moleculeFeedType5Alternativ.text ?? "",
                    dosage: altrNativeDosage5Text.text ?? "",
                    fromDays: from5TextAlternative.text ?? "",
                    toDays: to5TextAlternative.text ?? "",
                    feedId: feedId as NSNumber,
                    feedProgram: feedProgramTextField.text ?? "",
                    formName: addFarmSelectLbl.text ?? "",
                    isSync: true,
                    feedType: feedTypeFive,
                    cocoVacId: CocoiVacId,
                    lngId: languageId as NSNumber,
                    lblDate: lblDate.text ?? ""
                )
                CoreDataHandler().saveAlternativeDatabase(alternativeFeedData, index: i, dbArray: AlternativeArray)
                
            } else if i == 5 {
                
                let alternativeFeedData = AlternativeFeedData(
                    loginSessionId: 1,
                    postingId: postingId as NSNumber,
                    molecule: moleculeFeedType6Alternativ.text ?? "",
                    dosage: altrNativeDosage6Text.text ?? "",
                    fromDays: from6TextAlternative.text ?? "",
                    toDays: to6TextAlternative.text ?? "",
                    feedId: feedId as NSNumber,
                    feedProgram: feedProgramTextField.text ?? "",
                    formName: addFarmSelectLbl.text ?? "",
                    isSync: true,
                    feedType: feedTypeSix,
                    cocoVacId: CocoiVacId,
                    lngId: languageId as NSNumber,
                    lblDate: lblDate.text ?? ""
                )
                CoreDataHandler().saveAlternativeDatabase(alternativeFeedData, index: i, dbArray: AlternativeArray)
            }
        }
        completion (true)
    }
    
    func saveMyCoxtinDatabase ( feedId : Int,postingId:Int, completion: (_ status: Bool) -> Void) {
        
        for i in 0..<6 {
            
            if i == 0 {
                
                let input = chickenCoreDataHandlerModels.MyCoxtinBinderInput.init(  loginSessionId: 1,
                                                                                    postingId: postingId as NSNumber,
                                                                                    molecule: moleculeFeedType1MyCoxtin.text ?? "",
                                                                                    dosage: myCoxtinStarterDosage.text ?? "",
                                                                                    fromDays: myFromFirstTextField.text ?? "",
                                                                                    toDays: myToFirstTextField.text ?? "",
                                                                                    feedId: feedId as NSNumber,
                                                                                    feedProgram: feedProgramTextField.text ?? "",
                                                                                    formName: addFarmSelectLbl.text ?? "",
                                                                                    isSync: true,
                                                                                    feedType: feedTypeOne,
                                                                                    cocoVacId: CocoiVacId,
                                                                                    lngId: languageId as NSNumber,
                                                                                    lblDate: lblDate.text ?? ""
                )
                
                CoreDataHandler().saveMyCoxtinDatabase(input: input, index: i, dbArray: MyCoxtinBindersArray)
            }
            else if i == 1 {
                
                let input = chickenCoreDataHandlerModels.MyCoxtinBinderInput.init(    loginSessionId: 1,
                                                                                      postingId: postingId as NSNumber,
                                                                                      molecule: moleculeFeedType2MyCoxtin.text ?? "",
                                                                                      dosage: myCoxtinGrowerDosage.text ?? "",
                                                                                      fromDays: myFromSecondTextField.text ?? "",
                                                                                      toDays: myToSecondTextField.text ?? "",
                                                                                      feedId: feedId as NSNumber,
                                                                                      feedProgram: feedProgramTextField.text ?? "",
                                                                                      formName: addFarmSelectLbl.text ?? "",
                                                                                      isSync: true,
                                                                                      feedType: feedTypeTwo,
                                                                                      cocoVacId: CocoiVacId,
                                                                                      lngId: languageId as NSNumber,
                                                                                      lblDate: lblDate.text ?? ""
                )
                
                CoreDataHandler().saveMyCoxtinDatabase(input: input, index: i, dbArray: MyCoxtinBindersArray)
                
                
            }
            
            else if i == 2 {
                
                let input = chickenCoreDataHandlerModels.MyCoxtinBinderInput.init(loginSessionId: 1,
                                                                                  postingId: postingId as NSNumber,
                                                                                  molecule: moleculeFeedType3MyCoxtin.text ?? "",
                                                                                  dosage: myCoxtinFinisherDosge.text ?? "",
                                                                                  fromDays: myFromThirdTextField.text ?? "",
                                                                                  toDays: myToThirdTextField.text ?? "",
                                                                                  feedId: feedId as NSNumber,
                                                                                  feedProgram: feedProgramTextField.text ?? "",
                                                                                  formName: addFarmSelectLbl.text ?? "",
                                                                                  isSync: true,
                                                                                   feedType: feedTypeThree,
                                                                                   cocoVacId: CocoiVacId,
                                                                                   lngId: languageId as NSNumber,
                                                                                   lblDate: lblDate.text ?? ""
                )
                
                CoreDataHandler().saveMyCoxtinDatabase(input: input, index: i, dbArray: MyCoxtinBindersArray)
                
                
            }
            else if i == 3 {
                                
                let input = chickenCoreDataHandlerModels.MyCoxtinBinderInput.init(  loginSessionId: 1,
                                                                                    postingId: postingId as NSNumber,
                                                                                    molecule: moleculeFeedType4MyCoxtin.text ?? "",
                                                                                    dosage: myCoxtinWDDosage.text ?? "",
                                                                                    fromDays: myFromFourTextField.text ?? "",
                                                                                    toDays: myToFourTextField.text ?? "",
                                                                                    feedId: feedId as NSNumber,
                                                                                    feedProgram: feedProgramTextField.text ?? "",
                                                                                    formName: addFarmSelectLbl.text ?? "",
                                                                                    isSync: true,
                                                                                    feedType: feedTypeFour,
                                                                                    cocoVacId: CocoiVacId,
                                                                                    lngId: languageId as NSNumber,
                                                                                    lblDate: lblDate.text ?? ""
                )
                
                CoreDataHandler().saveMyCoxtinDatabase(input: input, index: i, dbArray: MyCoxtinBindersArray)
            }
            else if i == 4 {
                let input = chickenCoreDataHandlerModels.MyCoxtinBinderInput.init( loginSessionId: 1,
                                                                                   postingId: postingId as NSNumber,
                                                                                   molecule: moleculeFeedType5MyCoxtin.text ?? "",
                                                                                   dosage: myCoxtin5DosageTextField.text ?? "",
                                                                                   fromDays: from5TextFieldMycoxtin.text ?? "",
                                                                                   toDays: to5TextFieldMycoxtin.text ?? "",
                                                                                   feedId: feedId as NSNumber,
                                                                                   feedProgram: feedProgramTextField.text ?? "",
                                                                                   formName: addFarmSelectLbl.text ?? "",
                                                                                   isSync: true,
                                                                                   feedType: feedTypeFive,
                                                                                   cocoVacId: CocoiVacId,
                                                                                   lngId: languageId as NSNumber,
                                                                                   lblDate: lblDate.text ?? ""
                )
                
                CoreDataHandler().saveMyCoxtinDatabase(input: input, index: i, dbArray: MyCoxtinBindersArray)
                
            }
            else if i == 5 {
                let input = chickenCoreDataHandlerModels.MyCoxtinBinderInput.init(    loginSessionId: 1,
                                                                                      postingId: postingId as NSNumber,
                                                                                      molecule: moleculeFeedType6MyCoxtin.text ?? "",
                                                                                      dosage: myCoxtin6DosageTextField.text ?? "",
                                                                                      fromDays: from6TextFieldMycoxtin.text ?? "",
                                                                                      toDays: to6TextFieldMycoxtin.text ?? "",
                                                                                      feedId: feedId as NSNumber,
                                                                                      feedProgram: feedProgramTextField.text ?? "",
                                                                                      formName: addFarmSelectLbl.text ?? "",
                                                                                      isSync: true,
                                                                                      feedType: feedTypeSix,
                                                                                      cocoVacId: CocoiVacId,
                                                                                      lngId: languageId as NSNumber,
                                                                                      lblDate: lblDate.text ?? ""
                )
                CoreDataHandler().saveMyCoxtinDatabase(input: input, index: i, dbArray: MyCoxtinBindersArray)                
            }
        }
        completion (true)
    }
    
    
    
    
    func buttonAction(sender: UIButton!) {
        buttonPopUP.alpha = 0
        ////print("Button tapped")
        
    }
    
    func clickHelpPopUp() {
        
        exitPopUP = popUP.loadFromNibNamed("popUP") as! popUP
        exitPopUP.tag = 0
        exitPopUP.delegatenEW = self
        if languageId == 4 {
            exitPopUP.lblFedPrgram.text = "Adicionar outro programa de feed?"
            exitPopUP.noButton.setTitle("Não", for: .normal)
            exitPopUP.yesButton.setTitle("Sim", for: .normal)
        }
        
        exitPopUP.center = self.view.center
        self.view.addSubview(exitPopUP)
        
    }
    
    
    func bckButtonCall() {
        
        isClickOnAnyField = true
        
        UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
        
        feedId = UserDefaults.standard.integer(forKey:"feedId")
        
        UserDefaults.standard.set(feedId, forKey: "feedId")
        UserDefaults.standard.synchronize()
    }
    
    func YesPopUpPosting(){
        
        if exitPopUP.tag == 10 || exitPopUP.tag == 20{
            exitPopUP.tag = 200
            return
        }
        
        UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
        UserDefaults.standard.synchronize()
        if postingIdFromExistingNavigate == "Exting"{
            feedProgadd = "ExtingFeeed"
        }
        if languageId == 3 {
            
            lblDate.text =  "Sélectionner une date"
        }
        else{
            lblDate.text =  "Select date"
        }
        
        strYesPop = ""
        self.CocoiVacId = 0
        navigatePostingsession = ""
        feedId = UserDefaults.standard.integer(forKey:"feedId")
        feedId = feedId + 1
        
        UserDefaults.standard.set(feedId , forKey: "feedId")
        UserDefaults.standard.synchronize()
        
        coccidsisStartrDrinking.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        coccidsisGrowerDrinking.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        cocciFinisherDrinkingWater.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        coccidiosisWdDrinking.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        fivthMoleculelBL.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        sixthMoleculeLbl.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        feed5textField.text = ""
        from5TextField.text = ""
        sixthMoleculeLbl.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        feed6TextField.text = ""
        from6teXTfield.text = ""
        toFeed5TextFeidl.text = ""
        toFeed6TextField.text = ""
        antiMoleculeFeedType1.text = ""
        antiMoleculeFeedType2.text = ""
        antiMoleculeFeedType3.text = ""
        antiMoleculeFeedType4.text = ""
        antiMoleculeFeedType5.text = ""
        antiMoleculeFeedType6.text = ""
        antiDosageFivthTextField.text = ""
        antiFromFivthTextField.text = ""
        antiToDurationfivthTextField.text = ""
        antiDosageSixTextField.text = ""
        antiToDurationSixTextField.text = ""
        moleculeFeedType1Alternativ.text = ""
        moleculeFeedType2Alternativ.text = ""
        moleculeFeedType3Alternativ.text = ""
        moleculeFeedType4Alternativ.text = ""
        moleculeFeedType5Alternativ.text = ""
        moleculeFeedType6Alternativ.text = ""
        altrNativeDosage5Text.text = ""
        from5TextAlternative.text = ""
        to5TextAlternative.text = ""
        altrNativeDosage6Text.text = ""
        from6TextAlternative.text = ""
        to6TextAlternative.text = ""
        moleculeFeedType1MyCoxtin.text = ""
        moleculeFeedType2MyCoxtin.text = ""
        moleculeFeedType3MyCoxtin.text = ""
        moleculeFeedType4MyCoxtin.text = ""
        moleculeFeedType5MyCoxtin.text = ""
        myCoxtin5DosageTextField.text = ""
        from5TextFieldMycoxtin.text = ""
        to5TextFieldMycoxtin.text = ""
        moleculeFeedType6MyCoxtin.text = ""
        myCoxtin6DosageTextField.text = ""
        from6TextFieldMycoxtin.text = ""
        to6TextFieldMycoxtin.text = ""
        antiFromSixthTextField.text = ""
        starterDosageTextField.text = ""
        cocciDosFirstTextField.text = ""
        cocciDosSecTextField.text = ""
        cocciDosThrdTextField.text = ""
        cocciDosFourTextField.text = ""
        cocciDosFiveTextField.text = ""
        cocciDosSixTextField.text = ""
        growerDosageCoccidiosisTEXT.text = ""
        finisherDosageTxtField.text = ""
        wdDosageTextField.text = ""
        FromstarterDurationTextField.text = ""
        FromGrowerTextField.text = ""
        fromFinisherTextField.text = ""
        fromWDtextField.text = ""
        toStarterTextField.text = ""
        toGrowerTextField.text = ""
        toFinisherTextField.text = ""
        toWdTextField.text = ""
        coccidiosisVaccineDrinkin.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        antiDosageFirstTextField.text = ""
        antiDosageSecondTextField.text = ""
        antiDosageThirdTextField.text = ""
        antiDosageFourTextField.text = ""
        antiFromDurationFirstTextField.text = ""
        antiFromDurationSecondTextField.text = ""
        antiFromDurationThirdTextField.text = ""
        antiFromDurationFourTextField.text = ""
        antiToDurationFirstTextField.text = ""
        antiToDurationSecondTextField.text = ""
        antiToDurationThirdTextField.text = ""
        antiToDurationFourTextField.text = ""
        alternativeDosageFirstText.text = ""
        alternativeDosageSecoondText.text = ""
        alternativeDosageThirdText.text = ""
        alternativeDosageFourText.text = ""
        alternativeFromFirstTextField.text = ""
        alternativeFromSecondTextField.text = ""
        
        alternativeFromthirdTextField.text = ""
        alternativeFromFourTextField.text = ""
        alternativeToFirstTextField.text = ""
        alternativeToSecondTextField.text = ""
        alternativeTothirdTextField.text = ""
        alternativeToFourTextField.text = ""
        myCoxtinStarterDosage.text = ""
        myCoxtinGrowerDosage.text =  ""
        myCoxtinFinisherDosge.text = ""
        myCoxtinWDDosage.text = ""
        myFromFirstTextField.text = ""
        myFromSecondTextField.text = ""
        myFromThirdTextField.text = ""
        myFromFourTextField.text = ""
        myToFirstTextField.text = ""
        myToSecondTextField.text = ""
        myToThirdTextField.text = ""
        myToFourTextField.text = ""
        feedProgramTextField.text = ""
        addFarmSelectLbl.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        self.coccidiosisControlBtnActoin(sender: "0" as AnyObject)
        
        self.printSyncLblCount()
        
    }
    
    
    func noPopUpPosting(){
        
        if exitPopUP.tag == 10 || exitPopUP.tag == 20 {
            btnTagsave = 2
            callSaveMethod(btnTagSave: btnTagsave)
        }
        else {
            UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
            UserDefaults.standard.synchronize()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.isFeedProgramClick = true
            appDelegate.sendFeedVariable = "Feed"
            appDelegate.strImpFedd = feedImpandMetric
            appDelegate.newColor = datCount + 1
            self.navigationController?.popViewController(animated:true)
            
        }
    }
    
    
    // MARK: - TableView Delegate and dataSource Method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == farmTableView{
            return addFarmArray.count
            
        }
        else {
            
            switch btnTag {
            case 0:
                return cocciControlArrayfromServer.count
            case 1:
                return AlternativeArrayfromServer.count
            case 2:
                return AntiboticArrayfromServer.count
            case 3:
                return MyCoxtinBindersArrayfromServer.count
            case 4:
                return cocodiceVacine.count
            default:
                
                if feedImpandMetric == "Metric"{
                    return arrTagetMetric.count
                }else {
                    if btnTag > 100 {
                        return fetchDosage.count
                    } else {
                        return arrTargetImp.count
                    }
                }
            }
        }
    }
    
    fileprivate func handleAddFarmArrayWithUnCheckForm(_ indexPath: IndexPath, _ cell: secTableViewCell) {
        if addFarmArrayWithUnCheckForm.count > 0 {
            let c = addFarmArrayWithUnCheckForm.object(at: indexPath.row) as! CaptureNecropsyData
            if c.isChecked == 1 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.accessoryType = .none
        }
    }
    
    fileprivate func handleBtnTagValidation(_ indexPath: IndexPath, _ cell: UITableViewCell) {
        if btnTag == 0 {
            let cocoiControll = (cocciControlArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as! String
            cell.textLabel!.text = cocoiControll
        } else if btnTag == 1 {
            
            let cocoiControll = (AlternativeArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as! String
            cell.textLabel!.text = cocoiControll
        } else if btnTag == 2 {
            
            let cocoiControll = (AntiboticArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as! String
            cell.textLabel!.text = cocoiControll
            
        } else if btnTag == 3 {
            let cocoiControll = (MyCoxtinBindersArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as! String
            cell.textLabel!.text = cocoiControll
            
        } else if btnTag == 4 {
            cell.textLabel!.text = (cocodiceVacine.object(at: indexPath.row) as AnyObject).value(forKey: "cocoiiVacname") as? String
        } else if btnTag == 5 {
            
            if feedImpandMetric == "Metric"{
                cell.textLabel!.text = arrTagetMetric[indexPath.row] as? String
            }
            else{
                cell.textLabel!.text = arrTargetImp[indexPath.row] as? String
            }
        } else if btnTag > 100 {
            let cocoiControll = (fetchDosage.object(at: indexPath.row) as AnyObject).value(forKey: "doseName") as? String
            cell.textLabel!.text = cocoiControll
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == farmTableView {
            
            let cell:secTableViewCell = self.farmTableView.dequeueReusableCell(withIdentifier: "cell") as! secTableViewCell
            
            cell.farmsShowLbl?.text = addFarmArray.object(at: indexPath.row) as? String
            
            handleAddFarmArrayWithUnCheckForm(indexPath, cell)
            return cell
            
        } else {
            
            let cell = UITableViewCell ()
            
            handleBtnTagValidation(indexPath, cell)
            
            return cell
        }
        
    }
    
    fileprivate func updatenecropsyFeedData(_ formName: String) {
        if navigatePostingsession == "PostingFeedProgram" {
            if UserDefaults.standard.bool(forKey:"Unlinked") == true {
                let necId =  UserDefaults.standard.integer(forKey:"necUnLinked")
                
                CoreDataHandler().updateFeedProgramNameoNNecropsystep1neccId(necId as NSNumber, feedProgramName: feedProgramTextField.text!,formName: formName ,isCheckForm: true,feedId : feedPostingId as NSNumber)
            } else {
                CoreDataHandler().updateFeedProgramNameoNNecropsystep1neccId(postingId as NSNumber, feedProgramName: feedProgramTextField.text!,formName: formName ,isCheckForm: true,feedId : feedPostingId as NSNumber)
            }
        } else {
            if UserDefaults.standard.bool(forKey:"Unlinked") == true {
                let necId =  UserDefaults.standard.integer(forKey:"necUnLinked")
                CoreDataHandler().updateFeedProgramNameoNNecropsystep1neccId(necId as NSNumber, feedProgramName: feedProgramTextField.text!,formName: formName ,isCheckForm: true,feedId : feedId as NSNumber)
            } else {
                CoreDataHandler().updateFeedProgramNameoNNecropsystep1neccId(postingId as NSNumber, feedProgramName: feedProgramTextField.text!,formName: formName ,isCheckForm: true,feedId : feedId as NSNumber)
            }
        }
    }
    
    fileprivate func handleBtnTag(_ indexPath: IndexPath) {
        if btnTag == 0 {
            
            if Allbuttonbg == 0 {
                coccidsisStartrDrinking.text = (cocciControlArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as? String
                firstMolID = (cocciControlArrayfromServer.value(forKey:"moleculeId") as AnyObject).object(at:indexPath.row) as? Int ?? 0
                isClickOnAnyField = true
            } else if Allbuttonbg == 1 {
                coccidsisGrowerDrinking.text = (cocciControlArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as? String
                secoundMolID = (cocciControlArrayfromServer.value(forKey:"moleculeId") as AnyObject).object(at:indexPath.row) as? Int ?? 0
                isClickOnAnyField = true
            } else if Allbuttonbg == 2 {
                cocciFinisherDrinkingWater.text = (cocciControlArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as? String
                thirdMolID = (cocciControlArrayfromServer.value(forKey:"moleculeId") as AnyObject).object(at:indexPath.row) as? Int ?? 0
                isClickOnAnyField = true
            } else if Allbuttonbg == 3 {
                
                coccidiosisWdDrinking.text = (cocciControlArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as? String
                fourthMolID = (cocciControlArrayfromServer.value(forKey:"moleculeId") as AnyObject).object(at:indexPath.row) as? Int ?? 0
                isClickOnAnyField = true
            } else if Allbuttonbg == 40 {
                fivthMoleculelBL.text = (cocciControlArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as? String
                fifthMolID = (cocciControlArrayfromServer.value(forKey:"moleculeId") as AnyObject).object(at:indexPath.row) as? Int ?? 0
                isClickOnAnyField = true
            } else if Allbuttonbg == 50 {
                
                sixthMoleculeLbl.text = (cocciControlArrayfromServer.value(forKey:"desc") as AnyObject).object(at:indexPath.row) as? String
                sixthMolID = (cocciControlArrayfromServer.value(forKey:"moleculeId") as AnyObject).object(at:indexPath.row) as? Int ?? 0
                isClickOnAnyField = true
            }
        } else if btnTag == 4 {
            coccidiosisVaccineDrinkin.text = (cocodiceVacine.object(at: indexPath.row) as AnyObject).value(forKey: "cocoiiVacname") as? String
            CocoiVacId = (cocodiceVacine.object(at: indexPath.row) as AnyObject).value(forKey: "cocvaccId") as! NSNumber
            buttonCocotarget()
            isClickOnAnyField = true
        } else if btnTag == 5 {
            
            buttonCocotarget()
            
            isClickOnAnyField = true
        }
    }
    
    fileprivate func handleAccessoryType(_ newCell: secTableViewCell, _ formName: String) {
        if (newCell.accessoryType == .checkmark) {
            
            if UserDefaults.standard.bool(forKey:"Unlinked") == true {
                let necId1 =  UserDefaults.standard.integer(forKey:"necUnLinked")
                postingId = necId1 as NSNumber
            }
            
            if navigatePostingsession == "PostingFeedProgram" {
                CoreDataHandler().updateFeedProgramNameoNNecropsystep1neccId(postingId as NSNumber, feedProgramName: feedProgramTextField.text!,formName: formName ,isCheckForm: false,feedId : feedPostingId as NSNumber)
                CoreDataHandler().updateFeedProgramNameoNNecropsystep1neccIdFeddprogramBlank(postingId as NSNumber,formName: formName,feedId : feedPostingId as NSNumber)
            } else {
                CoreDataHandler().updateFeedProgramNameoNNecropsystep1neccId(postingId as NSNumber, feedProgramName: feedProgramTextField.text!,formName: formName ,isCheckForm: false,feedId : feedId as NSNumber)
                CoreDataHandler().updateFeedProgramNameoNNecropsystep1neccIdFeddprogramBlank(postingId as NSNumber,formName: formName,feedId : feedPostingId as NSNumber)
            }
            
            newCell.accessoryType = .none
            
            isClickOnAnyField = true
            
        } else {
            
            updatenecropsyFeedData(formName)
            newCell.accessoryType = .checkmark
            isClickOnAnyField = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == farmTableView {
            let newCell:secTableViewCell = self.farmTableView.cellForRow(at: indexPath as IndexPath) as! secTableViewCell
            
            UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
            UserDefaults.standard.synchronize()
            
            let formName = addFarmArray.object(at:indexPath.row) as! String
            
            handleAccessoryType(newCell, formName)
        } else {
            
            handleBtnTag(indexPath)
            
            let dosageFields: [Int: UILabel] = [
                101: starterDosageTextField,
                102: growerDosageCoccidiosisTEXT,
                103: finisherDosageTxtField,
                104: wdDosageTextField,
                105: feed5textField,
                106: feed6TextField,
                
                111: alternativeDosageFirstText,
                112: alternativeDosageSecoondText,
                113: alternativeDosageThirdText,
                114: alternativeDosageFourText,
                115: altrNativeDosage5Text,
                116: altrNativeDosage6Text,
                
                121: myCoxtinStarterDosage,
                122: myCoxtinGrowerDosage,
                123: myCoxtinFinisherDosge,
                124: myCoxtinWDDosage,
                125: myCoxtin5DosageTextField,
                126: myCoxtin6DosageTextField,
                
                131: antiDosageFirstTextField,
                132: antiDosageSecondTextField,
                133: antiDosageThirdTextField,
                134: antiDosageFourTextField,
                135: antiDosageFivthTextField,
                136: antiDosageSixTextField
            ]
            
            if let label = dosageFields[btnTag] {
                label.text = (fetchDosage.object(at: indexPath.row) as AnyObject).value(forKey: "doseName") as? String
                isClickOnAnyField = true
            }
        }
        buttonPressed1()
    }
    
    func submittingMolecule(field: UILabel, index: Int){
        let alert = UIAlertController(title: "Molecule", message: "Please input molecule", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            field.text = textField.text
            let dict: [String:Any] = ["catId":(self.cocciControlArrayfromServer.value(forKey: "catId") as AnyObject).object(at:index) as? Int, "desc":field.text, "lngId":(self.cocciControlArrayfromServer.value(forKey: "lngId") as AnyObject).object(at:index) as? Int, "moleculeId":""]
            self.cocciControlArrayfromServer.add(dict)
            self.droperTableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter molecule name"
        }
        alert.addAction(action)
        self.present(alert, animated:true, completion: nil)
    }
    // MARK: - TEXTFIELD Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        farmTableView.alpha = 0
        
        let fullString = textField.text
        var ffullStringArr = fullString?.components(separatedBy: ".")
        let firstStr: String = ffullStringArr![0]
        let lastStr: String? = ffullStringArr!.count > 1 ? ffullStringArr![1] : nil
        textField.text = lastStr?.count == 0 ? firstStr : fullString
        isClickOnAnyField = true
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == coccidsisStartrDrinking ) {
            feedProgramTextField.returnKeyType = UIReturnKeyType.done
        } else {
            antiToDurationFourTextField.returnKeyType = UIReturnKeyType.done
            antiToDurationThirdTextField.returnKeyType = UIReturnKeyType.done
            FromstarterDurationTextField.returnKeyType = UIReturnKeyType.done
            FromGrowerTextField.returnKeyType = UIReturnKeyType.done
            fromFinisherTextField.returnKeyType = UIReturnKeyType.done
            fromWDtextField.returnKeyType = UIReturnKeyType.done
            toStarterTextField.returnKeyType = UIReturnKeyType.done
            toGrowerTextField.returnKeyType = UIReturnKeyType.done
            toFinisherTextField.returnKeyType = UIReturnKeyType.done
            toWdTextField.returnKeyType = UIReturnKeyType.done
            antiFromDurationFirstTextField.returnKeyType = UIReturnKeyType.done
            antiFromDurationSecondTextField.returnKeyType = UIReturnKeyType.done
            antiFromDurationThirdTextField.returnKeyType = UIReturnKeyType.done
            antiFromDurationFourTextField.returnKeyType = UIReturnKeyType.done
            antiToDurationFirstTextField.returnKeyType = UIReturnKeyType.done
            antiToDurationSecondTextField.returnKeyType = UIReturnKeyType.done
            alternativeFromFourTextField.returnKeyType = UIReturnKeyType.done
            alternativeToFirstTextField.returnKeyType = UIReturnKeyType.done
            alternativeToSecondTextField.returnKeyType = UIReturnKeyType.done
            alternativeTothirdTextField.returnKeyType = UIReturnKeyType.done
            
            alternativeFromFirstTextField.returnKeyType = UIReturnKeyType.done
            alternativeFromSecondTextField.returnKeyType = UIReturnKeyType.done
            alternativeFromthirdTextField.returnKeyType = UIReturnKeyType.done
            alternativeToFourTextField.returnKeyType = UIReturnKeyType.done
            feedProgramTextField.returnKeyType = UIReturnKeyType.done
            myFromThirdTextField.returnKeyType = UIReturnKeyType.done
            myToFourTextField.returnKeyType = UIReturnKeyType.done
            myToThirdTextField.returnKeyType = UIReturnKeyType.done
            myToSecondTextField.returnKeyType = UIReturnKeyType.done
            myToFirstTextField.returnKeyType = UIReturnKeyType.done
            myFromFourTextField.returnKeyType = UIReturnKeyType.done
            
            
            cocciDosFirstTextField.returnKeyType = UIReturnKeyType.done
            cocciDosSecTextField.returnKeyType = UIReturnKeyType.done
            cocciDosThrdTextField.returnKeyType = UIReturnKeyType.done
            cocciDosFourTextField.returnKeyType = UIReturnKeyType.done
            cocciDosFiveTextField.returnKeyType = UIReturnKeyType.done
            cocciDosSixTextField.returnKeyType = UIReturnKeyType.done
            farmTableView.alpha = 0
            
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        feedProgramTextField.becomeFirstResponder()
        feedProgramTextField.resignFirstResponder()
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
            
        case 11,12,13,14,19,20,21,26,27,28,29,30,31,32,33,38,39,40,41,42,43,44,45,46,51,52,53,54,55,56,57,58,100,101,102,103,104,105,106,107,108,109,110,111,114,115,116,117,120,121,122,123,126,127,128,129,132,133,134,135,136 :
            
            let aSet = NSCharacterSet(charactersIn: "0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            
            return string == numberFiltered && newString.length <= maxLength
        case 15,16,17,18,23,22,24,25,34,35,36,37,47,48,49,50,112,113,118,119,124,125,130,131 :
            
            let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let maxLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
            if countdots > 0 && string == "."
            {
                return false
            }
            return string == numberFiltered && newString.length <= maxLength
            
            
        case 333 :
            
            let ACCEPTED_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:;,/-_!@#$%*()-_=+[]\'<>.?/\\~`€£"
            let setValidation = CharacterSet(charactersIn: ACCEPTED_CHARACTERS)
            let inverted = setValidation.inverted
            let filtered = string.components(separatedBy: inverted).joined(separator: "")
            
            
            let maxLength = 50
            let currentString: NSString = feedProgramTextField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength && filtered == string
            
        default : break
            //print( "default case")
        }
        isClickOnAnyField = true
        return true
        
    }
    
    // MARK: - UI TOUCH  Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func touchMoved() {
        ////print("touch moved")
    }
    
    func touchBegan() {
        ////print("touch began")
    }
    
    func animateView (movement : CGFloat){
        UIView.animate(withDuration: 0.1, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement);
        })
    }
    
    
    
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out"
        {
            
            UserDefaults.standard.removeObject(forKey: "login")
            if ConnectionManager.shared.hasConnectivity() {
                self.ssologoutMethod()
                CoreDataHandler().deleteAllData("Custmer")
            }
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            
            buttonbg.removeFromSuperview()
            logOutPopView1.removeView(view)
            
        }
    }
    
    // MARK:  /*********** Logout SSO Account **************/
    func ssologoutMethod()
    {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func clickHelp() {
        
        
        logoutViewbg.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        
        logoutViewbg.addTarget(self, action: #selector(FeedProgramViewController.logOytButtn), for: .touchUpInside)
        logoutViewbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(logoutViewbg)
        
        
        logOutPopView1 = UserListView.loadFromNibNamed("UserListView") as! UserListView
        logOutPopView1.logoutDelegate = self
        
        logOutPopView1.layer.cornerRadius = 8
        logOutPopView1.layer.borderWidth = 3
        logOutPopView1.layer.borderColor =  UIColor.clear.cgColor
        self.logoutViewbg .addSubview(logOutPopView1)
        logOutPopView1.showView(self.view, frame1: CGRect(x: self.view.frame.size.width - 200,y: 60,width: 150,height: 60))
    }
    
    @objc func logOytButtn () {
        logoutViewbg.removeFromSuperview()
        logOutPopView1.removeFromSuperview()
        
    }
    
    
    // MARK:  /*********** Add custome padding to Textfield's **************/
    func spacingInTxtField(){
        
        antiFromDurationFirstTextField.leftView = createPaddingView(width: 10, height: 20)
        antiFromDurationFirstTextField.leftViewMode = .always
        
        antiFromDurationThirdTextField.leftView = createPaddingView(width: 10, height: 20)
        antiFromDurationThirdTextField.leftViewMode = .always
        
        to5TextAlternative.leftView = createPaddingView(width: 10, height: 20)
        to5TextAlternative.leftViewMode = .always
        
        antiMoleculeFeedType1.leftView = createPaddingView(width: 10, height: 20)
        antiMoleculeFeedType1.leftViewMode = .always
        
        antiMoleculeFeedType2.leftView = createPaddingView(width: 10, height: 20)
        antiMoleculeFeedType2.leftViewMode = .always
        
        antiMoleculeFeedType3.leftView = createPaddingView(width: 10, height: 20)
        antiMoleculeFeedType3.leftViewMode = .always
        
        antiMoleculeFeedType4.leftView = createPaddingView(width: 10, height: 20)
        antiMoleculeFeedType4.leftViewMode = .always
        
        antiMoleculeFeedType5.leftView = createPaddingView(width: 10, height: 20)
        antiMoleculeFeedType5.leftViewMode = .always
        
        antiMoleculeFeedType6.leftView = createPaddingView(width: 10, height: 20)
        antiMoleculeFeedType6.leftViewMode = .always
        
        feedProgramTextField.leftView = createPaddingView(width: 10, height: 20)
        feedProgramTextField.leftViewMode = .always
        
        antiToDurationFirstTextField.leftView = createPaddingView(width: 10, height: 20)
        antiToDurationFirstTextField.leftViewMode = .always
        
        antiFromDurationSecondTextField.leftView = createPaddingView(width: 10, height: 20)
        antiFromDurationSecondTextField.leftViewMode = .always
        
        antiToDurationSecondTextField.leftView = createPaddingView(width: 10, height: 20)
        antiToDurationSecondTextField.leftViewMode = .always
        
        antiToDurationThirdTextField.leftView = createPaddingView(width: 10, height: 20)
        antiToDurationThirdTextField.leftViewMode = .always
        
        antiFromDurationFourTextField.leftView = createPaddingView(width: 10, height: 20)
        antiFromDurationFourTextField.leftViewMode = .always
        
        antiToDurationFourTextField.leftView = createPaddingView(width: 10, height: 20)
        antiToDurationFourTextField.leftViewMode = .always
        
        antiFromFivthTextField.leftView = createPaddingView(width: 10, height: 20)
        antiFromFivthTextField.leftViewMode = .always
        
        antiToDurationfivthTextField.leftView = createPaddingView(width: 10, height: 20)
        antiToDurationfivthTextField.leftViewMode = .always
        
        antiFromSixthTextField.leftView = createPaddingView(width: 10, height: 20)
        antiFromSixthTextField.leftViewMode = .always
        
        antiToDurationSixTextField.leftView = createPaddingView(width: 10, height: 20)
        antiToDurationSixTextField.leftViewMode = .always
        
        FromstarterDurationTextField.leftView = createPaddingView(width: 10, height: 20)
        FromstarterDurationTextField.leftViewMode = .always
        
        toStarterTextField.leftView = createPaddingView(width: 10, height: 20)
        toStarterTextField.leftViewMode = .always
        
        FromGrowerTextField.leftView = createPaddingView(width: 10, height: 20)
        FromGrowerTextField.leftViewMode = .always
        
        toGrowerTextField.leftView = createPaddingView(width: 10, height: 20)
        toGrowerTextField.leftViewMode = .always
        
        fromFinisherTextField.leftView = createPaddingView(width: 10, height: 20)
        fromFinisherTextField.leftViewMode = .always
        
        toFinisherTextField.leftView = createPaddingView(width: 10, height: 20)
        toFinisherTextField.leftViewMode = .always
        
        fromWDtextField.leftView = createPaddingView(width: 10, height: 20)
        fromWDtextField.leftViewMode = .always
        
        toWdTextField.leftView = createPaddingView(width: 10, height: 20)
        toWdTextField.leftViewMode = .always
        
        from5TextField.leftView = createPaddingView(width: 10, height: 20)
        from5TextField.leftViewMode = .always
        
        toFeed5TextFeidl.leftView = createPaddingView(width: 10, height: 20)
        toFeed5TextFeidl.leftViewMode = .always
        
        from6teXTfield.leftView = createPaddingView(width: 10, height: 20)
        from6teXTfield.leftViewMode = .always
        
        toFeed6TextField.leftView = createPaddingView(width: 10, height: 20)
        toFeed6TextField.leftViewMode = .always
        
        moleculeFeedType1Alternativ.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType1Alternativ.leftViewMode = .always
        
        alternativeFromFirstTextField.leftView = createPaddingView(width: 10, height: 20)
        alternativeFromFirstTextField.leftViewMode = .always
        
        alternativeToFirstTextField.leftView = createPaddingView(width: 10, height: 20)
        alternativeToFirstTextField.leftViewMode = .always
        
        moleculeFeedType2Alternativ.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType2Alternativ.leftViewMode = .always
        
        alternativeFromSecondTextField.leftView = createPaddingView(width: 10, height: 20)
        alternativeFromSecondTextField.leftViewMode = .always
        
        alternativeToSecondTextField.leftView = createPaddingView(width: 10, height: 20)
        alternativeToSecondTextField.leftViewMode = .always
        
        moleculeFeedType3Alternativ.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType3Alternativ.leftViewMode = .always
        
        alternativeFromthirdTextField.leftView = createPaddingView(width: 10, height: 20)
        alternativeFromthirdTextField.leftViewMode = .always
        
        alternativeTothirdTextField.leftView = createPaddingView(width: 10, height: 20)
        alternativeTothirdTextField.leftViewMode = .always
        
        moleculeFeedType4Alternativ.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType4Alternativ.leftViewMode = .always
        
        alternativeFromFourTextField.leftView = createPaddingView(width: 10, height: 20)
        alternativeFromFourTextField.leftViewMode = .always
        
        alternativeToFourTextField.leftView = createPaddingView(width: 10, height: 20)
        alternativeToFourTextField.leftViewMode = .always
        
        moleculeFeedType5Alternativ.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType5Alternativ.leftViewMode = .always
        
        from5TextAlternative.leftView = createPaddingView(width: 10, height: 20)
        from5TextAlternative.leftViewMode = .always
        
        moleculeFeedType6Alternativ.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType6Alternativ.leftViewMode = .always
        
        from6TextAlternative.leftView = createPaddingView(width: 10, height: 20)
        from6TextAlternative.leftViewMode = .always
        
        to6TextAlternative.leftView = createPaddingView(width: 10, height: 20)
        to6TextAlternative.leftViewMode = .always
        
        moleculeFeedType1MyCoxtin.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType1MyCoxtin.leftViewMode = .always
        
        myToFirstTextField.leftView = createPaddingView(width: 10, height: 20)
        myToFirstTextField.leftViewMode = .always
        
        myFromFirstTextField.leftView = createPaddingView(width: 10, height: 20)
        myFromFirstTextField.leftViewMode = .always
        
        moleculeFeedType2MyCoxtin.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType2MyCoxtin.leftViewMode = .always
        
        myFromSecondTextField.leftView = createPaddingView(width: 10, height: 20)
        myFromSecondTextField.leftViewMode = .always
        
        myToSecondTextField.leftView = createPaddingView(width: 10, height: 20)
        myToSecondTextField.leftViewMode = .always
        
        moleculeFeedType3MyCoxtin.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType3MyCoxtin.leftViewMode = .always
        
        myFromThirdTextField.leftView = createPaddingView(width: 10, height: 20)
        myFromThirdTextField.leftViewMode = .always
        
        myToThirdTextField.leftView = createPaddingView(width: 10, height: 20)
        myToThirdTextField.leftViewMode = .always
        
        moleculeFeedType4MyCoxtin.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType4MyCoxtin.leftViewMode = .always
        
        myFromFourTextField.leftView = createPaddingView(width: 10, height: 20)
        myFromFourTextField.leftViewMode = .always
        
        myToFourTextField.leftView = createPaddingView(width: 10, height: 20)
        myToFourTextField.leftViewMode = .always
        
        moleculeFeedType5MyCoxtin.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType5MyCoxtin.leftViewMode = .always
        
        from5TextFieldMycoxtin.leftView = createPaddingView(width: 10, height: 20)
        from5TextFieldMycoxtin.leftViewMode = .always
        
        to5TextFieldMycoxtin.leftView = createPaddingView(width: 10, height: 20)
        to5TextFieldMycoxtin.leftViewMode = .always
        
        moleculeFeedType6MyCoxtin.leftView = createPaddingView(width: 10, height: 20)
        moleculeFeedType6MyCoxtin.leftViewMode = .always
        
        from6TextFieldMycoxtin.leftView = createPaddingView(width: 10, height: 20)
        from6TextFieldMycoxtin.leftViewMode = .always
        
        to6TextFieldMycoxtin.leftView = createPaddingView(width: 10, height: 20)
        to6TextFieldMycoxtin.leftViewMode = .always
        
        myToThirdTextField.leftView = createPaddingView(width: 10, height: 20)
        myToThirdTextField.leftViewMode = .always
        
    }
    
    func createPaddingView(width: CGFloat, height: CGFloat) -> UIView {
        return UIView(frame: CGRect(x: 15, y: 0, width: width, height: height))
        
    }
    
    @IBAction func addFarmBtnAction(sender: AnyObject) {
        
        if  feedProgramTextField.text == ""  {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(feedPrgramvalidationMsg, comment: ""))
            
        }
        else{
            
            feedArr.removeAllObjects()
            addFarmArray.removeAllObjects()
            addFarmArrayWithUnCheckForm.removeAllObjects()
            let necId =  UserDefaults.standard.integer(forKey:"necUnLinked")
            
            let isUpadateFeedFromUnlinked = UserDefaults.standard.bool(forKey:"isUpadteFeedFromUnlinked")
            
            if isUpadateFeedFromUnlinked == true
            {
                
                if navigatePostingsession == "PostingFeedProgram"{
                    
                    feedArr = CoreDataHandler().FetchFarmNameOnNecropsystep1neccId(necId as NSNumber, feedProgramName: feedProgramTextField.text!,feedId : feedPostingId as NSNumber).mutableCopy() as! NSMutableArray
                }
                else
                {
                    feedArr = CoreDataHandler().FetchFarmNameOnNecropsystep1neccId(necId as NSNumber, feedProgramName: feedProgramTextField.text!,feedId : feedId as NSNumber).mutableCopy() as!  NSMutableArray
                }
                
                let feedArr1 = CoreDataHandler().FetchNecropsystep1neccIdWithCheckFarm(necId as NSNumber).mutableCopy() as! NSMutableArray
                
                feedArr.addObjects(from: feedArr1 as [AnyObject])
                
                for i in  0..<feedArr.count
                {
                    let  c = feedArr.object(at:i) as! CaptureNecropsyData
                    addFarmArray.add(c.farmName!)
                    addFarmArrayWithUnCheckForm.add(feedArr.object(at:i))
                }
            }
            else
            {
                if navigatePostingsession == "PostingFeedProgram"{
                    feedArr = CoreDataHandler().FetchFarmNameOnNecropsystep1neccId(necId as NSNumber, feedProgramName: feedProgramTextField.text!,feedId : feedPostingId as NSNumber).mutableCopy() as! NSMutableArray
                }
                else
                {
                    feedArr = CoreDataHandler().FetchFarmNameOnNecropsystep1neccId(necId as NSNumber, feedProgramName: feedProgramTextField.text!,feedId : feedId as NSNumber).mutableCopy() as! NSMutableArray
                }
                
                let feedArr1 = CoreDataHandler().FetchNecropsystep1neccIdWithCheckFarm(necId as NSNumber).mutableCopy() as AnyObject
                feedArr.addObjects(from: feedArr1 as! [AnyObject])
                
                for i in  0..<feedArr.count
                {
                    let  c = feedArr.object(at:i) as! CaptureNecropsyData
                    addFarmArray.add(c.farmName!)
                    addFarmArrayWithUnCheckForm.add(feedArr.object(at:i))
                }
            }
            
            if addFarmArray.count == 0
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"You don't have any farm to add in feed.")
            }
            else
            {
                addFarmPopp()
                farmTableView.alpha = 1
                farmTableView.layer.borderWidth = 1
                farmTableView.layer.cornerRadius = 7
                farmTableView.layer.borderColor =  UIColor.clear.cgColor
                farmTableView.frame = CGRect(x: 335,y: 500,width: 375,height: 150)
                farmTableView.reloadData()
            }
        }
    }
    
    func removeDuplicates(array: NSMutableArray) -> NSMutableArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                debugPrint("No task to peroform.")
            }
            else {
                encountered.insert(value as! String)
                result.add(value as! String)
            }
        }
        return result
    }
    
    
    func addFarmPopp(){
        
        backBtnnFrame.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        backBtnnFrame.addTarget(self, action: #selector(addFarmEnd), for: .touchUpInside)
        backBtnnFrame.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view.addSubview(backBtnnFrame)
        backBtnnFrame.addSubview(farmTableView)
    }
    
    @objc func addFarmEnd(){
        
        
        if UserDefaults.standard.bool(forKey:"Unlinked") == true{
            let necId1 =  UserDefaults.standard.integer(forKey:"necUnLinked")
            postingId = necId1 as NSNumber
        }
        
        if navigatePostingsession == "PostingFeedProgram"{
            farmArrayTrue = CoreDataHandler().FetchNecropsystep1neccIdTrueVal(postingId as NSNumber,formTrueValue: true,feedProgram: feedProgramTextField.text!,feedId :feedPostingId as NSNumber)
        }
        else
        {
            farmArrayTrue = CoreDataHandler().FetchNecropsystep1neccIdTrueVal(postingId as NSNumber,formTrueValue: true,feedProgram: feedProgramTextField.text!,feedId :feedId as NSNumber)
        }
        if farmArrayTrue.count > 0 {
            
            let ftitle = NSMutableString()
            for i in 0..<farmArrayTrue.count{
                
                var label = UILabel()
                let feepRGMR = (farmArrayTrue.object(at:i) as AnyObject).value(forKey:"farmName") as! String
                
                if i == 0
                {
                    label  = UILabel(frame: CGRect(x: 50,y: 519,width: 111,height: 21))
                    ftitle.append( feepRGMR + " " )
                }
                
                else{
                    label  = UILabel(frame: CGRect(x: 50,y: 519,width: 111*(CGFloat(i)+1)+10,height: 21))
                    ftitle.append(", " + feepRGMR + " " )
                }
                
                label.textAlignment = NSTextAlignment.center
                label.backgroundColor = UIColor.red
                addFarmSelectLbl.text = ftitle as String
            }
        }
        else
        {
            addFarmSelectLbl.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        }
        
        btnTag = 0
        backBtnnFrame.removeFromSuperview()
    }
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at:j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at:w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at:i) as! PostingSession
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at:i) as! CaptureNecropsyData
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
}


extension Array {
    subscript(safely index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
