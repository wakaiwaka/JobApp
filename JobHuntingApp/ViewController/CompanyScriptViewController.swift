//
//  CompanyScriptViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CSS3ColorsSwift
import GoogleMobileAds

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class CompanyScriptViewController: ButtonBarPagerTabStripViewController,GADBannerViewDelegate {
    
    //広告ID
    let AdMobId = "ca-app-pub-3336069459205462~6840965082"
    
    
    override func viewDidLoad() {
        settings.style.buttonBarItemLeftRightMargin = 10
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor = UIColor.lightSkyBlue
        settings.style.selectedBarBackgroundColor = UIColor.lightSkyBlue
        settings.style.selectedBarHeight = 3
        super.viewDidLoad()
        
        self.navigationItem.title = "企業分析"
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
        let manuVC = self.storyboard?.instantiateViewController(withIdentifier: "ManufactureViewController") as! ManufactureViewController
        let tradingVC = self.storyboard?.instantiateViewController(withIdentifier: "TradingConpanyViewController") as! TradingConpanyViewController
        let retailVC = self.storyboard?.instantiateViewController(withIdentifier: "RetailViewController") as! RetailViewController
        let financeVC = self.storyboard?.instantiateViewController(withIdentifier: "FinanceViewController") as! FinanceViewController
        let techVC = self.storyboard?.instantiateViewController(withIdentifier: "TechnologyViewController") as! TechnologyViewController
        let adVC = self.storyboard?.instantiateViewController(withIdentifier: "AdViewController") as! AdViewController
        let otherVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherCompanyViewController") as! OtherCompanyViewController
        
        let companyScriptVC = [manuVC,tradingVC,retailVC,financeVC,techVC,adVC,otherVC]
        
        return companyScriptVC
    }
}
