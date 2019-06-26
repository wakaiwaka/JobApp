//
//  ListScheduleViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/15.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import CSS3ColorsSwift
import GoogleMobileAds

class ListScheduleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,GADBannerViewDelegate{
    
    @IBOutlet weak var planeTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var belongingsTitle: UILabel!
    
    
    
    @IBOutlet weak var plane: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var belogings: UILabel!
    
    private let realm = try! Realm()
    public var selectDate:Date!
    
    //広告ID
    let AdMobId = "ca-app-pub-3336069459205462~1528928650"
    
    public var dateString:String = "" //yyyy/MM/dd
    private lazy var todaySchedules = try! Realm().objects(Schedule.self).filter("dateString == %@",self.dateString)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.backgroundColor = UIColor.lightSkyBlue
        addButton.layer.cornerRadius = 25
        
        planeTitle.textColor = UIColor.lightSkyBlue
        dateTitle.textColor = UIColor.lightSkyBlue
        placeTitle.textColor = UIColor.lightSkyBlue
        belongingsTitle.textColor = UIColor.lightSkyBlue
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaySchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todaySchedule = self.todaySchedules[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todaySchedule.plan
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: todaySchedule.date)
        cell.detailTextLabel?.text = timeString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todaySchedule = self.todaySchedules[indexPath.row]
        self.plane.text = todaySchedule.plan
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        self.date.text = formatter.string(from: todaySchedule.date)
        
        self.place.text = todaySchedule.place
        
        self.belogings.text = todaySchedule.belongings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        self.plane.text = ""
        self.place.text = ""
        self.date.text = ""
        self.belogings.text = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let schedule = realm.objects(Schedule.self).filter("id == %@",self.todaySchedules[indexPath.row].id).first
            try! Realm().write {
                realm.delete(schedule!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let navi = self.storyboard?.instantiateViewController(withIdentifier: "createNavi") as! UINavigationController
        
        let vc = navi.topViewController as! CreateScheduleViewController
        
        let allSchedules = try! Realm().objects(Schedule.self)
        let schedule:Schedule = Schedule()
        
        if allSchedules.count != 0{
            schedule.id = (realm.objects(Schedule.self).sorted(byKeyPath: "id", ascending: false).first?.id)! + 1
        }
        vc.schedule = schedule
        vc.selectDate = self.selectDate
        
        self.present(navi,animated: true,completion: nil)
    }
    
    
    
}
