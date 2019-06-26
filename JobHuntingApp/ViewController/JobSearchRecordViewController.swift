//
//  JobSearchRecordViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/18.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CSS3ColorsSwift
import GoogleMobileAds

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class JobSearchRecordViewController: ButtonBarPagerTabStripViewController,GADBannerViewDelegate {

    //広告ID
    let AdMobId = "ca-app-pub-3336069459205462~1528928650"
    
    override func viewDidLoad() {
        settings.style.buttonBarItemLeftRightMargin = 10
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor = UIColor.lightSkyBlue
        settings.style.selectedBarBackgroundColor = UIColor.lightSkyBlue
        settings.style.selectedBarHeight = 3
        super.viewDidLoad()
        
        self.navigationItem.title = "就職活動記録"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.lightSkyBlue]
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        var admobView = GADBannerView()
        admobView.delegate = self
        
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        // iPhone X のポートレート決め打ちです
        let tabBarController:UITabBarController = UITabBarController()
        if #available(iOS 11.0, *) {
            admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - UIApplication.shared.keyWindow!.safeAreaInsets.bottom)
        } else {
            admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - 34)
            admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        }
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        
        admobView.adUnitID = AdMobId
        
        admobView.rootViewController = self
//        let request = GADRequest()
//        request.testDevices = ["f803f474dab3f72d16be899ff19f936c"]
//        admobView.load(request)
        admobView.load(GADRequest())
        
        self.view.addSubview(admobView)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let internshipViewController = self.storyboard?.instantiateViewController(withIdentifier: "InternshipViewController") as! InternshipViewController
        
        let briefingViewController = self.storyboard?.instantiateViewController(withIdentifier: "BriefingViewController") as! BriefingViewController
        
        let interviewController = self.storyboard?.instantiateViewController(withIdentifier: "InterviewViewController") as! InterviewViewController
        
        let visitOBViewController = self.storyboard?.instantiateViewController(withIdentifier: "VisitOBViewController") as! VisitOBViewController
        
        let viewControllers = [internshipViewController,briefingViewController,interviewController,visitOBViewController]
        
        return viewControllers
    }


}
