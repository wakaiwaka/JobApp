//
//  AddBriefingViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/18.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class AddBriefingViewController: FormViewController {
    
    public var briefing:Seminar!
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< TextRow("name"){
                $0.tag = "name"
                $0.title = "企業名"
                $0.placeholder = "例）株式会社〇〇"
                
                if self.briefing.name.isEmpty == false{
                    $0.value = self.briefing.name
                }
                
            }
            
            +++ Section("日時")
            <<< DateInlineRow("date"){
                $0.tag = "date"
                $0.value = self.briefing.date
            }
            
            +++ Section("内容")
            <<< TextAreaRow(){
                $0.tag = "content"
                
                if self.briefing.content.isEmpty == false{
                    $0.value = self.briefing.content
                }
            }
            
            +++ Section("質問")
            <<< TextAreaRow(){
                $0.tag = "question"
                if self.briefing.question.isEmpty == false{
                    $0.value = self.briefing.question
                }
            }
            
            +++ Section("回答")
            <<< TextAreaRow(){
                $0.tag = "answer"
                if self.briefing.answer.isEmpty == false{
                    $0.value = self.briefing.answer
                }
        }
        
            +++ Section("")
            <<< ButtonRow(){
                $0.title = "友達にLineで共有する"
                
                if self.briefing.name.isEmpty{
                    $0.hidden = true
                }
                
                $0.onCellSelection{[unowned self] cell,row in
                    
                    let nameText = self.briefing.name
                    let date = self.briefing.date
                    
                    let formatter:DateFormatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    
                    let dateText = formatter.string(from: date)
                    
                    let contentText = self.briefing.content
                    let questionText = self.briefing.question
                    let answerText = self.briefing.answer
                    
                    self.sendMessage(text: """
                                       [企業説明会・セミナー]
                        企業名:\(nameText)
                        
                        日付:\(dateText)
                        
                        内容:\(contentText)
                        
                        質問:\(questionText)
                        
                        答え:\(answerText)
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
        
        do{
            try Realm().write {
                if let name = nameText.value{
                    self.briefing.name = name
                }else{
                    showAlert(vc: self, message: "企業名を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let date = dateText.value{
                    self.briefing.date = date
                }else{
                    showAlert(vc: self, message: "日付を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let content = contentText.value{
                    self.briefing.content = content
                }else{
                    self.briefing.content = ""
                }
                
                if let question = questionText.value{
                    self.briefing.question = question
                }else{
                    self.briefing.question = ""
                }
                
                if let answer = answerText.value{
                    self.briefing.answer = answer
                }else{
                    self.briefing.answer = ""
                }
                
                realm.add(self.briefing,update: true)
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
