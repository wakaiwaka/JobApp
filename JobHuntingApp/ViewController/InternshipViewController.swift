//
//  InternshipViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/18.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class InternshipViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,IndicatorInfoProvider {

    private let realm = try! Realm()
    private let indicatorInfo:IndicatorInfo = "インターンシップ"
    private let internshipArray = try! Realm().objects(InternShip.self)
    
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
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return indicatorInfo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.internshipArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let internship = self.internshipArray[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = internship.name
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    @IBAction func addButtonDidTapped(_ sender: UIButton) {
        
        let internship = InternShip()
        
        if self.internshipArray.count != 0{
            internship.id = self.internshipArray.first!.id + 1
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInternshipViewController") as! AddInternshipViewController
        
        vc.internship = internship
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let internship = self.internshipArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInternshipViewController") as! AddInternshipViewController
        vc.internship = internship
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
            let internship = realm.objects(InternShip.self).filter("id == %@",self.internshipArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(internship!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
