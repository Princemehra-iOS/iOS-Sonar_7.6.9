//  AppDelegate.swift
//  Zoetis -Feathers
//  Created by "" on 11/08/16.
//  Copyright © 2016 "". All rights reserved.
//  com.a1distribute.hms

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Reachability
import UserNotifications
import FirebaseMessaging
import Firebase
import Messages
import iOS_Slide_Menu
import Gigya
import GigyaTfa
import GigyaAuth
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    var newColor = Int()
    var strImpFedd = String()
    var metricOrImperialClick = String()
    var isDoneClick: Bool = false
    var isFeedProgramClick: Bool = false
    var window: UIWindow?
    var globalDataArr = NSMutableArray()
    var sendFeedVariable = String()
    var globalDataArrTurkey = NSMutableArray()
    var surveySelected :String  = ""
    let gcmMessageIDKey = "gcm.message_id"
    var selectedCompany : String = " "

    let gigyaApiKeyStageDev = "4_KkOJPb7zC89ubdZyo8pEWg"
    let gigyaApiKeyProd = "4_5r3cxoPXLplYq5ZOvn3fAg"
    let gigyaApiDomain = "us1.gigya.com"
    let gigyaCname = "eiamus.zoetisus.com"
    let timeStamp = "timeStamp = %@"
    let timeStamp2 = "timeStamp == %@"
    let nameJames = "James Barker"
    let mmddyyStr = "MMM d, yyyy"
    let loadingStr = "Loading..."
    let MMddyyyStr = "MM/dd/yyyy"
