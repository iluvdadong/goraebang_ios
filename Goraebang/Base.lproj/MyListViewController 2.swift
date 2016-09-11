//
//  MyListViewController.swift
//  Goraebang
//
//  Created by Sohn on 9/10/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyListViewController: UIViewController {

    
    @IBOutlet weak var preferenceButton: UIButton!
    @IBOutlet weak var myListButton: UIButton!
    @IBOutlet weak var blackListButton: UIButton!
    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var myListContainer: UIView!
    var userInfo:UserInfoGetter!
    var selectLine:UILabel!
    
    @IBAction func preferenceAction(sender: AnyObject) {
        myListContainer.hidden = true          
        selectLine.frame = CGRect(x: view.bounds.width*0, y: 147, width: view.bounds.width*0.3+2.5, height: 2)
    }
    
    
    @IBAction func myListAction(sender: AnyObject) {
        myListContainer.hidden = false
        selectLine.frame = CGRect(x: view.bounds.width*0.3+2.9, y: 147, width: view.bounds.width*0.4+2.5, height: 2)
    }
    
    
    @IBAction func blackListAction(sender: AnyObject) {
        myListContainer.hidden = true
        selectLine.frame = CGRect(x: view.bounds.width*0.7+3.8, y: 147, width: view.bounds.width*0.3, height: 2)
    }
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLine = UILabel()
        selectLine.frame = CGRect(x: view.bounds.width*0.3+2.9, y: 147, width: view.bounds.width*0.4+2.5, height: 2)
        selectLine.backgroundColor = UIColor.redColor()
        headerContainer.addSubview(selectLine)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
