//
//  InternShip.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import Foundation
import RealmSwift

class InternShip: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = ""
    @objc dynamic var date:Date = Date()
    @objc dynamic var content:String = ""
    @objc dynamic var question:String = ""
    @objc dynamic var answer:String = ""
    @objc dynamic var reflect:String = ""
    
    override static func primaryKey() -> String{
        return "id"
    }
}
