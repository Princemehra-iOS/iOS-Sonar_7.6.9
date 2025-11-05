//
//  splashViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 02/01/17.
//  Copyright © 2017 "". All rights reserved.


import UIKit
import MediaPlayer
import AVKit

class splashViewController: UIViewController {
    // MARK: 🟠 - VARIABLES
    var moviePlayer: AVPlayerViewController?
    var termCondition = "Terms&Condition"
    
    // MARK: 🟠 - VIEW LIFE CYCLE
    fileprivate func haveChickenAndTurkeyAccess(_ birdTypeId: Int) {
        if UserDefaults.standard.bool(forKey: "login") == true && UserDefaults.standard.bool(forKey: "Chicken") == true ||  UserDefaults.standard.bool(forKey: "login") == true && UserDefaults.standard.bool(forKey: "turkey") == true{
            self.initiateLeftPenal()
        }
        else if birdTypeId == 2 {
            UserDefaults.standard.set(true, forKey: "turkey")
        }
        else if birdTypeId == 1 {
            UserDefaults.standard.set(false, forKey: "turkey")
        }
        else if  UserDefaults.standard.bool(forKey: termCondition) == true {
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "terms") as? Terms_ConditionViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
        else {
            if birdTypeId == 3 && UserDefaults.standard.bool(forKey: "login") == true{
                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier:  "BirdsSelectionVC") as? BirdsSelectionVC
                self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            }
            else{
                self.initiateLeftPenal()
            }
        }
    }
    
    fileprivate func haveTurkeyAccess() {
        if  UserDefaults.standard.bool(forKey: termCondition) == true {
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "terms") as? Terms_ConditionViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
        else {
            self.initiateLeftPenal()
        }
        UserDefaults.standard.set(true, forKey: "turkey")
    }
    
    fileprivate func haveChickenAccess() {
        if  UserDefaults.standard.bool(forKey: termCondition) == true {
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "terms") as? Terms_ConditionViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
        else {
            self.initiateLeftPenal()
        }
        UserDefaults.standard.set(false, forKey: "turkey")
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        let totalExustingArr = CoreDataHandlerTurkey().fetchAllWithOutFeddTurkey(capNec:1, birdTypeId: 1).mutableCopy() as! NSMutableArray
        for i in 0..<totalExustingArr.count{
            let postingSession : PostingSessionTurkey = totalExustingArr.object(at: i) as! PostingSessionTurkey
            let pid = postingSession.postingId
            let feedProgram =  CoreDataHandlerTurkey().FetchFeedProgramTurkey(pid!)
            if feedProgram.count == 0{
                CoreDataHandlerTurkey().updatePostingSessionOndashBoardTurkey(pid!, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
                CoreDataHandlerTurkey().deletefieldVACDataWithPostingIdTurkey(pid!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(pid!)
            }
        }
        playVideo()
        let seconds = 11.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
        
            let birdTypeId = UserDefaults.standard.integer(forKey: "birdTypeId")
            
            if birdTypeId == 3{
                self.haveChickenAndTurkeyAccess(birdTypeId)
            }
            else if birdTypeId == 2 {
                self.haveTurkeyAccess()
                
            }
            else if birdTypeId == 1 {
                self.haveChickenAccess()
            }
            else {
                self.initiateLeftPenal()
            }})
    }
    
    // MARK: 🟠 - METHODS AND FUNCTIONS
    func initiateLeftPenal() {
        let containerViewController = ContainerViewController()
        UIApplication.shared.keyWindow?.rootViewController = containerViewController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    // MARK: 🟠 - Play Video
    func playVideo() {
        let videoPath = Bundle.main.path(forResource: "Zoetis_video", ofType: "mp4")
        let videoURL = URL(fileURLWithPath: videoPath!)
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.showsPlaybackControls = false
        
        playerViewController.player = player
        playerViewController.player!.play()
        self.navigationController?.pushViewController(playerViewController, animated: false)
    }
}
