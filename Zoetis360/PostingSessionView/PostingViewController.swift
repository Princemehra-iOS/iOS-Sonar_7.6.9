import UIKit
import CoreData
import Alamofire
import Reachability
import Gigya
import GigyaTfa
import GigyaAuth

var feedId = Int()

class PostingViewController: UIViewController,DropperDelegate,UITextViewDelegate,UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate,userLogOut,syncApi,popUPnavigation{
    
    // MARK: - Variables
    var  strdate =  String()
    var lngId = NSInteger()
    var strdateFrench = String()
    var isClickOnAnyField = Bool()
    let objApiSync = ApiSync()
    var titleView = UIView()
    var navigateFromUnlinked  = String ()
    var necId  = Int ()
    var postingIdnavigate  = Int ()
    var unComplexId  = Int ()
    var unCustId  = Int ()
    var lblTimeStamp = String()
    var actualTimeStamp = String()
    let buttonbg1 = UIButton ()
    let buttonDroper = UIButton ()
    var lblTimestampUnlinked = String()
    var impFeed = String ()
    var customPopView1 :UserListView!
    var exitPopUP :popUP!
    var custRep = NSMutableArray ()
    var fetchcustRep = NSArray ()
    var autocompleteUrls = NSMutableArray ()
    var autoSerchTable = UITableView ()
    var feedProgramArray = NSArray ()
    var datePicker : UIDatePicker!
    var buttonBg = UIButton()
    var navStr = String ()
    var postingArray = NSArray()
    var custmerArray  = NSArray()
    var SalesRepArr  = NSArray()
    var sessionTypeArr  = NSArray()
    var complexArr  = NSArray()
    var VetrationArr  = NSArray()
    var CocoiiProgramArr  = NSArray()
    var ProductionTypeArr  = NSArray()
    var birdArray: [BirdSizePosting]  = []
    var strComplexFromUnlinked = String ()
    var strdateFromUnlinked = String ()
    var breedArray : [Breed] = []
    var femaleArr : [Breed] = []
    var droperTableView  =  UITableView ()
    let buttonbg2 = UIButton ()
    var btnTag = Int()
    var metricArray: [BirdSizePosting]  = []
    var custmetIdDb = NSNumber()
    var cusmerRepIdDb = NSNumber()
    var birdSizeIdDb = NSNumber()
    var breedIdDb = NSNumber()
    var salesRepIdDb = NSNumber()
    var sessionTypeIdDb = NSNumber()
    var veterinartionIdDb = NSNumber()
    var postingIdDb = NSNumber()
    var loginSessionIdDb = NSNumber()
    var complexIdDb = NSNumber()
    var cocciProgramIdDb = NSNumber()
    var productionIdDb = NSNumber()
    var newColor = Int()
    var  postingId = Int()
    var productionNameStr = String()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedObjectContext = (UIApplication.shared.delegate
                                as! AppDelegate).managedObjectContext
    var butttnTag = Int()
    var indexOfSelectedPerson = Int()
    var butttnBg = UIButton()
    var machineArray = NSMutableArray()
    var lalTitle = UILabel()
    let cellReuseIdentifier = "cell"
    
    // MARK: ******************************************************
    
    // MARK: - Outlets
    @IBOutlet weak var dropImageView: UIImageView!
    @IBOutlet weak var doneButtonP: UIButton!
    @IBOutlet weak var lblSessionDate: UILabel!
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblAccountContact: UILabel!
    @IBOutlet weak var feedProgrmLbl2: UILabel!
    @IBOutlet weak var feedProgramLbl: UILabel!
    @IBOutlet weak var feed3PrgrmLbl: UILabel!
    @IBOutlet weak var feed4prgrmlBL: UILabel!
    @IBOutlet weak var feed5PrgrmLbl: UILabel!
    @IBOutlet weak var syncNotiCountLbl: UILabel!
    @IBOutlet weak var firstComma: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var secondComma: UILabel!
    @IBOutlet weak var thirdComma: UILabel!
    @IBOutlet weak var fourComma: UILabel!
    @IBOutlet weak var lblFeed: UILabel!
    @IBOutlet weak var lblAddVacci: UILabel!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var antiboticFreeOutlet: UIButton!
    @IBOutlet weak var sliderBtnOutlet: UIButton!
    @IBOutlet weak var feedProgramLabel: UILabel!
    @IBOutlet var maineView: UIView!
    @IBOutlet weak var metricBtnnOutlet: UIButton!
    @IBOutlet weak var backButtonFronNec: UIButton!
    @IBOutlet weak var imperialBtnOutlet: UIButton!
    @IBOutlet weak var addFeedProgramOutle: UIButton!
    @IBOutlet weak var addVaccinationOutlet: UIButton!
    @IBOutlet weak var feedProgramOutlet: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var conventionalBttnOutlet: UIButton!
    /********* Create All Iboutlet *****************************************/
    
    @IBOutlet weak var CustRepTextField: UITextField!
    @IBOutlet weak var birdSize: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var lblSessionType: UILabel!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnCustmer: UIButton!
    @IBOutlet weak var lblComplex: UILabel!
    @IBOutlet weak var lblCocieeProgram: UILabel!
    @IBOutlet weak var lblVeteration: UILabel!
    @IBOutlet weak var btnSessionType: UIButton!
    @IBOutlet weak var btnComplex: UIButton!
    @IBOutlet weak var btnCocciProgram: UIButton!
    @IBOutlet weak var btnVetration: UIButton!
    @IBOutlet weak var btnFarmMil: UIButton!
    @IBOutlet weak var btnAge: UIButton!
    @IBOutlet weak var btnFarm: UIButton!
    @IBOutlet weak var btnSales: UIButton!
    @IBOutlet weak var btnCustRep: UIButton!
    @IBOutlet weak var lblCustmer: UILabel!
    @IBOutlet weak var lblSelesRep: UILabel!
    @IBOutlet weak var txtNotes: UITextField!
    @IBOutlet weak var lblFarm: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblFormValue: UILabel!
    @IBOutlet weak var lblFieldMil: UILabel!
    @IBOutlet weak var lblAgeValue: UILabel!
    @IBOutlet weak var btnOpt1: UIButton!
    @IBOutlet weak var btnOpt2: UIButton!
    @IBOutlet weak var btnSickButton: UIButton!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var imperialLabel: UILabel!
    @IBOutlet weak var metricLabel: UILabel!
    @IBOutlet weak var lblChemicalIonophore: UILabel!
    @IBOutlet weak var maleBreedOutlet: UIButton!
    @IBOutlet weak var femaleBreedOutlet: UIButton!
    @IBOutlet weak var antiboticFree: UILabel!
    @IBOutlet weak var conventionalLabel: UILabel!
    @IBOutlet weak var birdSizeOutlet: UIButton!
    @IBOutlet weak var feedImagrIcon: UIImageView!
    @IBOutlet weak var addVacIcon: UIImageView!
    @IBOutlet weak var productionTypeBtn: UIButton!
    @IBOutlet weak var productionTypeLbl: UILabel!
    
    @IBOutlet weak var outTimeBtn: UIButton!
    @IBOutlet weak var outTimLbl: UILabel!
    @IBOutlet weak var outTimeTxtFld: UITextField!
    
    @IBOutlet weak var avgweightBtn: UIButton!
    @IBOutlet weak var lblAvgWeight: UILabel!
    @IBOutlet weak var avgWeightTxtFld: UITextField!
    
    @IBOutlet weak var avgAgeBtn: UIButton!
    @IBOutlet weak var avgAgeTxtFld: UITextField!
    @IBOutlet weak var lblAvgAge: UILabel!
    
    @IBOutlet weak var lblFCR: UILabel!
    @IBOutlet weak var fcrTxtFld: UITextField!
    @IBOutlet weak var fcrBtn: UIButton!
    
    @IBOutlet weak var lblMortality: UILabel!
    @IBOutlet weak var txtFldMortality: UITextField!
    @IBOutlet weak var btnMortalty: UIButton!
    
