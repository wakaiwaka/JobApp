//
//  TradingConpanyViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds
import XLPagerTabStrip

class TradingConpanyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate,IndicatorInfoProvider {
    private let indicatorInfo:IndicatorInfo = "商社"
    private let realm = try! Realm()
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var tradingArray = realm.objects(Company.self).filter("industoryId == 2")
    
    
    //広告ID
    let AdMobId = "ca-app-pub-3336069459205462~1528928650"
    
    // true:テスト
    let AdMobTest:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.backgroundColor = UIColor.lightSkyBlue
        addButton.layer.cornerRadius = 25
        
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        var admobView = GADBannerView()
        
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        // iPhone X のポートレート決め打ちです
        let tabBarController:UITabBarController = UITabBarController()
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - 34)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        
        addButton.frame.origin = CGPoint(x: self.view.frame.size.width - addButton.frame.size.width - 10, y: self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - 34 - self.addButton.frame.size.height)
        self.view.addSubview(addButton)

        
        admobView.adUnitID = AdMobId
        admobView.delegate = self
        
        admobView.rootViewController = self
//        let request = GADRequest()
//        request.testDevices = ["f803f474dab3f72d16be899ff19f936c"]
//        admobView.load(request)
        admobView.load(GADRequest())
        
        self.view.addSubview(admobView)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return indicatorInfo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = tradingArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = company.name
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trading = self.tradingArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditCompanyViewController") as! EditCompanyViewController
        vc.company = trading
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let company = Company()
        company.industoryId = 2
        let allCompanyArray = realm.objects(Company.self).sorted(byKeyPath: "id", ascending: false)
        if allCompanyArray.count != 0{
            company.id = (allCompanyArray.first?.id)! + 1
        }
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCompanyViewController") as! EditCompanyViewController
        editVC.company = company
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let trailing = realm.objects(Company.self).filter("id == %@",self.tradingArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(trailing!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
