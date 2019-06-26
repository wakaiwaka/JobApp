//
//  CreateScheduleViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/15.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class CreateScheduleViewController: UIViewController,GADBannerViewDelegate {
    
    public var schedule:Schedule!
    private let realm = try! Realm()
    public var selectDate:Date!
    
    @IBOutlet weak var plane: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var belongings: UITextField!
    
    //datePickerで選択された日にちを一時的に保存しておくプロパティ
    private var flagDate:Date = Date()
    
    private var datePickerView:UIDatePicker!
    private var toolBar:UIToolbar!
    
    //広告ID
    let AdMobId = "ca-app-pub-3336069459205462~1528928650"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarButton = UIBarButtonItem(title: "Done", style: .plain
            , target:self, action: #selector(doneButtonTap))
        toolBar.items = [toolBarButton]
        datePickerView = UIDatePicker()
        datePickerView.date = selectDate
        date.inputView  = datePickerView
        date.inputAccessoryView = toolBar
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        var admobView = GADBannerView()
        admobView.delegate = self
        
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        
        let tabBarController:UITabBarController = UITabBarController()
        if #available(iOS 11.0, *) {
            admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - UIApplication.shared.keyWindow!.safeAreaInsets.bottom)
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
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        try! Realm().write {
            if let planText = self.plane.text,let timeText = self.date.text,let placeText = self.place.text,let belongignsText = self.belongings.text{
                if planText.isEmpty{
                    showAlert(vc: self, message: "予定が入力されていません", useCancel: false, defalutActionText: "OK")
                    return
                }else{
                    self.schedule.plan = planText
                }
                
                if placeText.isEmpty{
                    self.schedule.place = ""
                }else{
                    self.schedule.place = placeText
                }
                
                if belongignsText.isEmpty{
                    self.schedule.belongings = ""
                }else{
                    self.schedule.belongings = belongignsText
                }
                
                if timeText.isEmpty{
                    showAlert(vc: self, message: "日時が設定されていません", useCancel: false, defalutActionText: "OK")
                }else{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    self.schedule.dateString = formatter.string(from: self.flagDate)
                    self.schedule.date = self.flagDate
                    realm.add(schedule, update: true)
                    showAlert(vc: self, message: "保存しました", useCancel: false, defalutActionText: "OK", onPushOK: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTap(){
        self.flagDate = datePickerView.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        self.date.text = formatter.string(from: datePickerView.date)
        date.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
