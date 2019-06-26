//
//  SelfAnalysis.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/19.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import Foundation
import RealmSwift

class SelfAnalysis: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = ""
    @objc dynamic var content:String = ""
    
    override static func primaryKey() -> String{
        return "id"
    }
}
