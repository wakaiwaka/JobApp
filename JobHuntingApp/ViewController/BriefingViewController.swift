//
//  BriefingViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/18.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class BriefingViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider{
    
    private let indicatorInfo:IndicatorInfo = "会社説明会・セミナー"
    private let briefingArray = try! Realm().objects(Seminar.self)
    private let realm = try! Realm()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.backgroundColor = UIColor.lightSkyBlue
        addButton.layer.cornerRadius = 25
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return indicatorInfo
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return briefingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let briefing = briefingArray[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = briefing.name
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    @IBAction func addButtonDidTapped(_ sender: UIButton) {
        
        let briefing = Seminar()
        
        if briefingArray.count != 0{
            briefing.id = (self.briefingArray.first?.id)! + 1
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBriefingViewController") as! AddBriefingViewController
        
        vc.briefing = briefing
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let briefing = self.briefingArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBriefingViewController") as! AddBriefingViewController
        vc.briefing = briefing
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
            let briefing = realm.objects(Seminar.self).filter("id == %@",self.briefingArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(briefing!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
