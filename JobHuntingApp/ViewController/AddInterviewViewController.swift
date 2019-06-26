//
//  AddInterviewViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/18.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class AddInterviewViewController: FormViewController {
    
    public var interview:Interview!
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< TextRow("name"){
                $0.tag = "name"
                $0.title = "企業名"
                $0.placeholder = "例）株式会社〇〇"
                if self.interview.name.isEmpty == false{
                    $0.value = self.interview.name
                }
            }
            
            +++ Section("日時")
            <<< DateInlineRow("date"){
                $0.tag = "date"
                $0.value = self.interview.date
            }
            
            +++ Section()
            <<< TextRow("format"){
                $0.tag = "format"
                $0.title = "形式"
                $0.placeholder = "グループ面接"
                if self.interview.format.isEmpty == false{
                    $0.value = self.interview.format
                }
            }
            
            +++ Section()
            <<< TextRow(){
                $0.tag = "level"
                $0.title = "面接のレベル"
                $0.placeholder = "一次面接"
                if self.interview.level.isEmpty == false{
                    $0.value = self.interview.level
                }
            }
            
            +++ Section("質問")
            <<< TextAreaRow(){
                $0.tag = "question"
                if self.interview.question.isEmpty == false{
                    $0.value = self.interview.question
                }
            }
            
            +++ Section("回答")
            <<< TextAreaRow(){
                $0.tag = "answer"
                if self.interview.answer.isEmpty == false{
                    $0.value = self.interview.answer
                }
            }
            
            +++ Section("結果")
            <<< TextRow(){
                $0.tag = "result"
                $0.placeholder = "合格"
                if self.interview.result.isEmpty == false{
                    $0.value = self.interview.result
                }
            }
            
            +++ Section("反省点")
            <<< TextAreaRow(){
                $0.tag = "reflection"
                $0.placeholder = ""
                if self.interview.reflect.isEmpty == false{
                    $0.value = self.interview.reflect
                }
            }
            
            +++ Section("")
            <<< ButtonRow(){
                $0.title = "友達にLineで共有する"
                
                if self.interview.name.isEmpty{
                    $0.hidden = true
                }
                
                $0.onCellSelection{[unowned self] cell,row in
                    
                    let nameText = self.interview.name
                    let date = self.interview.date
                    
                    let formatter:DateFormatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    
                    let dateText = formatter.string(from: date)
                    
                    let formatText = self.interview.format
                    let levelText = self.interview.level
                    let questionText = self.interview.question
                    let answerText = self.interview.answer
                    let resultText = self.interview.result
                    let reflectionText = self.interview.reflect
                    
                    self.sendMessage(text: """
                        [面接]
                        企業名:\(nameText)
                        
                        日付:\(dateText)
                        
                        形式:\(formatText)
                        
                        面接のレベル:\(levelText)
                        
                        質問:\(questionText)
                        
                        答え:\(answerText)
                        
                        結果:\(resultText)
                        
                        反省:\(reflectionText
                        )
                        """)
                }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let nameText = form.rowBy(tag: "name") as! TextRow
        let dateText = form.rowBy(tag: "date") as! DateInlineRow
        let formatText = form.rowBy(tag: "format") as! TextRow
        let levelText = form.rowBy(tag: "level") as! TextRow
        let questionText = form.rowBy(tag: "question") as! TextAreaRow
        let answerText = form.rowBy(tag: "answer") as! TextAreaRow
        let resultText = form.rowBy(tag: "result") as! TextRow
        let reflectionText = form.rowBy(tag: "reflection") as! TextAreaRow
        
        do{
            try Realm().write {
                if let name = nameText.value{
                    self.interview.name = name
                }else{
                    showAlert(vc: self, message: "企業名を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let date = dateText.value{
                    self.interview.date = date
                }else{
                    showAlert(vc: self, message: "日付を入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let format = formatText.value{
                    self.interview.format = format
                }else{
                    self.interview.format = ""
                }
                
                if let level = levelText.value{
                    self.interview.level = level
                }else{
                    self.interview.level = ""
                }
                
                if let question = questionText.value{
                    self.interview.question = question
                }else{
                    self.interview.question = ""
                }
                
                if let answer = answerText.value{
                    self.interview.answer = answer
                }else{
                    self.interview.answer = ""
                }
                
                
                if let result = resultText.value{
                    self.interview.result = result
                }else{
                    self.interview.result = ""
                }
                
                if let reflect = reflectionText.value{
                    self.interview.reflect = reflect
                }else{
                    self.interview.reflect = ""
                }
                
                realm.add(self.interview,update: true)
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
