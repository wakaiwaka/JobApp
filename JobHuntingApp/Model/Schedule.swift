//
//  Schedule.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/11.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import Foundation
import RealmSwift

class Schedule: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var plan:String = ""
    @objc dynamic var date:Date!
    @objc dynamic var place:String = ""
    @objc dynamic var belongings:String = ""
    @objc dynamic var dateString:String = ""
    
    override static func primaryKey() ->String?{
        return "id"
    }
}
