//
//  SignupVC.swift
//  Goraebang
//
//  Created by Sohn on 7/30/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit


/* MARK: 160919 오류
 처음 설치 후
 회원가입 해서 돌아왔을 때 로그인 안됌
 다시 켜서 로그인 하면 앱 꺼지고
 그다음 부터 자동로그인
 */

class SignupVC: UIViewController {
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        txtUserEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        txtUserEmail.keyboardAppearance = UIKeyboardAppearance.Dark
        txtPassword.keyboardAppearance = UIKeyboardAppearance.Dark
        txtConfirmPassword.keyboardAppearance = UIKeyboardAppearance.Dark
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
            
            let url:NSURL = NSURL(string: "\(goraebang_url)/json/regist")!
            
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
            // 새로운 코드
            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            
            do {
                // NSURLSession.DataTaskWithRequest 로 변경해야한다.
                let signUpJsonData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
                
                print(response)
                
                let signUpResult = JSON(data: signUpJsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
                print(signUpResult)
                if(signUpResult["result"].string! == "SUCCESS"){
                    
                    let filemgr = NSFileManager.defaultManager()
                    
                    let documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
                    
                    let dataPath = documentPath.URLByAppendingPathComponent("data")
                    let emailPath = dataPath!.URLByAppendingPathComponent("email.txt")
                    let passwordPath = dataPath!.URLByAppendingPathComponent("password.txt")
                    let tokenPath = dataPath!.URLByAppendingPathComponent("token.txt")
                    
                    if filemgr.fileExistsAtPath(emailPath!.path!){
                        // 이미 이메일 파일이 존재하는 경우 삭제
                        do{
                            try filemgr.removeItemAtPath(emailPath!.path!)
                        } catch let error as NSError{
                            print("Error = \(error.debugDescription)")
                        }
                        filemgr.createFileAtPath(emailPath!.path!, contents: nil, attributes: nil)
                        
                    } else { // 이메일 파일이 없는 경우, 생성하면서 파일 쓰기가 가능한지 확인**
                        filemgr.createFileAtPath(emailPath!.path!, contents: nil, attributes: nil)
                    }
                    
                    if filemgr.fileExistsAtPath(passwordPath!.path!){
                        do{
                            try filemgr.removeItemAtPath(passwordPath!.path!)
                        } catch let error as NSError{
                            print("Error = \(error.debugDescription)")
                        }
                        filemgr.createFileAtPath(passwordPath!.path!, contents: nil, attributes: nil)
                        // 이미 이메일 파일이 존재하는 경우 삭제
                    } else { // 이메일 파일이 없는 경우, 생성하면서 파일 쓰기가 가능한지 확인**
                        filemgr.createFileAtPath(passwordPath!.path!, contents: nil, attributes: nil)
                    }
                    
                    if filemgr.fileExistsAtPath(tokenPath!.path!){
                        do{
                            try filemgr.removeItemAtPath(tokenPath!.path!)
                        } catch let error as NSError{
                            print("Error = \(error.debugDescription)")
                        }
                        filemgr.createFileAtPath(tokenPath!.path!, contents: nil, attributes: nil)
                        
                        // 이미 이메일 파일이 존재하는 경우 삭제
                    } else { // 이메일 파일이 없는 경우, 생성하면서 파일 쓰기가 가능한지 확인**
                        filemgr.createFileAtPath(tokenPath!.path!, contents: nil, attributes: nil)
                    }
                    
                    
                    // 이메일 입력
                    if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: emailPath!.path!){
                        if file == nil {
                            print("File open failed")
                        } else {
                            let data = (txtUserEmail.text! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                            file?.seekToFileOffset(0)
                            file?.writeData(data!)
                            file?.closeFile()
                            //                            print("file write complete")
                        }
                    }
                    
                    if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: passwordPath!.path!){
                        if file == nil {
                            print("File open failed")
                        } else {
                            let data = (txtPassword.text! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                            file?.seekToFileOffset(0)
                            file?.writeData(data!)
                            file?.closeFile()
                            //                            print("file write complete")
                        }
                    }
                    
                    // 토큰 입력 추가
                    if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: tokenPath!.path!){
                        if file == nil {
                            print("File open failed")
                        } else {
                            let data = (signUpResult["mytoken"].string! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                            file?.seekToFileOffset(0)
                            file?.writeData(data!)
                            file?.closeFile()
                            //                            print("file write complete")
                        }
                    }
                    
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            // 기존 코드
            //            let mySession = NSURLSession.sharedSession()
            //
            //            // NSURLDataSessionTask Retrun 한다
            //            let task = mySession.dataTaskWithRequest(request){
            //                (let data, let response, let error) in
            //
            //                guard let _:NSData = data, let _: NSURLResponse = response where error == nil else{
            //                    print("error")
            //                    return
            //                }
            //
            //                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //                print("회원가입 메시지")
            //
            //                let json:JSON =
            //
            //                self.dismissViewControllerAnimated(true, completion: nil)
            //                self.performSegueWithIdentifier("goto_main", sender: self)
            //            }
            //
            //            task.resume()
            
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
