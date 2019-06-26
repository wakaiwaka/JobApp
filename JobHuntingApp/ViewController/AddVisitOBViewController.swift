//
//  AddVisitOBViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/19.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka

class AddVisitOBViewController:FormViewController {
    
    public var visitOB:VisitOB!
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< TextRow(""){
                $0.tag = "companyName"
                $0.title = "企業名"
                $0.placeholder = "例）株式会社〇〇"
                
                if self.visitOB.companyName.isEmpty == false{
                    $0.value = self.visitOB.companyName
                }
                
            }
            
            <<< TextRow(""){
                $0.tag = "humanName"
                $0.title = "従業員名"
                $0.placeholder = "例）田中　太郎"
                
                if self.visitOB.humanName.isEmpty == false{
                    $0.value = self.visitOB.humanName
                }
                
            }
            
            <<< TextRow(""){
                $0.tag = "department"
                $0.title = "部署名"
                $0.placeholder = "例）人事部"
                
                if self.visitOB.department.isEmpty == false{
                    $0.value = self.visitOB.department
                }
                
            }
            
            +++ Section("業務内容")
            <<< TextAreaRow(){
                $0.tag = "businessContents"
                if self.visitOB.businessContents.isEmpty == false{
                    $0.value = self.visitOB.businessContents
                }
            }

            +++ Section("質問")
            <<< TextAreaRow(){
                $0.tag = "question"
                if self.visitOB.question.isEmpty == false{
                    $0.value = self.visitOB.question
                }
            }
            
            +++ Section("回答")
            <<< TextAreaRow(){
                $0.tag = "answer"
                if self.visitOB.answer.isEmpty == false{
                    $0.value = self.visitOB.answer
                }
            }
        
            +++ Section("感想")
            <<< TextAreaRow(){
                $0.tag = "impressions"
                if self.visitOB.answer.isEmpty == false{
                    $0.value = self.visitOB.answer
                }
        }
        
            +++ Section("")
            <<< ButtonRow(){
                $0.title = "友達にLineで共有する"
                
                if self.visitOB.companyName.isEmpty{
                    $0.hidden = true
                }
                
                $0.onCellSelection{[unowned self] cell,row in
                    
                    let comapannyNameText = self.visitOB.companyName
                    let humanNameText = self.visitOB.humanName
                    let departmentText = self.visitOB.department
                    let businessContentsText = self.visitOB.businessContents
                    let questionText = self.visitOB.question
                    let answerText = self.visitOB.answer
                    let impressionsText = self.visitOB.impressions
                    
                    self.sendMessage(text: """
                                        [OB訪問]
                        企業名:\(comapannyNameText)
                        
                        従業員名:\(humanNameText)
                        
                        部署名:\(departmentText)
                        
                        業務内容:\(businessContentsText)
                        
                        質問:\(questionText)
                        
                        答え:\(answerText)
                        
                        感想:\(impressionsText)
                        """)
                }
        }
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let companyNameText = form.rowBy(tag: "companyName") as! TextRow
        let humanNameText = form.rowBy(tag: "humanName") as! TextRow
        let departmentText = form.rowBy(tag: "department") as! TextRow
        let businessContentsText = form.rowBy(tag: "businessContents") as! TextAreaRow
        let questionText = form.rowBy(tag: "question") as! TextAreaRow
        let answerText = form.rowBy(tag: "answer") as! TextAreaRow
        let impressionsText = form.rowBy(tag: "impressions") as! TextAreaRow
        
        do{
            try Realm().write {
                if let companyName = companyNameText.value{
                    self.visitOB.companyName = companyName
                }else{
                    showAlert(vc: self, message: "企業名を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let humanName = humanNameText.value{
                    self.visitOB.humanName = humanName
                }else{
                    showAlert(vc: self, message: "従業員の名前を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let department = departmentText.value{
                    self.visitOB.department = department
                }else{
                    self.visitOB.department = ""
                }
                
                if let businessContents = businessContentsText.value{
                    self.visitOB.businessContents = businessContents
                }else{
                    self.visitOB.businessContents = ""
                }
                
                if let question = questionText.value{
                    self.visitOB.question = question
                }else{
                    self.visitOB.question = ""
                }
                
                if let answer = answerText.value{
                    self.visitOB.answer = answer
                }else{
                    self.visitOB.answer = ""
                }
                
                if let impressions = impressionsText.value{
                    self.visitOB.impressions = impressions
                }else{
                    self.visitOB.impressions = ""
                }
                
                realm.add(visitOB,update: true)
                showAlert(vc: self, message: "保存しました", useCancel: false, defalutActionText: "OK", onPushOK: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
            
        }catch{
            showAlert(vc: self, message: "エラーが発生しました", useCancel: false, defalutActionText: "OK")
        }
        
    }
    
    
    /// Lineでメッセージを送信する
    ///
    /// - Parameter text: 送信するテキスト
    private func sendMessage(text:String){
        
        let lineSchemeMessage = "line://msg/text/"
        var message:String! = lineSchemeMessage + text
        
        message = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url:URL! = URL(string: message)
        self.openURL(url: url)
        
    }
    
    /// URLを開く処理
    ///
    /// - Parameter url: 開くURL
    private func openURL(url:URL){
        showAlert(vc: self, message: "Lineで共有しますか？", useCancel: true, defalutActionText: "OK") {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }else{
                showAlert(vc: self, message: "Lineがダウンロードされていません", useCancel: false, defalutActionText: "OK")
            }
        }
    }
    

}
