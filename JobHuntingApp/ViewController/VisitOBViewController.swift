//
//  VisitOBViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/19.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class VisitOBViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private let realm = try! Realm()
    private let indicatorInfo:IndicatorInfo = "OB訪問"
    private let visitOBArray = try! Realm().objects(VisitOB.self).sorted(byKeyPath: "id", ascending: false)
    
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
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        let visitOB = VisitOB()
        
        if self.visitOBArray.count != 0{
            visitOB.id = (self.visitOBArray.first?.id)! + 1
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVisitOBViewController") as! AddVisitOBViewController
        
        vc.visitOB = visitOB
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let visitOB = self.visitOBArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVisitOBViewController") as! AddVisitOBViewController
        
        vc.visitOB = visitOB
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return indicatorInfo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitOBArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let visitOB = self.visitOBArray[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = visitOB.companyName
        cell.detailTextLabel?.text = visitOB.humanName
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let visitOB = realm.objects(VisitOB.self).filter("id == %@",self.visitOBArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(visitOB!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
