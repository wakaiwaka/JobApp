//
//  SelfAnalysisViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/19.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class SelfAnalysisViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate{
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private let realm = try! Realm()
    
    private lazy var SelfAnalysisArray = try! Realm().objects(SelfAnalysis.self).sorted(byKeyPath: "id", ascending: false)
    
    //広告ID
    let AdMobId = "ca-app-pub-3336069459205462~6840965082"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource  = self
        self.tableView.tableFooterView = UIView()
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.backgroundColor = UIColor.lightSkyBlue
        addButton.layer.cornerRadius = 25
        self.navigationItem.title = "自己分析"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.lightSkyBlue]
        
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        var admobView = GADBannerView()
        
        
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.delegate = self
        
        let tabBarController:UITabBarController = UITabBarController()
        if #available(iOS 11.0, *) {
            admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - UIApplication.shared.keyWindow!.safeAreaInsets.bottom)
        } else {
                admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - 34)
        }
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        
        if #available(iOS 11.0, *) {
            addButton.frame.origin = CGPoint(x: self.view.frame.size.width - addButton.frame.size.width - 10, y: self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - UIApplication.shared.keyWindow!.safeAreaInsets.bottom - self.addButton.frame.size.height)
        } else {
            addButton.frame.origin = CGPoint(x: self.view.frame.size.width - addButton.frame.size.width - 10, y: self.view.frame.size.height - admobView.frame.height - tabBarController.tabBar.frame.size.height - 34 - self.addButton.frame.size.height)
        }
        self.view.addSubview(addButton)
        
        admobView.adUnitID = AdMobId
        
        admobView.rootViewController = self
//        let request = GADRequest()
//        request.testDevices = ["f803f474dab3f72d16be899ff19f936c"]
//        admobView.load(request)
        admobView.load(GADRequest())
        
        self.view.addSubview(admobView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SelfAnalysisArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let selfAnalysis = self.SelfAnalysisArray[indexPath.row]
        cell.textLabel?.text = selfAnalysis.name
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  selfAnalysis = self.SelfAnalysisArray[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSelfAnalysisViewController") as! AddSelfAnalysisViewController
        
        vc.selfAnalysis = selfAnalysis
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let  selfAnalysis = SelfAnalysis()
        
        if self.SelfAnalysisArray.count != 0{
            selfAnalysis.id = (SelfAnalysisArray.first?.id)! + 1
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSelfAnalysisViewController") as! AddSelfAnalysisViewController
        
        vc.selfAnalysis = selfAnalysis
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let selfAnalysis = realm.objects(SelfAnalysis.self).filter("id == %@",self.SelfAnalysisArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(selfAnalysis!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
