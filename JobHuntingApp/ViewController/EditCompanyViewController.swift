//
//  EditCompanyViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class EditCompanyViewController: FormViewController {
    
    public var company:Company!
    private let realm = try! Realm()
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< TextRow("name"){
                $0.tag = "name"
                $0.title = "企業名"
                $0.placeholder = "例）株式会社〇〇"
                if self.company.name.isEmpty == false{
                    $0.value = self.company.name
                }
            }
            +++ Section("経営理念")
            <<< TextAreaRow("managementPhi"){
                $0.tag = "managementPhi"
                if self.company.managementPhi.isEmpty == false{
                    $0.value = self.company.managementPhi
                }
            }
            +++ Section()
            <<< TextRow("location"){
                $0.title = "所在地"
                $0.tag = "location"
                $0.placeholder = "〇〇県〇〇市〇〇町"
                if self.company.location.isEmpty == false{
                    $0.value = self.company.location
                }
            }
            
            +++ Section("事業内容")
            <<< TextAreaRow("businessContents"){
                $0.tag = "businessContents"
                if self.company.businessContents.isEmpty == false{
                    $0.value = self.company.businessContents
                }
            }
            +++ Section("強み")
            <<< TextAreaRow("strength"){
                $0.tag = "strength"
                if self.company.strength.isEmpty == false{
                    $0.value = self.company.strength
                }
            }
            +++ Section("弱み")
            <<< TextAreaRow("weakness"){
                $0.tag = "weakness"
                if self.company.weakness.isEmpty == false{
                    $0.value = self.company.weakness
                }
            }
            
            +++ Section("興味を持った理由")
            <<< TextAreaRow("interestPoint"){
                $0.tag = "interestPoint"
                if self.company.interestPoint.isEmpty == false{
                    $0.value = self.company.interestPoint
                }
            }
            
            +++ Section("入社して貢献できるところ")
            <<< TextAreaRow("selfPR"){
                $0.tag = "selfPR"
                if self.company.selfPR.isEmpty == false{
                    $0.value = self.company.selfPR
                }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        let nameText = form.rowBy(tag: "name") as! TextRow
        let managementPhiText = form.rowBy(tag: "managementPhi") as! TextAreaRow
        let strengthText = form.rowBy(tag: "strength") as! TextAreaRow
        let weaknessText = form.rowBy(tag: "weakness") as! TextAreaRow
        let locationText = form.rowBy(tag: "location") as! TextRow
        let businessContentsText = form.rowBy(tag: "businessContents") as! TextAreaRow
        let interestPointText = form.rowBy(tag: "interestPoint") as! TextAreaRow
        let selfPRText = form.rowBy(tag: "selfPR") as! TextAreaRow
        
        do {
            try Realm().write {
                if let name = nameText.value{
                    company.name = name
                }else{
                    showAlert(vc: self, message: "企業名を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let managementPhi = managementPhiText.value{
                    company.managementPhi = managementPhi
                }else{
                    company.managementPhi = " "
                }
                
                if let strength = strengthText.value{
                    company.strength = strength
                }else{
                    company.strength = " "
                }
                
                if let weakness = weaknessText.value{
                    company.weakness = weakness
                }else{
                    company.weakness = " "
                }
                
                if let location = locationText.value{
                    company.location = location
                }else{
                    company.location = " "
                }
                
                if let businessContent = businessContentsText.value{
                    company.businessContents = businessContent
                }else{
                    company.businessContents = " "
                }
                
                if let interestPoint = interestPointText.value{
                    company.interestPoint = interestPoint
                }else{
                    company.interestPoint = " "
                }
                
                if let selfPR = selfPRText.value{
                    company.selfPR = selfPR
                }else{
                    company.selfPR = " "
                }
                
                realm.add(company,update: true)
                showAlert(vc: self, message: "保存しました", useCancel: false, defalutActionText: "OK")
            }
        }catch{
            showAlert(vc: self, message: "保存中にエラーが発生しました", useCancel: false, defalutActionText: "OK")
        }
    }
}
