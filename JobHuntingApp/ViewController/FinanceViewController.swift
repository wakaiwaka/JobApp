//
//  FinanceViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class FinanceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider {
    private let indicatorInfo:IndicatorInfo = "金融"
    private let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private lazy var financeArray = try! Realm().objects(Company.self).filter("industoryId == 4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.backgroundColor = UIColor.lightSkyBlue
        addButton.layer.cornerRadius = 25
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return indicatorInfo
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let company = Company()
        company.industoryId = 4
        let allCompanyArray = realm.objects(Company.self).sorted(byKeyPath: "id", ascending: false)
        if allCompanyArray.count != 0{
            company.id = (allCompanyArray.first?.id)! + 1
        }
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCompanyViewController") as! EditCompanyViewController
        editVC.company = company
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return financeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = self.financeArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = company.name
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
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
            let finance = realm.objects(Company.self).filter("id == %@",self.financeArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(finance!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
