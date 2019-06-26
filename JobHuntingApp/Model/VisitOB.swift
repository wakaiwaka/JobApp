//
//  VisitOB.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/19.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import Foundation
import RealmSwift

class VisitOB: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var companyName:String = ""
    @objc dynamic var humanName:String = ""
    @objc dynamic var department:String = ""
    @objc dynamic var businessContents:String = ""
    @objc dynamic var question:String = ""
    @objc dynamic var answer:String = ""
    @objc dynamic var impressions:String = ""
    
    override static func primaryKey() -> String{
        return "id"
    }
}
