//
//  InterviewViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/18.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

class InterviewViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider {
    
    private let indictorInfo:IndicatorInfo = "面接"
    
    private let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private let interviewArray = try! Realm().objects(Interview.self).sorted(byKeyPath: "id", ascending: false)
    
    
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
        return indictorInfo
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let interview = self.interviewArray[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = interview.name
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    @IBAction func addButtonDidTapped(_ sender: UIButton){
        
        var interview = Interview()
        
        if interviewArray.count != 0{
            interview.id = (self.interviewArray.first?.id)!
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInterviewViewController") as! AddInterviewViewController
        
        vc.interview = interview
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let interview = self.interviewArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddInterviewViewController") as! AddInterviewViewController
        vc.interview = interview
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
            let interview = realm.objects(Interview.self).filter("id == %@",self.interviewArray[indexPath.row].id).first
            try! Realm().write {
                realm.delete(interview!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    
}
