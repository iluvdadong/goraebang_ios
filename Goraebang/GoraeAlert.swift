//
//  GoraeAlert.swift
//  Goraebang
//
//  Created by Sohn on 11/10/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class GoraeAlert{
    var alertController:UIAlertController!
    
    init(message: String = "No message error", title: String = ""){
        alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    }
    
    func dissapear(){
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.alertController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}
