//
//  SettingViewController.swift
//  Goraebang
//
//  Created by Sohn on 9/11/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    var userInfo = UserInfoGetter()
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logout(sender: AnyObject) {
        let filemgr = NSFileManager.defaultManager()
        
        let documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        
        let imagePath = documentPath.URLByAppendingPathComponent("profile.png")
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
        
        if filemgr.fileExistsAtPath(imagePath!.path!){
            do{
                try filemgr.removeItemAtPath(imagePath!.path!)
            } catch let error as NSError{
                print("Error = \(error.debugDescription)")
            }
        } else {
            
        }
        
        self.performSegueWithIdentifier("unwindToLoginView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ModifyInfo" {
            let myInfoViewController = segue.destinationViewController as! MyInfoViewController
            
            var isEnd = 0
            let post:NSString = "mytoken=\(userInfo.token)"
            let url:NSURL = NSURL(string: "\(goraebang_url)/json/my_account")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
            var accountResult:JSON!
            
            let result = try NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error in
                if let data = data where error == nil{
                    accountResult = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    
                    if(accountResult["result"].string! == "SUCCESS"){
//                        print(accountResult)
                        myInfoViewController.email = accountResult["email"].string!
                        if accountResult["name"].string! != "" {
                            myInfoViewController.name = accountResult["name"].string!
                        }
                        myInfoViewController.gender = accountResult["gender"].int!
                    } else{
                        print("My account fail")
                        
                    }
                } else {
                    print("error=\(error.debugDescription)")
                }
            }
            result.resume()
            
            /* accountResult 의 JSON 데이터
             gender : 0 (아무것도 없을 때)
             result : "SUCCESS"
             mylist_id : 207
             profile_img_origin : url
             profile_img_400 : url
             email : "me@82.beta"
             name : "betaUser_82"
 
             */
        }
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