//    let ddMMyyyStr = Constants.ddMMyyyStr
    let dataSyncInProgressStr = Constants.dataSyncInProgress
    let date2020_05_23 = "2020-05-23T06:36:50.915Z"
    let asiaTehran = "Asia/Tehran"
    let noDataFoundStr = "No Data Found"
    let invalidDateStr = "Invalid date format"
    let dataSynedSuccess = "Data synced successfully."
    let selectStr = "- Select -"
    var hideHudTimer: Timer?
    
    func initiateLeftPenal() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let containerViewController = ContainerViewController()
        window!.rootViewController = containerViewController       
        
    }
    
    func showAlert(_ msg:String) {
        guard let topController = UIApplication.shared.topViewController else {
            return
        }
        DispatchQueue.main.async {
            Helper.showAlertMessage(topController, titleStr: Constants.alertStr, messageStr: msg)
        }
    }
    
    func generateSeveyNumber() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyy"
        let dateStr = formatter.string(from: date)
        var createServeyNo = "S"+dateStr
        return createServeyNo
    }
    
    func checkIfAnyNetworkRequestIsRunning(completion: @escaping (Bool) -> Void) {
        URLSession.shared.getAllTasks { tasks in
            let isRunning = tasks.contains { $0.state == .running }
            completion(isRunning)
        }
    }
    
    func testFuntion() {
        print("Test")
    }
    
    /*************************************/
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        Messaging.messaging().delegate = self
        //Messaging.messaging().isDirectChannelEstablished = true
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "HasLaunchedOnce") != nil && (userDefaults.value(forKey: "HasLaunchedOnce") as? Bool)!{ // App already launched
        } else {
            UserDefaults.standard.set(false, forKey: "PENewUserLoginFlag")
        }
        
        UserDefaults.standard.set(false, forKey: "hasLoggedIn")
        //        initiateLeftPenal()
        UserDefaults.standard.set(false, forKey: "login")
        
        UserDefaults.standard.set(false, forKey: "hasAppMovedToBackground")
        UserDefaults.standard.set(false, forKey: "hasPEDataLoaded")
        UserDefaults.standard.set(false, forKey: "hasPELoadedPrevData")
        
        UserDefaults.standard.set(false, forKey: "hasVaccinationDataLoaded")
        Localizer.DoTheMagic()
        
        application.isStatusBarHidden = true
        metricOrImperialClick = "Imperial"
        
        let isFeed = UserDefaults.standard.integer(forKey: "isFeed")
        if isFeed != 1 {
            let feedId = UserDefaults.standard.integer(forKey: "feedId")
            if feedId < 0 {
                UserDefaults.standard.set(-1, forKey: "feedId")
            }
        }
        
        if userDefaults.object(forKey: "ApplicationIdentifier") == nil {
            let uuID = Foundation.UUID().uuidString
            userDefaults.set(uuID, forKey: "ApplicationIdentifier")
            userDefaults.synchronize()
        }
        
        
        notificationSetup(application)
        updateFirestorePushTokenIfNeeded()
        
        
        UserDefaults.standard.set(true, forKey: "promt")
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        let val = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0) as NSArray
        for i in 0..<val.count {
            let posting: PostingSession = val.object(at: i) as! PostingSession
            let pidSession = posting.postingId
            let feedProgram =  CoreDataHandler().FetchFeedProgram(pidSession!)
            if feedProgram.count == 0 {
                CoreDataHandler().deleteDataWithPostingId(pidSession!)
                CoreDataHandler().deletefieldVACDataWithPostingId(pidSession!)
                CoreDataHandler().deleteDataWithPostingIdHatchery(pidSession!)
            }
        }
        
        manageCoredataTurkey()
        UserDefaults.standard.set(true, forKey: "isFreshLaunched")
        IQKeyboardManager.shared.enable = true
        
        initiateGigya()
        
        
        return true
    }
    
    func startHideHudTimer() {
//        hideHudTimer?.invalidate()
//        hideHudTimer = nil
//        hideHudTimer = Timer.scheduledTimer(withTimeInterval: 80.0, repeats: true) { timer in
//            self.checkIfAnyNetworkRequestIsRunning { isRunning in
//                if !isRunning {
//                    print("HUD hidden")
//                 //   self.hideAllHUDs()
//                }
//            }
//        }
    }
    
    func hideAllHUDs() {
        DispatchQueue.main.async {
            if let topVC = UIApplication.getTopMostViewController(), topVC is ContainerViewController {
                if let subViews = (topVC.children[0] as! UINavigationController).topViewController?.view.subviews {
                    for view in subViews {
                        if view is MBProgressHUD {
                            view.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        checkIfLoginExpired()
    }
    
    private func checkIfLoginExpired() {
        guard let loginDate = UserDefaults.standard.object(forKey: "LoginDate") as? Date else {
            return
        }

        let expirationInterval: TimeInterval = 15 * 24 * 60 * 60 // 15 days in seconds
        if Date().timeIntervalSince(loginDate) > expirationInterval {
           // logoutUser()
            
            self.showAlert("Please sync your assessment data to the web.Your session is about to end.")
        }
    }
    
    private func logoutUser() {
        // Clear user session data
        UserDefaults.standard.removeObject(forKey: "loginTimestamp")
        // ... remove auth tokens, user data, etc.

        // Redirect to login screen
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
    }
    
    fileprivate func manageCoredataTurkey() {
        let val1 = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0) as NSArray
        for i in 0..<val1.count {
            let posting: PostingSessionTurkey = val1.object(at: i) as! PostingSessionTurkey
            let pidSession = posting.postingId
            let feedProgram =  CoreDataHandlerTurkey().FetchFeedProgramTurkey(pidSession!)
            if feedProgram.count == 0 {
                CoreDataHandlerTurkey().deleteDataWithPostingIdTurkey(pidSession!)
                CoreDataHandlerTurkey().deletefieldVACDataWithPostingIdTurkey(pidSession!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(pidSession!)
            }
        }
    }
    
    fileprivate func notificationSetup(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {status, error in
                    if !status {
                        //self.showAlert("Push notifications not allowed")
                    }
                })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        
        if let token = Messaging.messaging().fcmToken {
            
            let keychainHelper = AccessTokenHelper()
            keychainHelper.saveToKeychain(valued: token, keyed: "Token")
           // UserDefaults.standard.set(token, forKey: "Token")
        }
    }
        
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
//            showAlert("Message ID: \(messageID)")
            print("Message ID: \(messageID)")
        }
        
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken as Data
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let tokenString = tokenParts.joined()
        print(tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //showAlert("Not registered notification: \(error.localizedDescription)")
        print(error.localizedDescription)
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID:\(messageID)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
                
        let keychainHelper = AccessTokenHelper()
        keychainHelper.saveToKeychain(valued: fcmToken ?? "", keyed: "Token")
        let dataDict = ["token": fcmToken]
 
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        Messaging.messaging().subscribe(toTopic: "/topics/nutriewell_live")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("Received data message: \(remoteMessage.description)")
    }
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let val = UserDefaults.standard.integer(forKey: "chick")
        if val  ==  4 {
            if let vC = window?.rootViewController as? DashViewController {
                // Update JSON data
                vC.self.callSyncApi()
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        } else {
            if let vC = window?.rootViewController as? DashViewControllerTurkey {
                // Update JSON data
                vC.self.callSyncApi()
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }
    }
    
    func setUpSlideMenu() {
        let storyBord = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBord.instantiateViewController(withIdentifier: "LeftMenuViewController")
        SlideNavigationController.sharedInstance().leftMenu = vc
        SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.18
        SlideNavigationController.sharedInstance().enableSwipeGesture = true
        SlideNavigationController.sharedInstance().landscapeSlideOffset = (self.window?.frame.width)! - 158
        //SlideNavigationController.sharedInstance().landscapeSlideOffset = 1024-158
        
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(UserDefaults.standard.bool(forKey: "IAMONFEED"))
        print(UserDefaults.standard.integer(forKey: "MYPOSTINGID"))
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        checkForAppUpdate()
    }
    
    func checkForAppUpdate() {
        
         guard let topController = UIApplication.shared.topViewController else {
           //  print("No view controller available to pass to the API")
             return
         }
        Helper.showGlobalProgressHUDWithTitle(topController.view, title: NSLocalizedString("Checking for updates...", comment: ""))
         ZoetisWebServices.shared.getAppVersionCheck(controller: topController, parameters: [:]) { json, error in
             Helper.dismissGlobalHUD(topController.view)
             guard error == nil else {
                 DispatchQueue.main.async {
                     Helper.showAlertMessage(topController, titleStr: Constants.alertStr, messageStr: "API is not working...")
                 }
                 return
             }

             let dict = json[0]
             let result = dict["Result"].boolValue

             let updateMessage = dict["AlertMsg"].stringValue
             if !result {
                 DispatchQueue.main.async {
                     self.promptForUpdate(message: updateMessage)
                 }
             }
         }
     }
    
    private func promptForUpdate(message:String) {
        let alert = UIAlertController(
            title: "An updated version is now available.",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            if let url = URL(string: Constants.appURLink) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "OK, I will do later", style: .cancel, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        UserDefaults.standard.set(true, forKey: "isAppTerminated")
        UserDefaults.standard.set(false, forKey: "isNewPostingId")
        UserDefaults.standard.set(true, forKey: "callWebService")
        UserDefaults.standard.set(false, forKey: "hasPEDataLoaded")
        UserDefaults.standard.set(false, forKey: "hasVaccinationDataLoaded")
        UserDefaults.standard.synchronize()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.app.Zoetis__Feathers" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Zoetis__Feathers", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        let failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSInferMappingModelAutomaticallyOption: true,
                      NSMigratePersistentStoresAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Zoetis__Feathers")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            else {
                // self.hideCoreDataStore()
                let description = NSPersistentStoreDescription()
                description.shouldMigrateStoreAutomatically = true
                description.shouldInferMappingModelAutomatically = true
                container.persistentStoreDescriptions = [description]
                
            }
            
            
        })
        
        return container
        
    }()
    
    func hideCoreDataStore() {
        
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var storeURL = documentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
            
            do {
                // Set the file as hidden
                var resourceValues = URLResourceValues()
                resourceValues.isHidden = true
                try storeURL.setResourceValues(resourceValues)
                
                print("Core Data store hidden successfully at \(storeURL.path)")
            } catch {
                print("Error hiding Core Data store: \(error.localizedDescription)")
            }
        }
    }
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            //showAlert("userNotificationCenter Message ID: \(messageID)")
            print("Message ID: \(messageID)")
        }
        
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            //showAlert("userNotificationCenter Message ID: \(messageID)")
            print("Message ID: \(messageID)")
        }
        completionHandler()
    }
}


extension UIApplication {
    // Helper to get the top-most view controller
    var topViewController: UIViewController? {
        guard let keyWindow = windows.first(where: { $0.isKeyWindow }) else { return nil }
        var topController = keyWindow.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
}
extension AppDelegate {
    func initiateGigya() {
        let environmentIs = Constants.Api.versionUrl
        var gigyaApiKey = gigyaApiKeyStageDev
        
        if !environmentIs.contains("stageapi") && !environmentIs.contains("devapi") {
            gigyaApiKey = gigyaApiKeyProd
        }
        Gigya.sharedInstance().initFor(apiKey: gigyaApiKey, apiDomain: gigyaApiDomain, cname: gigyaCname)
    }
}
