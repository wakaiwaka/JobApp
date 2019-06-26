//
//  AddInternshipViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/18.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class AddInternshipViewController: FormViewController {
    
    public var internship:InternShip!
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< TextRow("name"){
                $0.tag = "name"
                $0.title = "企業名"
                $0.placeholder = "例）株式会社〇〇"
                
                if self.internship.name.isEmpty == false{
                    $0.value = self.internship.name
                }
                
            }
            
            +++ Section("日時")
            <<< DateInlineRow("date"){
                $0.tag = "date"
                $0.value = self.internship.date
            }
            
            +++ Section("内容")
            <<< TextAreaRow(){
                $0.tag = "content"
                if self.internship.content.isEmpty == false{
                    $0.value = self.internship.content
                }
            }
            
            +++ Section("質問")
            <<< TextAreaRow(){
                $0.tag = "question"
                if self.internship.content.isEmpty == false{
                    $0.value = self.internship.content
                }
            }
            
            +++ Section("回答")
            <<< TextAreaRow(){
                $0.tag = "answer"
                if self.internship.content.isEmpty == false{
                    $0.value = self.internship.content
                }
            }

            
            
            +++ Section("反省点")
            <<< TextAreaRow(){
                $0.tag = "reflection"
                $0.placeholder = ""
                if self.internship.reflect.isEmpty == false{
                    $0.value = self.internship.reflect
                }
        }
        
            +++ Section("")
            <<< ButtonRow(){
                $0.title = "友達にLineで共有する"
                
                if self.internship.name.isEmpty{
                    $0.hidden = true
                }
                
                $0.onCellSelection{[unowned self] cell,row in
                    
                    let nameText = self.internship.name
                    let date = self.internship.date
                    
                    let formatter:DateFormatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    
                    let dateText = formatter.string(from: date)
                    
                    let contentText = self.internship.content
                    let questionText = self.internship.question
                    let answerText = self.internship.answer
                    let reflectionText = self.internship.reflect
                    
                    self.sendMessage(text: """
                                       [インターンシップ]
                        企業名:\(nameText)
                        
                        日付:\(dateText)
                        
                        内容:\(contentText)
                        
                        質問:\(questionText)
                        
                        答え:\(answerText)
                        
                        反省:\(reflectionText
                        )
                        """)
                }
        }
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let nameText = form.rowBy(tag: "name") as! TextRow
        let dateText = form.rowBy(tag: "date") as! DateInlineRow
        let contentText = form.rowBy(tag: "content") as! TextAreaRow
        let questionText = form.rowBy(tag: "question") as! TextAreaRow
        let answerText = form.rowBy(tag: "answer") as! TextAreaRow
        let reflectionText = form.rowBy(tag: "reflection") as! TextAreaRow
        
        do{
            try Realm().write {
                if let name = nameText.value{
                    self.internship.name = name
                }else{
                    showAlert(vc: self, message: "企業名を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let date = dateText.value{
                    self.internship.date = date
                }else{
                    showAlert(vc: self, message: "日付を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let content = contentText.value{
                    self.internship.content = content
                }else{
                    self.internship.content = ""
                }
                
                if let question = questionText.value{
                    self.internship.question = question
                }else{
                    self.internship.question = ""
                }
                
                if let answer = answerText.value{
                    self.internship.answer = answer
                }else{
                    self.internship.answer = ""
                }
                
                if let reflect = reflectionText.value{
                    self.internship.reflect = reflect
                }else{
                    self.internship.reflect = ""
                }
                
                realm.add(self.internship,update: true)
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
