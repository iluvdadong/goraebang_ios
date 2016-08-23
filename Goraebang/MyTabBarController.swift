//
//  MyTabBarController.swift
//  Goraebang
//
//  Created by Sohn on 7/23/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit


class MyTabBarController: UITabBarController {

    @IBOutlet weak var myTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTabBar.tintColor = UIColor.redColor()
        myTabBar.barTintColor = UIColor.blackColor()

        // Do any additional setup after loading the view.
    }
    
    func changeIndex(num: Int){
        self.selectedIndex = num
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
