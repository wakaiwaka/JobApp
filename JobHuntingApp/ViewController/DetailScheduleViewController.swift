//
//  DetailScheduleViewController.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/15.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CSS3ColorsSwift

class DetailScheduleViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        settings.style.buttonBarItemLeftRightMargin = 10
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor = UIColor.lightSkyBlue
        settings.style.selectedBarBackgroundColor = UIColor.lightSkyBlue
        settings.style.selectedBarHeight = 3
        super.viewDidLoad()
        
    }

}
