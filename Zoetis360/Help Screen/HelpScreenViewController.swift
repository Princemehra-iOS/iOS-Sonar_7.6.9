//
//  HelpScreenViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 14/02/17.
//  Copyright © 2017 "". All rights reserved.
//

import UIKit

class HelpScreenViewController: UIViewController,UIScrollViewDelegate  {
    
    // MARK: - VARIABLE
    var timer = Timer()
    
    // MARK: 🟠 - OUTLET
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    
    // MARK: 🟠 - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        acceptButton.alpha = 0
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "Help_step1")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "Help_step2")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "Help_step3")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "Help_step4")
        
        let img5 = UIImageView(frame: CGRect(x:scrollViewWidth*4, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img5.image = UIImage(named: "Help_step5")
        let img6 = UIImageView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img6.image = UIImage(named: "Help_step6")
        let img7 = UIImageView(frame: CGRect(x:scrollViewWidth*6, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img7.image = UIImage(named: "Help_step7")
        let img8 = UIImageView(frame: CGRect(x:scrollViewWidth*7, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img8.image = UIImage(named: "Help_step8")
        
        
        let img9 = UIImageView(frame: CGRect(x:scrollViewWidth*8, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img9.image = UIImage(named: "Help_step9")
        let img10 = UIImageView(frame: CGRect(x:scrollViewWidth*9, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img10.image = UIImage(named: "Help_step10")
        let img11 = UIImageView(frame: CGRect(x:scrollViewWidth*10, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img11.image = UIImage(named: "Help_step11")
        let img12 = UIImageView(frame: CGRect(x:scrollViewWidth*11, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img12.image = UIImage(named: "Help_step12")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        self.scrollView.addSubview(img5)
        self.scrollView.addSubview(img6)
        self.scrollView.addSubview(img7)
        self.scrollView.addSubview(img8)
        self.scrollView.addSubview(img9)
        self.scrollView.addSubview(img10)
        self.scrollView.addSubview(img11)
        self.scrollView.addSubview(img12)
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 12, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: 🟠 - METHOD & FUNCTION
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 12
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
    // MARK: 🟠 UIScrollView Delegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage)
        
        if Int(currentPage) == 0{
            self.declineButton.alpha = 1
            self.acceptButton.alpha = 0
        }
        else if Int(currentPage) == 1{
            print(appDelegateObj.testFuntion())
        }else if Int(currentPage) == 2{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 3{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 4{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 5{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 6{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 7{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 8{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 9{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 10{
            print(appDelegateObj.testFuntion())
        }
        else if Int(currentPage) == 11{
            UIView.animate(withDuration: 1.0, animations:{ () -> Void in
                self.declineButton.alpha = 0
                self.acceptButton.alpha = 1
                
            })
        }
    }
    
    // MARK: 🟠 - IBACTION
    @IBAction func acceptButton(_ sender: AnyObject) {
        self.dasBoradPush()
    }
    
    @IBAction func declinetButton(_ sender: AnyObject) {
        self.dasBoradPush()
    }
    
    func dasBoradPush()  {
        self.timer.invalidate()
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DashView_Controller") as? DashViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
}

