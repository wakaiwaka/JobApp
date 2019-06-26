//
//  ManufactureViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip
import GoogleMobileAds

class ManufactureViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,IndicatorInfoProvider {
    
    private let indicatorInfo:IndicatorInfo = "メーカー"
    private let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private lazy var manufactureArray:Results<Company> = realm.objects(Company.self).filter("industoryId == 1")
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return indicatorInfo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manufactureArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = manufactureArray[indexPath.row].name
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditCompanyViewController") as! EditCompanyViewController
        let manufacture = self.manufactureArray[indexPath.row]
        vc.company = manufacture
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let company = Company()
        company.industoryId = 1
        let allCompanyArray = realm.objects(Company.self).sorted(byKeyPath: "id", ascending: false)
        if allCompanyArray.count != 0{
            company.id = (allCompanyArray.first?.id)! + 1
        }
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCompanyViewController") as! EditCompanyViewController
        editVC.company = company
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let manufacture = realm.objects(Company.self).filter("id == %@",self.manufactureArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(manufacture!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    
}
