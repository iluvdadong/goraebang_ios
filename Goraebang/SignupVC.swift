//
//  SignupVC.swift
//  Goraebang
//
//  Created by Sohn on 7/30/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
  
    
    // MARK: Sign up 터치
    @IBAction func signupTapped(sender: AnyObject) {
        let username:NSString = txtUserEmail.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        let confirm_password:NSString = txtConfirmPassword.text! as NSString
        
        if(username.isEqualToString("") || password.isEqualToString("")){
            // MARK: Alert View 생성
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if ( !password.isEqual(confirm_password)){
            
            // MARK: 비밀번호와 비밀번호 확인이 일치하지 않을 때 경고창
            // UIAlertController로 교체 해야될것 같다.
            let alertView:UIAlertView = UIAlertView()
            
            alertView.title = "Sign up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            // MARK: 회원가입 성공
            let post:NSString = "user[email]=\(username)&user[name]=sohn&user[password]=\(password)&user[password_confirmation]=\(confirm_password)&user[gender]=0"
            
            NSLog("PostData: %@", post)
            
            let url:NSURL = NSURL(string: "http://web-api-upstream-yhk1038.c9users.io/json/regist")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String(postData.length)
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
//            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
//            request.setValue("application/x-www-0form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            print(request)
            
            //            var responseError: NSError?
            //            var response: NSURLResponse?
            
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
            
            // MARK: NSURLSession 사용
            //            var session = NSURLSession.sharedSession()
            //            var task = session.dataTaskWithRequest(request)
        }
        // MARK: End
    }
    
    
    @IBAction func gotoLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtUserEmail.endEditing(true)
        txtPassword.endEditing(true)
        txtConfirmPassword.endEditing(true)
    }
    
    @IBAction func emailReturn(sender: AnyObject) {
        sender.resignFirstResponder()
        txtPassword.becomeFirstResponder()
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
