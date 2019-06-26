//
//  RetailViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class RetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider {
    
    private let indicatorInfo:IndicatorInfo = "小売・流通"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    private let realm = try! Realm()
    
    private lazy var retailArray = try! Realm().objects(Company.self).filter("industoryId == 3")
    
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
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let company = Company()
        company.industoryId = 3
        let allCompanyArray = realm.objects(Company.self).sorted(byKeyPath: "id", ascending: false)
        if allCompanyArray.count != 0{
            company.id = (allCompanyArray.first?.id)! + 1
        }
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCompanyViewController") as! EditCompanyViewController
        editVC.company = company
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return indicatorInfo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = self.retailArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = company.name
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = self.retailArray[indexPath.row]
        let edtiVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCompanyViewController") as! EditCompanyViewController
        edtiVC.company = company
        self.navigationController?.pushViewController(edtiVC, animated: true)
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
            let retail = realm.objects(Company.self).filter("id == %@",self.retailArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(retail!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
