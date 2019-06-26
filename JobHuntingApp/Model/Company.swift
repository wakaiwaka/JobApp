//
//  Company.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import Foundation
import RealmSwift

class Company: Object{
    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = ""
    @objc dynamic var industoryId = 0
    @objc dynamic var strength:String = ""
    @objc dynamic var weakness:String = ""
    @objc dynamic var managementPhi:String = ""
    @objc dynamic var location:String = ""
    @objc dynamic var businessContents:String = ""
    @objc dynamic var interestPoint:String = ""
    @objc dynamic var selfPR:String = ""
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
}
