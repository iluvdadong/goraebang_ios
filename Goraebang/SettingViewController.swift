//
//  SettingViewController.swift
//  Goraebang
//
//  Created by Sohn on 9/11/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logout(sender: AnyObject) {
        let filemgr = NSFileManager.defaultManager()
        
        let documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        
        //        let emailPath = dataPath.URLByAppendingPathComponent("email.txt")
        //        let passwordPath = dataPath.URLByAppendingPathComponent("password.txt")
        let tokenPath = documentPath.URLByAppendingPathComponent("token.txt")
        
        if filemgr.fileExistsAtPath(tokenPath!.path!){
            do{
                try filemgr.removeItemAtPath(tokenPath!.path!)
            } catch let error as NSError{
                print("Error = \(error.debugDescription)")
            }
        } else {
            print("Token is already not exists")
        }
        
        self.performSegueWithIdentifier("unwindToLoginView", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
