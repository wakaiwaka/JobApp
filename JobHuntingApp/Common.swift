//
//  Common.swift
//  JobHuntingApp
//
//  Created by 若原昌史 on 2019/01/14.
//  Copyright © 2019 若原昌史. All rights reserved.
//

import Foundation
import UIKit

func showAlert(vc:UIViewController,message:String,useCancel:Bool,defalutActionText:String,onPushOK: @escaping()->Void){
    let alertController:UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let defaultAction:UIAlertAction = UIAlertAction(title: defalutActionText, style: .default) { (void) in
        onPushOK()
    }
    if useCancel{
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    }
    alertController.addAction(defaultAction)
    vc.present(alertController,animated: true,completion: nil)
}

func showAlert(vc:UIViewController,message:String,useCancel:Bool,defalutActionText:String){
    let alertController:UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: defalutActionText, style: .default, handler: nil)
    if useCancel{
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    }
    alertController.addAction(defaultAction)
    vc.present(alertController,animated: true,completion: nil)
}

