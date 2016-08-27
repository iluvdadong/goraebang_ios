//
//  loginVC.swift
//  Goraebang
//
//  Created by Sohn on 7/30/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let goraebang_url = globalSetting.getGoraebangURL()
    override func viewDidLoad() {
        super.viewDidLoad()
        // txtPassword.delegate = self.txtPassword.delegate
        // Do any additional setup after loading the view.
    }
    
    // MARK: Logout 버튼 클릭 후 첫 화면으로 돌아오기 위한 코드
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    // MARK: Email 입력후 Return 키 누를 시
    @IBAction func usernameReturn(sender: AnyObject) {
        sender.resignFirstResponder()
        txtPassword.becomeFirstResponder()
    }
    
    // MARK: Password 입력 후 Login 버튼을 누르지 않고 Return 키 눌렀을 때 로그인 하도록
    @IBAction func passwordReturn(sender: AnyObject) {
        // 로그인 버튼 눌렀을 때와 동일하게 로그인 검사
        sender.resignFirstResponder()
        
        let username:NSString = txtUserEmail.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("goto_main", sender: self)
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        // 로그인 검사
        //        self.performSegueWithIdentifier("goto_main", sender: self)
        let username:NSString = txtUserEmail.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        
        let post:NSString = "user[email]=\(username)&user[password]=\(password)"
        
        NSLog("PostData: %@", post)
        
        let url:NSURL = NSURL(string: "\(goraebang_url)/json/login")!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
//        let postLength:NSString = String(postData.length)
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        print(request)
        
        let mySession = NSURLSession.sharedSession()
        
        // NSURLDataSessionTask Retrun 한다
        let task = mySession.dataTaskWithRequest(request){
            (let data, let response, let error) in
            
            guard let _:NSData = data, let _: NSURLResponse = response where error == nil else{
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
        }
        
        task.resume()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        // 로그인 검사 후 다음 segue
        self.performSegueWithIdentifier("goto_main", sender: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtUserEmail.endEditing(true)
        txtPassword.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
