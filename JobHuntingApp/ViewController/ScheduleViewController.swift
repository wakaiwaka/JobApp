//
//  ScheduleViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/15.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import CSS3ColorsSwift
import GoogleMobileAds

class ScheduleViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,GADBannerViewDelegate{
    @IBOutlet weak var FSCalendar: FSCalendar!
    private lazy var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    //広告ID
    let AdMobId = "ca-app-pub-3336069459205462~1528928650"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FSCalendar.dataSource = self
        FSCalendar.delegate = self
        FSCalendar.appearance.todayColor = UIColor.mediumAquamarine
        FSCalendar.appearance.selectionColor = UIColor.lightSkyBlue
        self.navigationItem.title = "スケジュール"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.lightSkyBlue]
        
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        var admobView = GADBannerView()
        admobView.delegate = self
        
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        
        let tabBarController:UITabBarController = UITabBarController()
        if #available(iOS 11.0, *) {
            admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - UIApplication.shared.keyWindow!.safeAreaInsets.bottom)
        } else {
            admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - 34)
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
    
    /// 祝日かどうかを判断するメソッド
    ///
    /// - Parameter date: 祝日かどうかを比較する日付
    /// - Returns: 祝日か否かをBool型でreturnする
    private func judgeHoliday(_ date:Date) -> Bool{
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    /// 何曜日かを判定するメソッド
    ///
    /// - Parameter date: 判断する日付
    /// - Returns: 何番目の数字かをInt型でreturnする
    private func getWeekIndex(_ date:Date) -> Int{
        let tmpCalendar:Calendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if self.judgeHoliday(date){
            return UIColor.red
        }
        let weekIndex = getWeekIndex(date)
        if weekIndex == 1{
            return UIColor.red
        }else if weekIndex == 7{
            return UIColor.blue
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: date)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListScheduleViewController") as! ListScheduleViewController
        
        vc.dateString = dateString
        vc.selectDate = date
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.orange]
    }
}
