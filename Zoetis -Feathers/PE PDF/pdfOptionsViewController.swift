//
//  pdfOptionsViewController.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 14/05/24.
//

import UIKit
import SwiftyJSON
class pdfOptionsViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Decleared Variables.
    @IBOutlet weak var pdfTableView: UITableView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var cancleBtn: UIButton!
    
    @IBOutlet weak var backgroundHeigthConstarint: NSLayoutConstraint!
    var fileNamesArray = NSArray()
    var fileIDArray = NSArray()
    var fileExtensionArray = NSArray()
    var fileDetailArray = NSArray()
    var docxFileArray = NSArray()
    // MARK: - View Life cycle
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = .clear
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        fileDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "BlankAssessmentFiles")
        backgroundHeigthConstarint.constant = CGFloat(80 + 75*fileDetailArray.count)
        
        
        if fileDetailArray.count == 0 {
            getBlankAssessmentFiles()
        }else{
            fileNamesArray = fileDetailArray.value(forKey: "fileName") as? NSArray ?? NSArray()
            fileIDArray = fileDetailArray.value(forKey: "fileId") as? NSArray ?? NSArray()
            fileExtensionArray = fileDetailArray.value(forKey: "fileExtension") as? NSArray ?? NSArray()
            docxFileArray = fileDetailArray.value(forKey: "docxFile") as? NSArray ?? NSArray()
        }
        
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.layer.cornerRadius = 20
        self.backgroundView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        self.backgroundView.layer.masksToBounds = true
        self.backgroundView.layer.borderWidth = 2.0
        self.registerTblVwCells()
        self.hideCoreDataStore()
        
    }
    
    // MARK: - Get Blank Assessment Files
    private func getBlankAssessmentFiles(){
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
            
            let jsonDict = ["ReportType" : "1"]
            
            if let theJSONData = try? JSONSerialization.data( withJSONObject: jsonDict, options: .prettyPrinted),
               let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                debugPrint("SNA Json = \n\(theJSONText)")
            }
            
            ZoetisWebServices.shared.getBlankAssessmentFiles(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let self = self, error == nil else { return }
                self.handleBlankAssessmentResponse(json)
            })
            
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to download PDF.", comment: ""))
        }
        
    }
    
    private func handleBlankAssessmentResponse(_ json: JSON) {
        
        self.deleteAllData("BlankAssessmentFiles")
      
        
        fileDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "BlankAssessmentFiles")
        fileNamesArray = fileDetailArray.value(forKey: "fileName") as? NSArray ?? NSArray()
        fileIDArray = fileDetailArray.value(forKey: "fileId") as? NSArray ?? NSArray()
        fileExtensionArray = fileDetailArray.value(forKey: "fileExtension") as? NSArray ?? NSArray()
        docxFileArray = fileDetailArray.value(forKey: "docxFile") as? NSArray ?? NSArray()
        self.registerTblVwCells()
    }
    // MARK: - Update User Interface
    func registerTblVwCells(){
        pdfTableView.delegate = self
        pdfTableView.dataSource = self
        
        let nib = UINib(nibName: "pdfCell", bundle: nil)
        self.pdfTableView.register(nib, forCellReuseIdentifier:  pdfCell.identifier)
        self.pdfTableView.reloadData()
        
    }
    // MARK: - Cancel Button Action
    @IBAction func cancleBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileExtensionArray.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: pdfCell.identifier) as? pdfCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.pdfFileBtn.tag = indexPath.row
        cell.docxFileBtn.tag = indexPath.row
        cell.pdfFileBtn.addTarget(self, action: #selector(loadPDFile(sender:)), for: .touchUpInside)
        cell.docxFileBtn.addTarget(self, action: #selector(loadDocxFile(sender:)), for: .touchUpInside)
        cell.fileName.text = fileNamesArray[indexPath.row] as? String
        return cell
    }
    // MARK: - Download PDF Blank Assessment File into the Device
    @objc func loadPDFile(sender: UIButton)
    {
        UserDefaults.standard.set(true, forKey: "download")
        self.showGlobalProgressHUDWithTitle(self.view, title: "Downloading...")
        let indexpath = NSIndexPath(row:sender.tag, section: 0)
        let fileName = fileExtensionArray[indexpath.row] as? String
        self.getDownloadBlankFile(fileName: "\(fileName ?? "")")
    }
    // MARK: - Download Doc. Blank Assessment File into the Device
    @objc func loadDocxFile(sender: UIButton)
    {
        UserDefaults.standard.set(true, forKey: "download")
        self.showGlobalProgressHUDWithTitle(self.view, title: "Downloading...")
        let indexpath = NSIndexPath(row:sender.tag, section: 0)
        let fileName = docxFileArray[indexpath.row] as? String
        self.getDownloadBlankFile(fileName: "\(fileName ?? "")")
    }
    // MARK: - get Blank Assessment File from server
    private func getDownloadBlankFile(fileName:String){
        
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
            
            UserContext.sharedInstance.userDetailsObj?.userId ?? ""
            let jsonDict = ["ReportType" : "1"]
            
            if let theJSONData = try? JSONSerialization.data( withJSONObject: jsonDict, options: .prettyPrinted),
               let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                debugPrint("SNA Json = \n\(theJSONText)")
            }
            
            ZoetisWebServices.shared.getDownloadBlankFile(controller: self, parameters: [:], fileName: fileName,  completion: { [weak self] (json, error) in
                guard let self = self, error == nil else { return }
                let urlData = json["Data"].string
                self.saveBase64StringToPDF(urlData ?? "", orderId: "12", nameOfFile: fileName)
            })
            
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to download file.", comment: ""))
        }
        
    }
    // MARK: - Save Blank Assessment File to PDF format
    func saveBase64StringToPDF(_ base64String: String, orderId: String , nameOfFile: String) {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Download", isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: documentsURL.path)
        {
            do {
                try FileManager.default.createDirectory(atPath: documentsURL.path, withIntermediateDirectories: true, attributes: nil)
                debugPrint("created user directory")
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
        }
        
        documentsURL.appendPathComponent("\(nameOfFile)")
        let convertedData = Data(base64Encoded: base64String)
        do {
            try convertedData!.write(to: documentsURL)
            self.dismissGlobalHUD(self.view ?? UIView())
            let errorMSg = "The file has been saved under the iPad Files option ( Path - On My Ipad option -> PoultryView 360 Folder -> Download )"
            let alertController = UIAlertController(title: "Download Completed", message: errorMSg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            let cancelAction = UIAlertAction(title: "Preview", style: UIAlertAction.Style.default) {
                _ in
                
                //  self.dismiss(animated: false, completion: nil)
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "peWebViewController") as! peWebViewController
                // vc.pdfURL = pdfUrl
                vc.modalPresentationStyle = .overFullScreen
                vc.base64Data = base64String
                vc.showShareAndDownload = false
                
                self.present(vc, animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            
            
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Download Completed", comment: ""), messageStr: NSLocalizedString(" ", comment: ""))
            
        } catch {
            debugPrint("Error saving PDF: \(error.localizedDescription)")
            
        }
    }
    // MARK: - Hide Default Core Data files from the App folder
    func hideCoreDataStore() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var storeURL = documentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
            var storeURL1 = documentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite-wal")
            var storeURL2 = documentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite-shm")
            do {
                var resourceValues = URLResourceValues()
                resourceValues.isHidden = true
                try storeURL.setResourceValues(resourceValues)
                try storeURL1.setResourceValues(resourceValues)
                try storeURL2.setResourceValues(resourceValues)
            } catch {
                debugPrint("Error hiding Core Data store: \(error.localizedDescription)")
            }
        }
    }
    
}



