//
//  AddSelfAnalysisViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/19.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka

class AddSelfAnalysisViewController: FormViewController {
    
    public var selfAnalysis:SelfAnalysis!
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< TextRow("name"){
                $0.tag = "name"
                $0.title = "タイトル"
                $0.placeholder = "例）自己PR"
                if self.selfAnalysis.name.isEmpty == false{
                    $0.value = self.selfAnalysis.name
                }
            }
            +++ Section("内容")
            <<< TextAreaRow("content"){
                $0.tag = "content"
                if self.selfAnalysis.content.isEmpty == false{
                    $0.value = self.selfAnalysis.content
                }
        }
    }
    
    
    
    
    @IBAction func addSaveButtonTapped(_ sender: UIBarButtonItem) {
        
        let nameText = form.rowBy(tag: "name") as! TextRow
        let contentText = form.rowBy(tag: "content") as! TextAreaRow
        
        do{
            try Realm().write {
                
                if let name = nameText.value{
                    selfAnalysis.name = name
                }else{
                    showAlert(vc: self, message: "タイトルを入力してください", useCancel: false, defalutActionText: "OK")
                    return
                }
                
                if let content = contentText.value{
                    selfAnalysis.content = content
                    realm.add(selfAnalysis,update: true)
                    showAlert(vc: self, message: "保存しました", useCancel: false, defalutActionText: "OK", onPushOK: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    showAlert(vc: self, message: "内容を入力してください", useCancel: false, defalutActionText: "OK")
                }
            }
        }catch{
            showAlert(vc: self, message: "エラーが発生しました", useCancel: false, defalutActionText: "OK")
        }
        
    }
    

}
