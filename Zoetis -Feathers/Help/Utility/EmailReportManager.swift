//
//  Untitled.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 5/12/25.
//

import Foundation
import CoreData
import MessageUI
import UIKit
import UniformTypeIdentifiers

class EmailReportManager: NSObject, MFMailComposeViewControllerDelegate {
    
    static let shared = EmailReportManager()
    private override init() {}
    
    func sendEmailReport(dataToAttach:Data,from presenter: UIViewController, assessmentId:String?,date:String?, isPE:Bool) -> (Bool,URL?)? {
        
        let timestampInSeconds = Date().timeIntervalSince1970
        let fileURL = saveJSONToTextFile(data: dataToAttach)
        var assessmentIdStr = ""
        if let assId = assessmentId {
            assessmentIdStr = "AssessmentId: \(assId)"
            if !isPE {
                assessmentIdStr = "SyncId: \(assId)"
            }
        }
        var assDateStr = ""
        if let assDate = date {
            assDateStr = "AssessmentDate: \(assDate)"
        }
        let bodyData = "UserName: \(UserModel.shared.username ?? "") \n" + assessmentIdStr + "\n" + assDateStr
        let fileName = "AssessmentLog_\(UserModel.shared.username ?? UserModel.shared.email ?? "")_\(Int(timestampInSeconds)).txt"
        if let fileURL1 = fileURL, MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setToRecipients(["Pv360user@gmail.com"])
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Logs Report")
            mailComposer.setMessageBody("Please find the attached logs file.\n\n \(bodyData)", isHTML: false)
            if let fileData = try? Data(contentsOf: fileURL!) {
                mailComposer.addAttachmentData(fileData, mimeType: "text/plain", fileName: fileName)
            }
            
            DispatchQueue.main.async {
                presenter.present(mailComposer, animated: true)
            }
            
            return (true, fileURL1)
        } else {
            if let filePath = fileURL {
                exportTextFileToFilesApp(from: presenter, fileName: fileName, tempURL: filePath)
            }
            return (false,fileURL)
        }
    }
    
    private func saveJSONToTextFile(data: Data) -> URL? {
        let timestampInSeconds = Date().timeIntervalSince1970
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("AssessmentLog_\(UserModel.shared.username ?? UserModel.shared.email ?? "")_\(Int(timestampInSeconds)).txt")
        print(fileURL)
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Write error: \(error)")
            return nil
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        if let err = error {
            print(err)
        }
		
		switch result {
			case .sent:
				controller.dismiss(animated: true) {
					if let topvc = UIApplication.getTopMostViewController() {
						Helper.showAlertMessage(topvc, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("Logs sent successfully.", comment: ""))
					}
				}
			case .failed:
				if let err = error {
					print(err)
				}
				if let topvc = UIApplication.getTopMostViewController() {
					Helper.showAlertMessage(topvc, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("Email sending filed, Please try again.\n \(error?.localizedDescription ?? "")", comment: ""))
				}
			default:
				break
		}
    }
    
    func exportTextFileToFilesApp(from viewController: UIViewController, fileName: String, tempURL: URL) {
        let documentPicker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            // Preferred method on iOS 14+
            documentPicker = UIDocumentPickerViewController(forExporting: [tempURL])
            documentPicker.shouldShowFileExtensions = true
        } else {
            // Fallback for iOS 11–13
            documentPicker = UIDocumentPickerViewController(url: tempURL, in: .exportToService)
        }
        
        viewController.present(documentPicker, animated: true)
    }
}