    @IBOutlet weak var lblLivability: UILabel!
    @IBOutlet weak var txtFldLivability: UITextField!
    @IBOutlet weak var btnLivability: UIButton!
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    let emptyDateLabel = "- Select Date -"
    let frenchEmptyDateLabel = " - Sélectionner une date -"
    let offlineMsg = Constants.offline
    let sameDateComplexValidationMsg = "Session for this date & complex already exist. Please select another date or complex."
    let mendatoryFieldsMsg = Constants.mandatoryFieldsMessage
    let ajouterStr = "Ajouter une vaccination"
    // MARK: ******************************************************
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(PostingViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        btnTag = 10
        
        notesTextView.delegate = self
        isClickOnAnyField = false
        objApiSync.delegeteSyncApi = self
        backButtonFronNec.alpha = 0
        UserDefaults.standard.set(false, forKey: "isNewPostingId")
        UserDefaults.standard.set(true, forKey: "SessionData")
        UserDefaults.standard.synchronize()
        doneButtonP.isUserInteractionEnabled = false
        doneButtonP.layer.borderWidth = 1
        doneButtonP.layer.cornerRadius = 4
        doneButtonP.layer.borderColor = UIColor.clear.cgColor
        
        lblDate.layer.borderWidth = 1
        lblDate.layer.cornerRadius = 5
        lblDate.layer.borderColor = UIColor.clear.cgColor
        
        impFeed = "Imperial"
        feedProgrmLbl2.isHidden = true
        feedProgramLbl.isHidden = true
        feed3PrgrmLbl.isHidden = true
        feed4prgrmlBL.isHidden = true
        feed5PrgrmLbl.isHidden = true
        
        nextButtonOutlet.isUserInteractionEnabled = false
        feedProgramLabel.isHidden = true
        firstComma.isHidden = true
        secondComma.isHidden = true
        thirdComma.isHidden = true
        fourComma.isHidden = true
        notesTextView.layer.borderColor = UIColor.black.cgColor
        
        
        let buttons: [UIButton] = [
            feedProgramOutlet, maleBreedOutlet, femaleBreedOutlet, birdSizeOutlet, btnDate,
            btnCustmer, btnComplex, btnCocciProgram, btnVetration, btnSales, btnSessionType,
            productionTypeBtn, avgweightBtn, avgAgeBtn, fcrBtn, btnMortalty, btnLivability, outTimeBtn
        ]
        
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 3.5
            button.layer.borderColor = UIColor.black.cgColor
        }
        
    }
    
    fileprivate func refactorViewWillAppear() {
        if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            postingId = UserDefaults.standard.integer(forKey: "necUnLinked")
            if appDelegate.sendFeedVariable == "Feed"{
                let value  = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
                if value.count>0 {
                    doneButtonP.isUserInteractionEnabled = true
                }
            }
        } else {
            postingId = UserDefaults.standard.integer(forKey: "postingId")
        }
    }
    
    fileprivate func refactorViewwillAppearPart2() {
        if feedProgramArray.count > 1 {
            
            let ftitle = NSMutableString()
            
            for i in 0..<feedProgramArray.count{
                
                var label = UILabel()
                let feepRGMR = (feedProgramArray.object(at: i) as AnyObject).value(forKey: "feddProgramNam") as! String
                
                if i == 0 {
                    label  = UILabel(frame: CGRect(x: 50, y: 519, width: 111, height: 21))
                    ftitle.append( feepRGMR + " " )
                } else {
                    label  = UILabel(frame: CGRect(x: 50, y: 519, width: 111*(CGFloat(i)+1)+10, height: 21))
                    ftitle.append(", " + feepRGMR + " " )
                }
                label.textAlignment = NSTextAlignment.center
                label.backgroundColor = UIColor.red
                feedProgramLbl.text = ftitle as String
            }
        }
    }
    
    fileprivate func handleViewWillAppearPart3SubFunction(_ isPostingId: Bool) {
        if isPostingId == false{
            
            if lngId == 4 {
                lblAddVacci.text = ""
            } else if lngId == 3 {
                lblAddVacci.text = self.ajouterStr
            } else {
                lblAddVacci.text = "Add vaccination"
            }
        } else {
            addVaccinationOutlet.backgroundColor = UIColor.gray
            if lngId == 3 {
                lblAddVacci.text = self.ajouterStr
            } else {
                lblAddVacci.text = "Edit vaccination"
            }
        }
    }
    
    fileprivate func refactorViewWillAppearPart3() {
        if appDelegate.isDoneClick == true {
            if UserDefaults.standard.bool(forKey: "Unlinked") == true {
                postingId = UserDefaults.standard.integer(forKey: "necUnLinked")
                lblComplex.text =  UserDefaults.standard.value(forKey: "complexUnlinked") as? String
                if lngId == 3 {
                    lblDate.text = UserDefaults.standard.value(forKey: "dateFrench") as? String
                } else {
                    strdate =  (UserDefaults.standard.value(forKey: "complexDateUnlinked") as? String)!
                    lblDate.text = strdate
                }
                strdate = (UserDefaults.standard.value(forKey: "complexDateUnlinked") as? String)!
            } else {
                postingId = UserDefaults.standard.integer(forKey: "postingId")
            }
            
            let isPostingId = UserDefaults.standard.bool(forKey: "ispostingIdIncrease")
            handleViewWillAppearPart3SubFunction(isPostingId)
        }
    }
    
    fileprivate func refactorViewWillAppearPart4() {
        feedProgramLbl.isHidden = false
        feedProgramOutlet.isHidden = false
        dropImageView.isHidden = false
        feedProgrmLbl2.isHidden = false
        feed3PrgrmLbl.isHidden = false
        feed4prgrmlBL.isHidden = false
        feed5PrgrmLbl.isHidden = false
        
        if appDelegate.metricOrImperialClick == "Metric" {
            impFeed = "Metric"
            metricBtnnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            imperialBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        } else {
            impFeed = "Imperial"
            metricBtnnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            imperialBtnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
        }
        
        if UserDefaults.standard.integer(forKey: "isBackWithoutFedd") == 0 {
            
            feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
            
            if feedProgramArray.count > 0 {
                addFeedProgramOutle.backgroundColor = UIColor.gray
                feedProgramOutlet.isHidden = false
                feedProgramOutlet.layer.borderWidth = 1
                feedProgramOutlet.layer.cornerRadius = 3.5
                feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
                dropImageView.isHidden = false
                feedProgramLabel.isHidden = false
            } else {
                addFeedProgramOutle.backgroundColor = UIColor.init(red: 1/255, green: 193/255, blue: 202/255, alpha: 1.0)
                feedProgramOutlet.isHidden = true
                dropImageView.isHidden = true
                feedProgramLabel.isHidden = true
            }
        } else {
            addFeedProgramOutle.backgroundColor = UIColor.gray
            feedProgramOutlet.isHidden = false
            feedProgramOutlet.layer.borderWidth = 1
            feedProgramOutlet.layer.cornerRadius = 3.5
            feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
            dropImageView.isHidden = false
            feedProgramLabel.isHidden = false
        }
    }
    
    fileprivate func refactorViewWillAppearPart5() {
        feedProgramLbl.isHidden = false
        feedProgramOutlet.isHidden = false
        dropImageView.isHidden = false
        feedProgrmLbl2.isHidden = false
        
        feed3PrgrmLbl.isHidden = false
        feed4prgrmlBL.isHidden = false
        feed5PrgrmLbl.isHidden = false
        
        feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        
        if feedProgramArray.count > 0 {
            addFeedProgramOutle.backgroundColor = UIColor.gray
            feedProgramOutlet.isHidden = false
            feedProgramOutlet.layer.borderWidth = 1
            feedProgramOutlet.layer.cornerRadius = 3.5
            feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
            dropImageView.isHidden = false
            feedProgramLabel.isHidden = false
        } else {
            addFeedProgramOutle.backgroundColor = UIColor.init(red: 1/255, green: 193/255, blue: 202/255, alpha: 1.0)
            feedProgramOutlet.isHidden = true
            dropImageView.isHidden = true
            feedProgramLabel.isHidden = true
        }
        
        if appDelegate.metricOrImperialClick == "Metric" {
            impFeed = "Metric"
            metricBtnnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            imperialBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        } else {
            impFeed = "Imperial"
            metricBtnnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            imperialBtnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
        }
    }
    
    fileprivate func refactorViewWillAppearPart6(_ vetNam: String) {
        if self.postingArray.count == 0 || vetNam == "" {
            
            lblVeteration.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            if lngId == 3 {
                lblDate.text =  frenchEmptyDateLabel
            }
            lblCustmer.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            CustRepTextField.text = ""
            lblSelesRep.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            maleLabel.text = NSLocalizedString("Male", comment: "")
            femaleLabel.text = NSLocalizedString("Female", comment: "")
            if lngId == 3 {
                lblSessionType.text = "Visite De Ferme"
            }
            if lngId == 4 {
                lblSessionType.text = "Visita Em Andamento"
                sessionTypeIdDb = 5
            } else {
                lblSessionType.text = "Farm Visit"
            }
            
            lblComplex.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            lblCocieeProgram.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            notesTextView.text = ""
            birdSize.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            breedIdDb = 0
            birdSizeIdDb = 0
            cocciProgramIdDb = 0
            complexIdDb = 0
            cusmerRepIdDb = 0
            salesRepIdDb = 0
            sessionTypeIdDb = 0
            custmetIdDb = 0
            productionIdDb = 0
            productionNameStr = ""
        } else {
            
            for i in 0..<postingArray.count {
                
                lblVeteration.text = (postingArray.value(forKey: "vetanatrionName") as AnyObject).object(at: i) as? String
                lblDate.text = (postingArray.value(forKey: "sessiondate") as AnyObject).object(at: i) as? String
                lblCustmer.text = (postingArray.value(forKey: "customerName") as AnyObject).object(at: i) as? String
                CustRepTextField.text = (postingArray.value(forKey: "customerRepName") as AnyObject).object(at: i) as? String
                lblSelesRep.text = (postingArray.value(forKey: "salesRepName") as AnyObject).object(at: i) as? String
                maleLabel.text = (postingArray.value(forKey: "mail") as AnyObject).object(at: i) as? String
                femaleLabel.text = (postingArray.value(forKey: "female") as AnyObject).object(at: i) as? String
                lblSessionType.text = (postingArray.value(forKey: "sessionTypeName") as AnyObject).object(at: i) as? String
                lblComplex.text = (postingArray.value(forKey: "complexName") as AnyObject).object(at: i) as? String
                lblCocieeProgram.text = (postingArray.value(forKey: "cociiProgramName") as AnyObject).object(at: i) as? String
                notesTextView.text = (postingArray.value(forKey: "notes") as AnyObject).object(at: i) as? String
                birdSize.text = (postingArray.value(forKey: "birdSize") as AnyObject).object(at: i) as? String
                productionNameStr = (postingArray.value(forKey: "productionTypeName") as AnyObject).object(at: i) as? String ?? ""
                
                
                avgAgeTxtFld.text = (postingArray.value(forKey: "avgAge") as AnyObject).object(at: i) as? String
                avgWeightTxtFld.text = (postingArray.value(forKey: "avgWeight") as AnyObject).object(at: i) as? String
                txtFldMortality.text = (postingArray.value(forKey: "dayMortality") as AnyObject).object(at: i) as? String
                txtFldLivability.text = (postingArray.value(forKey: "livability") as AnyObject).object(at: i) as? String
                fcrTxtFld.text = (postingArray.value(forKey: "fcr") as AnyObject).object(at: i) as? String
                outTimeTxtFld.text = (postingArray.value(forKey: "outTime") as AnyObject).object(at: i) as? String ?? ""
                
                let vetIdVal = (postingArray.value(forKey: "veterinarianId") as AnyObject).object(at: i) as? NSNumber
                let custmetIdDbVal = (postingArray.value(forKey: "customerId") as AnyObject).object(at: i) as? NSNumber
                let birdSizeIdDbVal = (postingArray.value(forKey: "birdSizeId") as AnyObject).object(at: i) as? NSNumber
                let breedIdDbVal = (postingArray.value(forKey: "birdBreedId") as AnyObject).object(at: i) as? NSNumber
                let salesRepIdDbVal = (postingArray.value(forKey: "salesRepId") as AnyObject).object(at: i) as? NSNumber
                let sessionTypeIdDbVal = (postingArray.value(forKey: "sessionTypeId") as AnyObject).object(at: i) as? NSNumber
                let postingIdDbVal = (postingArray.value(forKey: "postingId") as AnyObject).object(at: i) as? NSNumber
                let loginSessionIdDbVal = (postingArray.value(forKey: "loginSessionId") as AnyObject).object(at: i) as? NSNumber
                let complexIdDbVal = (postingArray.value(forKey: "complexId") as AnyObject).object(at: i) as? NSNumber
                let cocciProgramIdDbVal = (postingArray.value(forKey: "cocciProgramId") as AnyObject).object(at: i) as? NSNumber
                let productionTypeIdDbVal = (postingArray.value(forKey: "productionTypeId") as AnyObject).object(at: i) as? NSNumber
                
                custmetIdDb = custmetIdDbVal!
                cusmerRepIdDb = 1
                birdSizeIdDb = birdSizeIdDbVal!
                breedIdDb = breedIdDbVal!
                salesRepIdDb = salesRepIdDbVal!
                sessionTypeIdDb = sessionTypeIdDbVal!
                veterinartionIdDb = vetIdVal!
                postingIdDb = postingIdDbVal!
                loginSessionIdDb = loginSessionIdDbVal!
                complexIdDb = complexIdDbVal!
                cocciProgramIdDb = cocciProgramIdDbVal!
                productionIdDb = productionTypeIdDbVal!
            }
            if lngId == 3 {
                lblDate.text = strdateFrench
            }
        }
    }
    
    fileprivate func refactorViewWillAppearPart7() {
        if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            postingId = UserDefaults.standard.integer(forKey: "necUnLinked")
            lblComplex.text =  UserDefaults.standard.value(forKey: "complexUnlinked") as? String
            
            if lngId == 3 {
                lblDate.text = UserDefaults.standard.value(forKey: "dateFrench") as? String
            } else {
                strdate =  (UserDefaults.standard.value(forKey: "complexDateUnlinked") as? String)!
                lblDate.text = strdate
            }
            strdate = (UserDefaults.standard.value(forKey: "complexDateUnlinked") as? String)!
            
            if (UserDefaults.standard.value(forKey: "timeStamp") as? String) != nil{
                lblTimeStamp = lblTimestampUnlinked
            } else {
                let postingArr = CoreDataHandler().FetchNecropsystep1neccId(postingId as NSNumber)
                lblTimeStamp = (postingArr.object(at: 0) as AnyObject).value(forKey: "timeStamp") as! String
            }
            complexIdDb = unComplexId as NSNumber
            custmetIdDb = unCustId as NSNumber
            btnComplex.isUserInteractionEnabled = false
            btnDate.isUserInteractionEnabled = false
            sliderBtnOutlet.alpha = 0
            btnComplex.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.1)
            btnDate.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.1)
            doneButtonP.alpha = 1
            backButtonFronNec.alpha = 1
            nextButtonOutlet.alpha = 0
        } else {
            btnComplex.isUserInteractionEnabled = true
            btnDate.isUserInteractionEnabled = true
            doneButtonP.alpha = 0
            nextButtonOutlet.alpha = 1
            sliderBtnOutlet.alpha = 1
            backButtonFronNec.alpha = 0
        }
    }
    
    fileprivate func refactorViewWillAppearPart8() {
        if lngId == 3 {
            
            addVacIcon.frame = CGRect(x: 120, y: 724, width: 18, height: 18)
            feedImagrIcon.frame = CGRect(x: 399, y: 724, width: 18, height: 18)
            if(CoreDataHandler().fetchAddvacinationData(postingId as NSNumber).count == 0){
                lblAddVacci.text = self.ajouterStr
            } else {
                lblAddVacci.text = "Modifier la vaccination"
            }
            lblFeed.text = " Programme alimentaire"
        } else if lngId == 4 {
            let isPostingId = UserDefaults.standard.bool(forKey: "ispostingIdIncrease")
            if isPostingId == false{
                lblAddVacci.text = NSLocalizedString("Add Vaccination", comment: "")
                addVacIcon.frame = CGRect(x: 140, y: 722, width: 20, height: 20)
                feedImagrIcon.frame = CGRect(x: 430, y: 723, width: 20, height: 20)
            } else {
                lblAddVacci.text =  NSLocalizedString("Edit Vaccination", comment: "")
            }
            lblFeed.text = NSLocalizedString("Feed Program", comment: "")
            
        } else {
            let isPostingId = UserDefaults.standard.bool(forKey: "ispostingIdIncrease")
            if isPostingId == false{
                lblAddVacci.text = NSLocalizedString("Add Vaccination", comment: "")
                addVacIcon.frame = CGRect(x: 140, y: 722, width: 20, height: 20)
                feedImagrIcon.frame = CGRect(x: 430, y: 723, width: 20, height: 20)
            } else {
                lblAddVacci.text = "Edit Vaccination"
            }
            lblFeed.text = NSLocalizedString("Feed Program", comment: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notesTextView.textContainer.lineFragmentPadding = 12
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        isClickOnAnyField = false
        self.printSyncLblCount()
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        viewUpdate()
        
        refactorViewWillAppear()
        
        feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        if feedProgramArray.count == 1 {
            feedProgramLbl.text = (feedProgramArray.object(at: 0) as AnyObject).value(forKey: "feddProgramNam") as? String
        }
        refactorViewwillAppearPart2()
        
        CustRepTextField.delegate = self
        if let data = CoreDataHandler().fectCustomerRepWithCustomername(1) as? NSArray {
            fetchcustRep = data
        }
        
        buttonDroper.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonDroper.addTarget(self, action: #selector(PostingViewController.buttonPressedDroper), for: .touchUpInside)
        buttonDroper.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonDroper)
        autoSerchTable.delegate = self
        autoSerchTable.dataSource = self
        autoSerchTable.delegate = self
        autoSerchTable.layer.cornerRadius = 7
        autoSerchTable.layer.borderWidth = 1
        autoSerchTable.layer.borderColor = UIColor.black.cgColor
        self.autoSerchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        buttonDroper .addSubview(autoSerchTable)
        buttonDroper.alpha = 0
        autoSerchTable.alpha = 0
        feedProgramOutlet.isHidden = true
        
        if (newColor > 0) {
            feedProgramOutlet.layer.borderWidth = 1
            feedProgramOutlet.layer.cornerRadius = 3.5
            feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
        }
        refactorViewWillAppearPart3()
        
        if appDelegate.isFeedProgramClick == true {
            appDelegateObj.testFuntion()
        }
        
        if appDelegate.sendFeedVariable == "Feed" {
            refactorViewWillAppearPart4()
        } else if appDelegate.sendFeedVariable == "vaccination" {
            refactorViewWillAppearPart5()
        }
        
        feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            postingId = UserDefaults.standard.integer(forKey: "necUnLinked")
        } else {
            postingId = UserDefaults.standard.integer(forKey: "postingId")
        }
        
        if feedProgramArray.count > 0 {
            nextButtonOutlet.backgroundColor = UIColor(red: 11/255, green:88/255, blue:160/255, alpha:1)
            nextButtonOutlet.isUserInteractionEnabled = true
        } else {
            nextButtonOutlet.backgroundColor = UIColor.lightGray
            nextButtonOutlet.isUserInteractionEnabled = false
        }
        
        /**********Ffeth data of posting session from Db **********/
        self.postingArray = CoreDataHandler().fetchAllPostingSession(postingId as NSNumber)
        var vetNam = String()
        if self.postingArray.count > 0 {
            let vetName :  PostingSession =  self.postingArray.object(at: 0) as! PostingSession
            vetNam = vetName.vetanatrionName!
        }
        
        refactorViewWillAppearPart6(vetNam)
        refactorViewWillAppearPart7()
        refactorViewWillAppearPart8()
    }
    
    /****************** Crteating Custom tableView ********************************/
    func tableViewpop()  {
        buttonbg2.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonbg2.addTarget(self, action: #selector(PostingViewController.buttonPressed1), for: .touchUpInside)
        buttonbg2.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view.addSubview(buttonbg2)
        titleView.backgroundColor = UIColor.clear
        buttonbg2.addSubview(titleView)
        droperTableView.delegate = self
        droperTableView.dataSource = self
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.black.cgColor
        buttonbg2.addSubview(droperTableView)
    }
    
    @objc func buttonPressed1() {
        lalTitle.alpha = 0
        buttonbg2.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setScaleArr(_ allBireType: NSArray) {
        for dict in allBireType {
            if (dict as AnyObject).value(forKey: "scaleType") as! String == "Imperial"{
                birdArray.append(dict as! BirdSizePosting)
            }
            else{
                metricArray.append(dict as! BirdSizePosting)
            }
        }
    }
    
    func viewUpdate () {
        
        butttnTag  = 1
        dropImageView.isHidden = true
        let arrayAllBreed = CoreDataHandler().fetchBreedType()
        if(femaleArr.count == 0){
            for dict in arrayAllBreed {
                if ((dict as AnyObject).value(forKey: "breedType") as! String).contains("F") && (dict as AnyObject).value(forKey: "languageId") as! Int == lngId {
                    femaleArr.append(dict as! Breed)
                }
                else if ((dict as AnyObject).value(forKey: "breedType") as! String).contains("M") && (dict as AnyObject).value(forKey: "languageId") as! Int == lngId {
                    breedArray.append(dict as! Breed)
                }
            }
        }
        let allBireType = CoreDataHandler().fetchBirdSize()
        if(birdArray.count == 0){
            setScaleArr(allBireType)
        }
        droperTableView.reloadData()
        feedProgramLbl.isHidden = true
        self.CustRepTextField.resignFirstResponder()
        self.notesTextView.resignFirstResponder()
        self.CustRepTextField.delegate = self
        self.notesTextView.delegate = self
    }
    
    @objc func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
    
    // MARK: 🟠 - Next Button Action
    
    @IBAction func nextBtnAction(_ sender: AnyObject) {
        
        if (lblCustmer.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "") ||
            lblComplex.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "")   || lblVeteration.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblDate.text! == NSLocalizedString(emptyDateLabel, comment: "")){
            
            btnDate.layer.borderColor = UIColor.red.cgColor
            btnCustmer.layer.borderColor = UIColor.red.cgColor
            btnVetration.layer.borderColor = UIColor.red.cgColor
            btnComplex.layer.borderColor = UIColor.red.cgColor
            
            if lblCustmer.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
                btnCustmer.layer.borderColor = UIColor.black.cgColor
            }
            if lblComplex.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
                btnComplex.layer.borderColor = UIColor.black.cgColor
            }
            if lblVeteration.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
                btnVetration.layer.borderColor = UIColor.black.cgColor
            }
            if lblDate.text != NSLocalizedString(emptyDateLabel, comment: "") {
                btnDate.layer.borderColor = UIColor.black.cgColor
            }
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldsMsg, comment: ""))
        }
        else
        {
            
            let postingData = chickenCoreDataHandlerModels.updatePostingSessionData(
                antiboitic: antiboticFree.text!,
                birdBreesId: breedIdDb,
                birdbreedName: "",
                birdBreedType: "",
                birdSize: birdSize.text!,
                birdSizeId: birdSizeIdDb,
                cocciProgramId: cocciProgramIdDb,
                cociiProgramName: lblCocieeProgram.text!,
                complexId: complexIdDb,
                complexName: lblComplex.text!,
                convential: "",
                customerId: custmetIdDb,
                customerName: lblCustmer.text!,
                customerRepId: cusmerRepIdDb,
                customerRepName: CustRepTextField.text!,
                imperial: "",
                metric: "",
                notes: notesTextView.text,
                salesRepId: salesRepIdDb,
                salesRepName: lblSelesRep.text!,
                sessiondate: strdate,
                sessionTypeId: sessionTypeIdDb,
                sessionTypeName: lblSessionType.text!,
                vetanatrionName: lblVeteration.text!,
                veterinarianId: veterinartionIdDb,
                loginSessionId: 1,
                postingId: postingId as NSNumber,
                mail: maleLabel.text!,
                female: femaleLabel.text!,
                finilize: 0,
                isSync: true,
                timeStamp: lblTimeStamp,
                lngId: lngId as NSNumber,
                productionTypName: productionNameStr,
                productionTypId: productionIdDb,
                avgAge: avgAgeTxtFld.text!,
                avgWeight: avgWeightTxtFld.text!,
                outTime: outTimeTxtFld.text!,
                FCR: fcrTxtFld.text!,
                Livability: txtFldLivability.text!,
                mortality: txtFldMortality.text!
            )

            CoreDataHandler().updatePostingSessionForNextButton(postingData: postingData)

            
            
            UserDefaults.standard.set( birdSize.text, forKey: "targetWeight")
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "Step1") as? captureNecropsyStep1Data
            mapViewControllerObj?.custmerIdFarm = custmetIdDb
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
        
    }
    // MARK: 🟠 - Antibiotic Button Action
    @IBAction func antiboticFreeAction(_ sender: UIButton) {
        view.endEditing(true)
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            antiboticFreeOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            conventionalBttnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
    }
    // MARK: 🟠 - Conventional Button Action
    @IBAction func conventionalBttnAction(_ sender: UIButton) {
        autoSerchTable.alpha = 0
        view.endEditing(true)
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            conventionalBttnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            antiboticFreeOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
    }
    // MARK: 🟠 - Metric Button Action
    @IBAction func metricBtnAction(_ sender: UIButton) {
        
        impFeed = "Metric"
        appDelegate.metricOrImperialClick = "Metric"
        view.endEditing(true)
        
        birdSize.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        butttnTag = 0
        UserDefaults.standard.set(0, forKey: "targetWeightSelection")
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            metricBtnnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            imperialBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        if indexOfSelectedPerson == 1111111{
            birdSize.text = "- Select - "
        }else {
            let sdds = metricArray[indexOfSelectedPerson]
            birdSize.text = sdds.birdSize
        }
    }
    // MARK: 🟠 - Imperial Button Action
    @IBAction func imperialBtnAction(_ sender: UIButton) {
        
        appDelegate.metricOrImperialClick = "Imperial"
        impFeed = "Imperial"
        view.endEditing(true)
        birdSize.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        butttnTag = 1
        UserDefaults.standard.set(1, forKey: "targetWeightSelection")
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            imperialBtnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            metricBtnnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        
        if indexOfSelectedPerson == 1111111{
            birdSize.text = "- Select - "
        }else {
            let sdds = birdArray[indexOfSelectedPerson]
            birdSize.text = sdds.birdSize
        }
    }
    // MARK: 🟠 - Side Menu Button Action
    @IBAction func sideMenuButtonPress(_ sender: AnyObject) {
        
        let value  = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        
        if value.count>0{
            NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
        }
        else
        {
            if lblCustmer.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblComplex.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblVeteration.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
                self.showAlert()
            }
            else{
                NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
            }
        }
    }
    // MARK: 🟠 - Date Button Action
    @IBAction func didSelectOnDateButton(_ sender: AnyObject) {
        
        view.endEditing(true)
        btnDate.layer.borderColor = UIColor.black.cgColor
        let buttons  = CommonClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonBg.addTarget(self, action: #selector(PostingViewController.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(PostingViewController.doneClick)
        
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(PostingViewController.cancelClick)
        
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
        
    }
    
    // MARK: 🟠 Date Picker Done and Cancel
    @objc func doneClick() {
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 3{
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat=Constants.ddMMyyyStr
            strdateFrench = dateFormatter2.string(from: datePicker.date) as String
            
            let dateFormatter3 = DateFormatter()
            dateFormatter3.dateFormat=Constants.MMddyyyyStr
            
            strdate = dateFormatter3.string(from: datePicker.date) as String
            lblDate.text = strdateFrench
        }
        else{
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat=Constants.MMddyyyyStr
            strdate = dateFormatter2.string(from: datePicker.date) as String
            lblDate.text = strdate
        }
        
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat="MM/dd/yyyy/HH:mm:ss"
        let strdate1 = dateFormatter3.string(from: datePicker.date) as String
        
        lblTimeStamp = strdate1
        
        if  lblComplex.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "")
        {
            print("Test Body")
        }
        else
        {
            if checkComplexNameandDate(strdate, complexName: lblComplex.text!) == true
            {
                let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: NSLocalizedString(sameDateComplexValidationMsg, comment: ""), preferredStyle: .alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.lblComplex.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
                    self.lblVeteration.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                isClickOnAnyField = true
            }
        }
        
        UserDefaults.standard.set( strdate, forKey: "date")
        UserDefaults.standard.set( strdateFrench, forKey: "dateFrench")
        UserDefaults.standard.set( lblTimeStamp, forKey: "timeStamp")
        UserDefaults.standard.synchronize()
        buttonBg.removeFromSuperview()
    }
    // MARK: 🟠  Cancel Button Action
    @objc func cancelClick() {
        buttonBg.removeFromSuperview()
    }
    
    @objc func buttonPressed() {
        buttonBg.removeFromSuperview()
    }
    // MARK: 🟠 Select Customer action
    @IBAction func didSelectOnCustmerButton(_ sender: AnyObject) {
        
        btnCustmer.layer.borderColor = UIColor.black.cgColor
        view.endEditing(true)
        
        btnTag = 0
        if custmerArray.count == 0 {
            
            if UserDefaults.standard.bool(forKey: "Unlinked") == true {
                custmerArray = CoreDataHandler().fetchCustomerWithCustId(unCustId as NSNumber)
            }
            else {
                custmerArray = CoreDataHandler().fetchCustomer()
                lblComplex.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
                lblVeteration.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            }
        }
        else{
            if UserDefaults.standard.bool(forKey: "Unlinked") == false {
                lblVeteration.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
                lblComplex.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            }
        }
        
        tableViewpop()
        
        if custmerArray.count < 3 {
            droperTableView.frame = CGRect( x: 238, y: 218, width: 270, height: 120)
        }
        else{
            droperTableView.frame = CGRect( x: 238, y: 218, width: 270, height: 220)
        }
        
        droperTableView.reloadData()
    }
    // MARK: 🟠  Select Sales Rep action
    @IBAction func didSelectSalesRepButton(_ sender: AnyObject) {
        view.endEditing(true)
        btnTag = 1
        
        if SalesRepArr.count == 0 {
            SalesRepArr = CoreDataHandler().fetchSalesrep()
        }
        
        tableViewpop()
        
        if SalesRepArr.count < 3 {
            droperTableView.frame = CGRect( x: 238, y: 349, width: 270, height: 80)
        }
        else{
            droperTableView.frame = CGRect( x: 238, y: 349, width: 270, height: 220)
        }
        droperTableView.reloadData()
        
    }
    // MARK: 🟠 Select Vaccination action
    fileprivate func setBorderValiadtionForVetComplexCustomer() {
        if lblCustmer.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
            btnCustmer.layer.borderColor = UIColor.black.cgColor
        }
        if lblComplex.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
            btnComplex.layer.borderColor = UIColor.black.cgColor
        }
        if lblVeteration.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
            btnVetration.layer.borderColor = UIColor.black.cgColor
        }
        
         lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 3{
            if  lblDate.text != frenchEmptyDateLabel{
                btnDate.layer.borderColor = UIColor.black.cgColor
            }
        }
        else{
            if lblDate.text != NSLocalizedString(emptyDateLabel, comment: "") {
                btnDate.layer.borderColor = UIColor.black.cgColor
            }
        }
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldsMsg, comment: ""))
    }
    
    @IBAction func didSelectOnVaccinationProgram(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
        UserDefaults.standard.synchronize()
        autoSerchTable.alpha = 0
        view.endEditing(true)
        
        if (lblCustmer.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "") ||
            lblComplex.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "")  || lblVeteration.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblVeteration.text! == "" || lblDate.text! == NSLocalizedString(emptyDateLabel, comment: "") || lblCustmer.text! == "" ||
            lblComplex.text! == "" || birdSize.text! == ""  || lblVeteration.text! == "" || lblVeteration.text! == "" || lblDate.text! == "" || lblDate.text == frenchEmptyDateLabel){
            if lblDate.text == frenchEmptyDateLabel || lblDate.text == NSLocalizedString(emptyDateLabel, comment: "") {
                self.btnDate.layer.borderColor = UIColor.red.cgColor
            }
            
            btnCustmer.layer.borderColor = UIColor.red.cgColor
            btnVetration.layer.borderColor = UIColor.red.cgColor
            btnComplex.layer.borderColor = UIColor.red.cgColor
            
            setBorderValiadtionForVetComplexCustomer()
            
        } else {
            
            let isPostingId = UserDefaults.standard.bool(forKey: "ispostingIdIncrease")
            if isPostingId == false
            {
                let nec =  UserDefaults.standard.bool(forKey: "nec")
                if nec == true {
                    
                    if UserDefaults.standard.bool(forKey: "Unlinked") == true
                    {
                        postingId = UserDefaults.standard.integer(forKey: "necUnLinked")
                    }
                    else{
                        CoreDataHandler().autoIncrementidtable()
                        let autoD  = CoreDataHandler().fetchFromAutoIncrement()
                        postingId = autoD
                    }
                }
                UserDefaults.standard.set(postingId, forKey: "necIdIsZero")
                UserDefaults.standard.set(postingId, forKey: "postingId")
                UserDefaults.standard.set(true, forKey: "ispostingIdIncrease")
                UserDefaults.standard.synchronize()
                savePostingData()
            }
            else
            {
                UserDefaults.standard.set(postingId, forKey: "postingId")
                UserDefaults.standard.synchronize()
            }
            if isClickOnAnyField == true && isPostingId == true
            {
                savePostingData()
                isClickOnAnyField = false
            }
            
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "add") as? AddVaccinationViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
        
    }
    // MARK: 🟠 Validation check for Complex Name & Date
    func checkComplexNameandDate(_ date : String, complexName: String) -> Bool {
        var isComplexandDateExist : Bool = false
        
        let postingSessionArray =  CoreDataHandler().fetchAllPostingExistingSession() as NSArray
        for i in 0..<postingSessionArray.count
        {
            let pSession = postingSessionArray.object(at: i) as! PostingSession
            let sessionDate = pSession.sessiondate! as String
            let sessionPostingId = pSession.postingId! as! Int
            let sessioncomplexName = pSession.complexName! as String
            if sessionPostingId == UserDefaults.standard.integer(forKey: "postingId"){
                break
            }
            else{
                if (sessionDate == date) && (sessioncomplexName == complexName)
                {
                    isComplexandDateExist = true
                    break
                }
            }
        }
        let necArray =  CoreDataHandler().FetchNecropsystep1neccIdAll() as NSArray
        
        for i in 0..<necArray.count
        {
            let necSession = necArray.object(at: i) as! CaptureNecropsyData
            let sessionDate = necSession.complexDate! as String
            let sessioncomplexName = necSession.complexName! as String
            if (sessionDate == date) && (sessioncomplexName == complexName)
            {
                isComplexandDateExist = true
                break
            }
        }
        return isComplexandDateExist
    }
    // MARK: 🟠  Feed Program Button action
    fileprivate func checkValidationOnFeedProgramBtn() {
        if lblDate.text == frenchEmptyDateLabel || lblDate.text == NSLocalizedString(emptyDateLabel, comment: "") {
            self.btnDate.layer.borderColor = UIColor.red.cgColor
        }
        
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldsMsg, comment: ""))
        
        btnCustmer.layer.borderColor = UIColor.red.cgColor
        btnVetration.layer.borderColor = UIColor.red.cgColor
        btnComplex.layer.borderColor = UIColor.red.cgColor
        
        if lblCustmer.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
            btnCustmer.layer.borderColor = UIColor.black.cgColor
        }
        if lblComplex.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
            btnComplex.layer.borderColor = UIColor.black.cgColor
        }
        if lblVeteration.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") {
            btnVetration.layer.borderColor = UIColor.black.cgColor
        }
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 3 {
            if lblDate.text != NSLocalizedString(frenchEmptyDateLabel, comment: "") {
                btnDate.layer.borderColor = UIColor.black.cgColor
            }
        }
        else{
            if lblDate.text != NSLocalizedString(emptyDateLabel, comment: "") {
                btnDate.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    fileprivate func handleSendFeedVariableValidation() {
        if appDelegate.sendFeedVariable == "Feed" {
            navStr = UserDefaults.standard.object(forKey: "back") as! String
            if navStr == "back" {
                let strVal = UserDefaults.standard.object(forKey: "feed0") as! String
                
                if feedId == 0 && strVal == "feed0" {
                    feedId = 0
                } else {
                    feedId = feedId+1
                }
            } else {
                    feedId = feedId+1
            }
        } else {
            if feedId == -1 {
                feedId = 0
                UserDefaults.standard.set(1, forKey: "isFeed")
                UserDefaults.standard.synchronize()
            } else {
                feedId = feedId+1
            }
        }
    }
    
    fileprivate func handlePostingIdValidationDidSelectOnAddFeedProgram() {
        let nec =  UserDefaults.standard.bool(forKey: "nec")
        if nec == true {
            if UserDefaults.standard.bool(forKey: "Unlinked") == true {
                postingId = UserDefaults.standard.integer(forKey: "necUnLinked")
            } else {
                CoreDataHandler().autoIncrementidtable()
                let autoD  = CoreDataHandler().fetchFromAutoIncrement()
                postingId = autoD
            }
        }
        UserDefaults.standard.set(postingId, forKey: "necIdIsZero")
        UserDefaults.standard.set(postingId, forKey: "postingId")
        UserDefaults.standard.set(true, forKey: "ispostingIdIncrease")
        UserDefaults.standard.synchronize()
        savePostingData()
    }
    
    @IBAction func didSelectOnAddFeedProgram(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
        UserDefaults.standard.synchronize()
        autoSerchTable.alpha = 0
        view.endEditing(true)
        
        if (lblCustmer.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "") ||
            lblComplex.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblVeteration.text! == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblVeteration.text! == "" || lblDate.text! == NSLocalizedString(emptyDateLabel, comment: "") || lblCustmer.text! == "" ||
            lblComplex.text! == "" || birdSize.text! == ""  || lblVeteration.text! == "" || lblVeteration.text! == "" || lblDate.text! == "" || lblDate.text == frenchEmptyDateLabel) {
            
            checkValidationOnFeedProgramBtn()
        } else {
            let isPostingId = UserDefaults.standard.bool(forKey: "ispostingIdIncrease")
            if isPostingId == false {
                handlePostingIdValidationDidSelectOnAddFeedProgram()
            } else if isClickOnAnyField == true && isPostingId == true {
                savePostingData()
                isClickOnAnyField = false
            }
            
            feedId = UserDefaults.standard.integer(forKey: "feedId")
            
            handleSendFeedVariableValidation()
            UserDefaults.standard.set(feedId, forKey: "feedId")
            UserDefaults.standard.synchronize()
            
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "feed") as? FeedProgramViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
    }
    // MARK: 🟠  Save Posting Data in local Database
    func savePostingData () {
        
        self.validationsCheck()
        self.otherValidationsCheck()
        
        custRep.add( CustRepTextField.text!)
        UserDefaults.standard.set(custRep, forKey: "cust")
        CoreDataHandler().postCustomerReps(CustRepTextField.text!, userid: 1)
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            self.postingId = UserDefaults.standard.integer(forKey: "necUnLinked")
        } else {
            self.postingId = UserDefaults.standard.integer(forKey: "postingId")
        }
        lblTimeStamp = self.timeStamp()
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
        let postingData = chickenCoreDataHandlerModels.chickenPostingSessionData(
            antiboitic: antiboticFree.text!,
              birdBreesId: breedIdDb,
              birdbreedName: "",
              birdBreedType: "",
              birdSize: birdSize.text!,
              birdSizeId: birdSizeIdDb,
              cocciProgramId: cocciProgramIdDb,
              cociiProgramName: lblCocieeProgram.text!,
              complexId: complexIdDb,
              complexName: lblComplex.text!,
              convential: "",
              customerId: custmetIdDb,
              customerName: lblCustmer.text!,
              customerRepId: cusmerRepIdDb,
              customerRepName: CustRepTextField.text!,
              imperial: "",
              metric: "",
              notes: notesTextView.text,
              salesRepId: salesRepIdDb,
              salesRepName: lblSelesRep.text!,
              sessiondate: strdate,
              sessionTypeId: sessionTypeIdDb,
              sessionTypeName: lblSessionType.text!,
              vetanatrionName: lblVeteration.text!,
              veterinarianId: veterinartionIdDb,
              loginSessionId: 1,
              postingId: self.postingId as NSNumber,
              mail: maleLabel.text!,
              female: femaleLabel.text!,
              finilize: 0,
              isSync: true,
              timeStamp: lblTimeStamp,
              lngId: lngId as NSNumber,
              productionTypName: productionNameStr,
              productionTypId: productionIdDb,
              avgAge: avgAgeTxtFld.text!,
              avgWeight: avgWeightTxtFld.text!,
              outTime: outTimeTxtFld.text!,
              FCR: fcrTxtFld.text!,
              Livability: txtFldLivability.text!,
              mortality: txtFldMortality.text!
        )

        CoreDataHandler().PostingSessionDb(postingData)
        
        
        
        
        UserDefaults.standard.synchronize()
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            CoreDataHandler().updateFinalizeDataWithNec(self.postingId as NSNumber, finalizeNec: 1)
            UserDefaults.standard.set(self.postingId, forKey: "postingId")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func validationsCheck()
    {
        if (antiboticFree.text == nil){
            antiboticFree.text = ""
        }else if (birdSize.text == nil){
            birdSize.text = ""
        }else if (lblVeteration.text == nil){
            lblVeteration.text = ""
        }else if (lblCocieeProgram.text == nil){
            lblCocieeProgram.text = ""
        }else if (lblComplex.text == nil){
            lblComplex.text = ""
        }else if (lblCustmer.text == nil){
            lblCustmer.text = ""
        }else if (CustRepTextField.text == nil){
            CustRepTextField.text = ""
        }else if (notesTextView.text == nil){
            notesTextView.text = ""
        }else if (lblSelesRep.text == nil){
            lblSelesRep.text = ""
        }else if (lblDate.text == nil){
            lblDate.text = ""
        }else if (lblSessionType.text == nil){
            lblSessionType.text = ""
        }else if (maleLabel.text == nil){
            maleLabel.text = ""
        }else if (femaleLabel.text == nil){
            femaleLabel.text = ""
        }else if (avgAgeTxtFld.text == nil){
            avgAgeTxtFld.text = ""
        }else if (avgWeightTxtFld.text == nil){
            avgWeightTxtFld.text = ""
        }
    }
    
    func otherValidationsCheck()
    {
        if (fcrTxtFld.text == nil){
           fcrTxtFld.text = ""
       }else if (txtFldLivability.text == nil){
           txtFldLivability.text = ""
       }else if (outTimeTxtFld.text == nil){
           outTimeTxtFld.text = ""
       }else if (txtFldMortality.text == nil){
           txtFldMortality.text = ""
       }else if (breedIdDb == 0){
           breedIdDb = 0
       }else if (birdSizeIdDb == 0){
           birdSizeIdDb = 0
       }else if (cocciProgramIdDb == 0){
           cocciProgramIdDb = 0
       }else if (complexIdDb == 0) {
           complexIdDb = 0
       }else if (cusmerRepIdDb == 0) {
           cusmerRepIdDb = 0
       }else if (salesRepIdDb == 0) {
           salesRepIdDb = 0
       }else if (sessionTypeIdDb == 0) {
           sessionTypeIdDb = 0
       }else if (veterinartionIdDb == 0) {
           veterinartionIdDb = 0
       }else if (productionIdDb == 0) {
           productionIdDb = 0
       }
    }
    
    func timeStamp()-> String{
        lblTimeStamp = lblTimeStamp.replacingOccurrences(of: "/", with: "", options: .regularExpression)
        lblTimeStamp = lblTimeStamp.replacingOccurrences(of: ":", with: "", options: .regularExpression)
        let string = lblTimeStamp as String
        let character: Character = "i"
        if ((string).contains(character)) {
            debugPrint("character not found.")
        } else {
            let  udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")! as! String
            let sessionGUID1 =   lblTimeStamp + "_" + String(describing: postingId as NSNumber)
            lblTimeStamp = sessionGUID1 + "_" + "iOS" + "_" + String(udid)
        }
        return lblTimeStamp
    }
    // MARK: 🟠 Cocci Program Button action
    @IBAction func didSelectonCociiProgramm(_ sender: UIButton) {
        autoSerchTable.alpha = 0
         lngId = UserDefaults.standard.integer(forKey: "lngId")
        view.endEditing(true)
        btnTag = 4
        
        if CocoiiProgramArr.count == 0 {
            CocoiiProgramArr = CoreDataHandler().fetchCocoiiProgramLngId(lngId: lngId as NSNumber)
        }
        
        tableViewpop()
        if CocoiiProgramArr.count < 3 {
            droperTableView.frame = CGRect( x: 715, y: 348, width: 270, height: 120)
        }
        else{
            droperTableView.frame = CGRect( x: 715, y: 348, width: 270, height: 220)
        }
        droperTableView.reloadData()
    }
    // MARK: 🟠 Complex Button Action
    @IBAction func didSelectOnComplex(_ sender: AnyObject) {
        
        btnComplex.layer.borderColor = UIColor.black.cgColor
        view.endEditing(true)
        
        if lblCustmer.text == NSLocalizedString(appDelegateObj.selectStr, comment: "")  {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please select a customer first.", comment: ""))
        }
        else{
            btnTag = 3
            tableViewpop()
            if complexArr.count < 4 {
                droperTableView.frame = CGRect( x: 715, y: 218, width: 270, height: 130)
            }
            else{
                droperTableView.frame = CGRect( x: 715, y: 218, width: 270, height: 190)
            }
            droperTableView.reloadData()
        }
    }
    // MARK: 🟠  Vetenarian Button action
    @IBAction func didSelectOnVeteration(_ sender: AnyObject) {
        if checkComplexNameandDate(strdate, complexName: lblComplex.text!) == true
        {
            if UserDefaults.standard.bool(forKey: "Unlinked") == true
            {
                btnTag = 8
                tableViewpop()
                if VetrationArr.count < 4 {
                    droperTableView.frame = CGRect( x: 715, y: 284, width: 270, height: 100)
                }
                else{
                    droperTableView.frame = CGRect( x: 715, y: 284, width: 270, height: 190)
                }
                if UserDefaults.standard.bool(forKey: "Unlinked") == true
                {
                    droperTableView.frame = CGRect( x: 715, y: 284, width: 270, height: 190)
                    VetrationArr = CoreDataHandler().fetchVetData()
                }
                droperTableView.reloadData()
            }
            else{
                let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message:NSLocalizedString(sameDateComplexValidationMsg, comment: "") , preferredStyle: .alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.lblComplex.text = ""
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else{
            VetrationArr = CoreDataHandler().fetchVetData()
            btnVetration.layer.borderColor = UIColor.black.cgColor
            view.endEditing(true)
            if lblComplex.text == NSLocalizedString(appDelegateObj.selectStr, comment: "")  {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please select a complex first.", comment: ""))
            }
            else{
                btnTag = 8
                tableViewpop()
                if VetrationArr.count < 4 {
                    droperTableView.frame = CGRect( x: 715, y: 284, width: 270, height: 100)
                }
                else{
                    droperTableView.frame = CGRect( x: 715, y: 284, width: 270, height: 190)
                }
                if UserDefaults.standard.bool(forKey: "Unlinked") == true
                {
                    droperTableView.frame = CGRect( x: 715, y: 284, width: 270, height: 190)
                    VetrationArr = CoreDataHandler().fetchVetData()
                    
                }
                droperTableView.reloadData()
            }
        }
    }
    // MARK: 🟠 Session Type Button Action
    @IBAction func didSelectbtnSessionType(_ sender: AnyObject) {
        autoSerchTable.alpha = 0
         lngId =    UserDefaults.standard.integer(forKey: "lngId")
        view.endEditing(true)
        btnTag = 2
        
        if sessionTypeArr.count == 0 {
            sessionTypeArr = CoreDataHandler().fetchSessiontypeLngId(lngId: lngId as NSNumber)
        }
        tableViewpop()
        if sessionTypeArr.count < 3 {
            droperTableView.frame = CGRect( x: 715, y: 154, width: 270, height: 120)
        }
        else{
            droperTableView.frame = CGRect( x: 715, y: 154, width: 270, height: 200)
        }
        droperTableView.reloadData()
    }
    // MARK: 🟠  Male Breed Button action
    @IBAction func maleBreedAction(_ sender: AnyObject) {
        view.endEditing(true)
        btnTag = 6
        tableViewpop()
        droperTableView.frame = CGRect( x: 238, y: 415, width: 190, height: 170)
        droperTableView.reloadData()
    }
    // MARK: 🟠 Female Breed Button Action
    @IBAction func femalBreedAction(_ sender: AnyObject) {
        view.endEditing(true)
        btnTag = 7
        tableViewpop()
        droperTableView.frame = CGRect( x: 380, y: 415, width: 190, height: 170)
        droperTableView.reloadData()
    }
    // MARK: 🟠  Production type Button action
    @IBAction func productionTypeBtnAction(_ sender: Any) {
        view.endEditing(true)
        btnTag = 11
         lngId = UserDefaults.standard.integer(forKey: "lngId")
        ProductionTypeArr = CoreDataHandler().fetchProductionType(lngID: lngId )
        tableViewpop()
        droperTableView.frame = CGRect( x: 240, y: 475, width: 270, height: 135)
        droperTableView.reloadData()
    }
    // MARK: 🟠  Bird Size Button action
    @IBAction func birdSizeAction(_ sender: AnyObject) {
        birdSizeOutlet.layer.borderColor = UIColor.black.cgColor
        view.endEditing(true)
        btnTag = 5
      
            tableViewpop()
            droperTableView.frame = CGRect( x: 715, y: 413, width: 276, height: 200)
            droperTableView.reloadData()
        
    }
    // MARK: 🟠 Hide Dropdown
    @IBAction func tapOnView(_ sender: AnyObject) {
        bgView.endEditing(true)
        hideDropDown()
    }
    // MARK: 🟠  Back Button action
    @IBAction func back_bttn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        self.touchesBegan(touches, with: event)
    }
    
    func animateView (_ movement : CGFloat){
        UIView.animate(withDuration: 0.1, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement);
        })
    }
    // MARK: 🟠  Feed Program Button action
    @IBAction func feedProgramAction(_ sender: AnyObject) {
        view.endEditing(true)
        btnTag = 9
        feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        
        if feedProgramArray.count<3 {
            tableViewpop()
            droperTableView.frame = CGRect( x: 400, y: 555, width: 280, height: 100)
            droperTableView.reloadData()
        }
        else{
            tableViewpop()
            droperTableView.frame = CGRect( x: 400, y: 555, width: 280, height: 160)
            droperTableView.reloadData()
        }
        
    }
    
    @IBAction func tapOnMainView(_ sender: AnyObject) {
        maineView.endEditing(true)
    }
    // MARK: 🟠 Load Logout popUp
    @IBAction func logOutBttn(_ sender: AnyObject) {
        clickHelpPopUp()
    }
    // MARK: 🟠 Side Menu action
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out"
        {
            UserDefaults.standard.removeObject(forKey: "login")
            if ConnectionManager.shared.hasConnectivity() {
                self.ssologoutMethod()
                CoreDataHandler().deleteAllData("Custmer")
            } else {
                Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(offlineMsg, comment: ""))
            }
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            buttonbg2.removeFromSuperview()
            customPopView1.removeView(view)
        }
    }
    
    // MARK: 🟠  /*********** Logout SSO Account **************/
    func ssologoutMethod()
    {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                debugPrint(data)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // MARK: 🟠 Select Feed Program
    @IBAction func didselectonDonebutton(_ sender: AnyObject) {
        let farms = CoreDataHandler().fetchNecropsystep1neccIdFeedProgram(postingId as NSNumber)
        if farms.count > 0 {
            let str : String
            if lngId == 5 {
                str =  "la (s) granja (s) no están conectadas. Navegue al programa de alimentación y conecte las granjas con el programa de alimentación."
            }
            else if lngId == 3{
                str =  "Ferme(s) non connectées. Aller dans Programme Alimentaire et connecter la ferme à un Programme Alimentaire."
            }
            else{
                str =  "farm(s) are not connected. Please navigate to Feed Program and connect the farms with the Feed Program."
            }
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("\(farms.count) \(str)", comment: ""))
            return
        }
        UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
        UserDefaults.standard.synchronize()
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DashView_Controller") as? DashViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
    // MARK: 🟠 Necropsy BAck Button
    fileprivate func createStr(_ farms: NSArray) {
        let str : String
        if lngId == 5 {
            str =  "la (s) granja (s) no están conectadas. Navegue al programa de alimentación y conecte las granjas con el programa de alimentación."
        }
        else if lngId == 3 {
            str = "Ferme(s) non connectées. Aller dans Programme Alimentaire et connecter la ferme à un Programme Alimentaire."
        } else {
            str =  "farm(s) are not connected. Please navigate to Feed Program and connect the farms with the Feed Program."
        }
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("\(farms.count) \(str)", comment: ""))
    }
    
    fileprivate func handleValue(_ value: NSArray) {
        if value.count > 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please enter feed program.", comment: ""))
        }
    }
    
    fileprivate func handleLblVetAndShowPopup() {
        let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: NSLocalizedString("Data will not be saved until you enter feed program. Click Yes to complete the session.", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertAction.Style.cancel)
        let okAction = UIAlertAction(title: NSLocalizedString(Constants.noStr, comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
            return
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bckButtonNec(_ sender: AnyObject) {
        let isPostingId = UserDefaults.standard.bool(forKey: "ispostingIdIncrease")
        feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        if feedProgramArray.count == 0 {
            
            if lblVeteration.text != "" {
                handleLblVetAndShowPopup()
            } else {
                
                if (lblCustmer.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblComplex.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblVeteration.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") || birdSize.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblDate.text == NSLocalizedString(emptyDateLabel, comment: "") ) || isPostingId == false{
                    
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
        }
        let farms = CoreDataHandler().fetchNecropsystep1neccIdFeedProgram(postingId as NSNumber)
        if farms.count > 0 {
            if feedProgramArray.count == 0 && isPostingId == false {
                self.navigationController?.popViewController(animated: true)
                return
            } else {
                if feedProgramArray.count == 0 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    createStr(farms)
                    return
                }
            }
        }
        
        if (lblCustmer.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblComplex.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblVeteration.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") || birdSize.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblDate.text == NSLocalizedString(emptyDateLabel, comment: "") ) || isPostingId == false{
            
            self.navigationController?.popViewController(animated: true)
        } else {
            let value  = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
            handleValue(value)
        }
    }
    
    // MARK: 🟠  Get All Session's in an Array
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    // MARK: 🟠 - 🔴  Sync Button Action
    @IBAction func synvBtnAction(_ sender: AnyObject) {
        
        feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        if feedProgramArray.count>0{
            
            let farms = CoreDataHandler().fetchNecropsystep1neccIdFeedProgram(postingId as NSNumber)
            if farms.count > 0 {
                self.showExitAlertWith(msg: "Please connect \(farms.count) farm(s) with feed program. Do you want not do it now?", tag: 2)
                return
            }
            
            if self.allSessionArr().count > 0
            {
                if ConnectionManager.shared.hasConnectivity() {
                    Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
                    self.callSyncApi()
                }
                else
                {
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineMsg, comment: ""))
                }
            }
            else{
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
            }
        }
        
        else{
            if self.allSessionArr().count == 0
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
            }
            else{
                self.showExitAlertWith(msg: "Feed program not added in the session. Do you want to add now? If you click No, session data will not be saved", tag: 1)
            }
        }
    }
    
    // MARK: 🟠 - Exit Popup Load
    func showExitAlertWith(msg: String,tag: Int) {
        exitPopUP = popUP.loadFromNibNamed("popUP") as! popUP
        exitPopUP.lblFedPrgram.text = msg
        exitPopUP.tag = tag
        exitPopUP.lblFedPrgram.textAlignment = .center
        exitPopUP.delegatenEW = self
        exitPopUP.center = self.view.center
        self.view.addSubview(exitPopUP)
        
    }
    
    func noPopUpPosting() {
        if exitPopUP.tag == 40{
            appDelegateObj.testFuntion()
        }
        else if exitPopUP.tag == 50{
            appDelegateObj.testFuntion()
        }
        else{
            if UserDefaults.standard.bool(forKey: "Unlinked") == true{
                feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
                if feedProgramArray.count == 0 {
                    CoreDataHandler().updatePostingSessionOndashBoard(self.postingId as NSNumber, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
                    CoreDataHandler().deletefieldVACDataWithPostingId(self.postingId as NSNumber)
                    CoreDataHandler().deleteDataWithPostingIdHatchery(self.postingId as NSNumber)
                }
            }
            else{
                CoreDataHandler().deleteDataWithPostingId(self.postingId as NSNumber)
                CoreDataHandler().deletefieldVACDataWithPostingId(self.postingId as NSNumber)
                CoreDataHandler().deleteDataWithPostingIdHatchery(self.postingId as NSNumber)
            }
        }
        
        for dashboard in (self.navigationController?.viewControllers)! {
            if dashboard.isKind(of: DashViewController.self){
                self.navigationController?.popToViewController(dashboard, animated: true)
            }
        }
    }
    
    func YesPopUpPosting() {
        appDelegateObj.testFuntion()
    }
    // MARK: 🟠  Alert Message to add Feed Program
    func showAlert(){
        let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: NSLocalizedString("Data will not be saved until you enter feed program. Click Yes to complete the session.", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertAction.Style.cancel)
        let okAction = UIAlertAction(title: NSLocalizedString(Constants.noStr, comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            CoreDataHandler().deleteDataWithPostingId(self.postingId as NSNumber)
            CoreDataHandler().deletefieldVACDataWithPostingId(self.postingId as NSNumber)
            CoreDataHandler().deleteDataWithPostingIdHatchery(self.postingId as NSNumber)
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DashView_Controller") as? DashViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: 🟠  Data Sync API for Feed Program
    func callSyncApi()
    {
        objApiSync.feedprogram()
    }
    
    // MARK: Custome PopUp
    func clickHelpPopUp() {
        
        buttonbg1.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonbg1.addTarget(self, action: #selector(PostingViewController.buttonPressed11), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg1)
        
        customPopView1 = UserListView.loadFromNibNamed("UserListView") as! UserListView
        customPopView1.logoutDelegate = self
        customPopView1.layer.cornerRadius = 8
        customPopView1.layer.borderWidth = 3
        customPopView1.layer.borderColor =  UIColor.clear.cgColor
        self.buttonbg1 .addSubview(customPopView1)
        customPopView1.showView(self.view, frame1: CGRect(x: self.view.frame.size.width - 200, y: 60, width: 150, height: 60))
    }
    // MARK: 🟠 Remove Custome PopUp
    @objc func buttonPressed11() {
        customPopView1.removeView(view)
        buttonbg1.removeFromSuperview()
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
    // MARK: 🟠  ************** Delegate Method Of DropDown ***************************
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        lblCustmer.text = contents
        
    }
    
    // MARK: 🟠   ******************** TableView Delegate and dataSource Method **************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == autoSerchTable {
            return autocompleteUrls.count
        }
        else{
            switch btnTag {
            case 0:
                return custmerArray.count
            case 1:
                return SalesRepArr.count
            case 2:
                return sessionTypeArr.count
            case 3:
                return complexArr.count
            case 4:
                return CocoiiProgramArr.count
            case 5:
                if butttnTag == 0 {
                    return metricArray.count
                }
                else{
                    return birdArray.count
                }
            case 6:
                return breedArray.count
            case 7:
                return femaleArr.count
            case 8:
                return VetrationArr.count
            case 9:
                return feedProgramArray.count
            case 10:
                return machineArray.count
            case 11:
                return ProductionTypeArr.count
                
            default:
                return 0
            }
        }
    }
    
    fileprivate func setBirdSizeOrMatricSize(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        if butttnTag == 0 {
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if let value = metricArray[indexPath.row].birdSize{
                cell.textLabel!.text = value
            }
        }
        else{
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if let value = birdArray[indexPath.row].birdSize{
                cell.textLabel!.text = value
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoSerchTable {
            let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
            return cell
        }
        else{
            let cell = UITableViewCell ()
            
            if btnTag == 0 {
                let customer : Custmer = custmerArray.object(at: indexPath.row) as! Custmer
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = customer.custName
            }
            else if btnTag == 1 {
                let salesRep : Salesrep = SalesRepArr.object(at: indexPath.row) as! Salesrep
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = salesRep.salesRepName
            }
            else if btnTag == 2 {
                let sessionArr : Sessiontype = sessionTypeArr.object(at: indexPath.row) as! Sessiontype
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = sessionArr.sesionType
                sessionTypeIdDb = sessionArr.sesionId ?? 0
            }
            else if btnTag == 3 {
                let cocoii : ComplexPosting = complexArr.object(at: indexPath.row) as! ComplexPosting
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = cocoii.complexName
            }
            else if btnTag == 4{
                let cocoii : CocciProgramPosting = CocoiiProgramArr.object(at: indexPath.row) as! CocciProgramPosting
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = cocoii.cocciProgramName
            }
            else if btnTag == 5 {
                setBirdSizeOrMatricSize(cell, indexPath)
            }
            else if btnTag == 6 {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = breedArray[indexPath.row].breedName
            }
            else if btnTag == 7{
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = femaleArr[indexPath.row].breedName
            }
            else if btnTag == 8{
                let vet : Veteration = VetrationArr.object(at: indexPath.row) as! Veteration
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = vet.vtName
            }
            else if btnTag == 9{
                let vet : FeedProgram = feedProgramArray.object(at: indexPath.row) as! FeedProgram
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = vet.feddProgramNam
            }
            else if btnTag == 11{
                let prod = ProductionTypeArr.object(at: indexPath.row) as! ProductionType
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = prod.productionName
            }
            else{
                let dadat = machineArray.object(at: indexPath.row) as! PostingSession
                let cell =   UITableViewCell()
                let label = UILabel(frame: CGRect(x: 20, y: 10, width: 200, height: 21))
                label.text = dadat.sessiondate
                label.textColor = UIColor.black
                cell.addSubview(label)
                
                let label1 = UILabel(frame: CGRect(x: 480, y: 10, width: 200, height: 21))
                label1.text = dadat.complexName
                label1.textColor = UIColor.black
                cell.addSubview(label1)
                return cell
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == autoSerchTable {
            debugPrint("auto search not populated.")
            return
        }
        
        switch btnTag {
        case 0:
            handleCustomerSelection(indexPath)
            
        case 1:
            handleSalesRepSelection(indexPath)
            
        case 2:
            handleSessionTypeSelection(indexPath)
            
        case 3:
            handleComplexSelection(indexPath)
            
        case 4:
            handleCocciProgramSelection(indexPath)
            
        case 5:
            handleBirdSizeSelection(indexPath)
            
        case 6:
            handleMaleBreedSelection(indexPath)
            
        case 7:
            handleFemaleBreedSelection(indexPath)
            
        case 8:
            handleVeterinarianSelection(indexPath)
            
        case 9:
            handleFeedProgramSelection(indexPath)
            
        case 11:
            handleProductionTypeSelection(indexPath)
            
        default:
            populateFieldsFromSession(indexPath)
        }
        
        buttonPressed1()
    }
    
    private func handleCustomerSelection(_ indexPath: IndexPath) {
        guard let customer = custmerArray[indexPath.row] as? Custmer else { return }
        lblCustmer.text = customer.custName
        UserDefaults.standard.set(customer.custName, forKey: "custmer")
        custmetIdDb = customer.custId!
        UserDefaults.standard.set(customer.custId!, forKey: "SelectedCustmer")
        UserDefaults.standard.synchronize()
        
        complexArr = CoreDataHandler().fetchCompexTypePrdicate(customer.custId!)
        isClickOnAnyField = true
    }

    private func handleSalesRepSelection(_ indexPath: IndexPath) {
        guard let salesRep = SalesRepArr[indexPath.row] as? Salesrep else { return }
        lblSelesRep.text = salesRep.salesRepName
        salesRepIdDb = salesRep.salesReptId!
        isClickOnAnyField = true
    }
    
    private func handleBirdSizeSelection(_ indexPath: IndexPath) {
        if butttnTag == 0 {
            let obj = metricArray[indexPath.row]
            birdSize.text = obj.birdSize
            birdSizeIdDb = obj.birdSizeId!
        } else {
            let obj = birdArray[indexPath.row]
            birdSize.text = obj.birdSize
            birdSizeIdDb = obj.birdSizeId!
        }
        indexOfSelectedPerson = indexPath.row
        isClickOnAnyField = true
    }

    private func handleSessionTypeSelection(_ indexPath: IndexPath) {
        guard let session = sessionTypeArr[indexPath.row] as? Sessiontype else { return }
        lblSessionType.text = session.sesionType
        sessionTypeIdDb = session.sesionId!
        isClickOnAnyField = true
    }
    private func handleComplexSelection(_ indexPath: IndexPath) {
        guard let complex = complexArr[indexPath.row] as? ComplexPosting else { return }
        lblComplex.text = complex.complexName
        
        if checkComplexNameandDate(strdate, complexName: complex.complexName ?? "") {
            let alert = UIAlertController(
                title: NSLocalizedString(Constants.alertStr, comment: ""),
                message: NSLocalizedString(sameDateComplexValidationMsg, comment: ""),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
                self.lblComplex.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
                self.lblVeteration.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
            })
            present(alert, animated: true)
        } else {
            UserDefaults.standard.set(complex.complexName, forKey: "complex")
            complexIdDb = complex.complexId!
            UserDefaults.standard.set(complexIdDb, forKey: "UnlinkComplex")
            UserDefaults.standard.set(custmetIdDb, forKey: "unCustId")
            UserDefaults.standard.synchronize()
            
            let fetchId: NSNumber = UserDefaults.standard.bool(forKey: "Unlinked") ? unComplexId as NSNumber : complex.complexId!
            VetrationArr = CoreDataHandler().fetchVetDataPrdicate(fetchId)
            isClickOnAnyField = true
        }
    }
    private func handleCocciProgramSelection(_ indexPath: IndexPath) {
        guard let cocci = CocoiiProgramArr[indexPath.row] as? CocciProgramPosting else { return }
        lblCocieeProgram.text = cocci.cocciProgramName
        cocciProgramIdDb = cocci.cocciProgramId!
        isClickOnAnyField = true
    }
    private func handleMaleBreedSelection(_ indexPath: IndexPath) {
        let breed = breedArray[indexPath.row]
        maleLabel.text = breed.breedName
        breedIdDb = breed.breedId!
        isClickOnAnyField = true
    }
    private func handleFemaleBreedSelection(_ indexPath: IndexPath) {
        let breed = femaleArr[indexPath.row]
        femaleLabel.text = breed.breedName
        breedIdDb = breed.breedId!
        isClickOnAnyField = true
    }
    private func handleVeterinarianSelection(_ indexPath: IndexPath) {
        guard let vet = VetrationArr[indexPath.row] as? Veteration else { return }
        lblVeteration.text = vet.vtName
        veterinartionIdDb = vet.vetarId!
        isClickOnAnyField = true
        btnVetration.layer.borderColor = UIColor.black.cgColor
    }
    private func handleFeedProgramSelection(_ indexPath: IndexPath) {
        guard let feed = feedProgramArray[indexPath.row] as? FeedProgram else { return }
        feedProgramLbl.text = feed.feddProgramNam
        
        let isUnlinked = UserDefaults.standard.bool(forKey: "Unlinked")
        UserDefaults.standard.set(isUnlinked, forKey: "isUpadteFeedFromUnlinked")
        UserDefaults.standard.synchronize()
        
        if let feedId = feed.feedId as? Int,
           let vc = storyboard?.instantiateViewController(withIdentifier: "feed") as? FeedProgramViewController {
            vc.navigatePostingsession = "PostingFeedProgram"
            vc.feedPostingId = feedId
            navigationController?.pushViewController(vc, animated: false)
        }

        
    }
    private func handleProductionTypeSelection(_ indexPath: IndexPath) {
        guard let type = ProductionTypeArr[indexPath.row] as? ProductionType else { return }
        productionTypeLbl.text = type.productionName
        productionNameStr = type.productionName ?? ""
        productionIdDb = type.productionId!
        isClickOnAnyField = true
        productionTypeBtn.layer.borderColor = UIColor.black.cgColor
    }
    private func populateFieldsFromSession(_ indexPath: IndexPath) {
        guard let psData = machineArray[indexPath.row] as? PostingSession else { return }
        
        lblVeteration.text = psData.vetanatrionName
        CustRepTextField.text = psData.customerRepName
        lblSelesRep.text = psData.salesRepName
        maleLabel.text = psData.mail
        femaleLabel.text = psData.female
        lblSessionType.text = psData.sessionTypeName
        lblCocieeProgram.text = psData.cociiProgramName
        notesTextView.text = psData.notes
        birdSize.text = psData.birdSize
        
        cusmerRepIdDb = 1
        birdSizeIdDb = psData.birdSizeId!
        breedIdDb = psData.birdBreedId!
        salesRepIdDb = psData.salesRepId!
        sessionTypeIdDb = psData.sessionTypeId!
        veterinartionIdDb = psData.veterinarianId!
        cocciProgramIdDb = psData.cocciProgramId!
        productionIdDb = psData.productionTypeId!
    }

    
    
    // MARK: 🟠   ******************** Textfield Delegates Method **************************************
    func textFieldDidEndEditing(_ textField: UITextField) {
        

            isClickOnAnyField = true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == notesTextView ) {
            appDelegateObj.testFuntion()
        } else {
            CustRepTextField.returnKeyType = UIReturnKeyType.done
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if textField.tag == 101 {
            let ACCEPTED_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
            let set = CharacterSet(charactersIn: ACCEPTED_CHARACTERS)
            let inverted = set.inverted
            let filtered = string.components(separatedBy: inverted).joined(separator: "")
            let maxLength = 50
            let currentString: NSString = CustRepTextField.text as? NSString ?? ""
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if (textField.tag == 101 && CoreDataHandler().fectCustomerRepWithCustomername(1).count > 0){
                let bPredicate: NSPredicate = NSPredicate(format: "customername contains[cd] %@", newString)
                fetchcustRep = CoreDataHandler().fectCustomerRepWithCustomername( 1).filtered(using: bPredicate) as NSArray
                autocompleteUrls = fetchcustRep.mutableCopy() as! NSMutableArray
                autoSerchTable.frame = CGRect(x: 240, y: 145, width: 265, height: 80)
                buttonDroper.alpha = 1
                autoSerchTable.alpha = 1
                
                if autocompleteUrls.count == 0 {
                    buttonDroper.alpha = 0
                    autoSerchTable.alpha = 0
                }
            }
            
            return newString.length <= maxLength && filtered == string
            
        }else {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if (textField.tag == 101 && CoreDataHandler().fectCustomerRepWithCustomername(1).count > 0){
                let bPredicate: NSPredicate = NSPredicate(format: "customername contains[cd] %@", newString)
                fetchcustRep = CoreDataHandler().fectCustomerRepWithCustomername( 1).filtered(using: bPredicate) as NSArray
                autocompleteUrls = fetchcustRep.mutableCopy() as! NSMutableArray
                autoSerchTable.frame = CGRect(x: 240, y: 145, width: 265, height: 80)
                buttonDroper.alpha = 1
                autoSerchTable.alpha = 1
                
                if autocompleteUrls.count == 0 {
                    buttonDroper.alpha = 0
                    autoSerchTable.alpha = 0
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        buttonDroper.alpha = 0
        autoSerchTable.alpha = 0
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    // MARK: 🟠   ******************** Textview Delegates Method **************************************
    func textViewShouldBeginEditing(_ _textView: UITextView) -> Bool
    {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView == notesTextView ) {
            isClickOnAnyField = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == notesTextView ) {
            let ACCEPTED_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:;,/-_!@#$%*()-_=+[]\'<>.?/\\~`€£"
            let set = CharacterSet(charactersIn: ACCEPTED_CHARACTERS)
            let inverted = set.inverted
            let filtered = text.components(separatedBy: inverted).joined(separator: "")
            return filtered == text
        }
        return true
    }
    
    // MARK: 🟠  ******************************* Delegate SyNC Api *************************************************************
    func failWithError(statusCode:Int)
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            if lngId == 1{
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
            }
            else if lngId == 3{
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
        }
    }
    func failWithErrorInternal()
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection. Please try again!", comment: ""))
    }
    func didFinishApi()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    func failWithInternetConnection()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineMsg, comment: ""))
    }
    func printSyncLblCount()
    {
        syncNotiCountLbl.text = String(self.allSessionArr().count)
    }
}
