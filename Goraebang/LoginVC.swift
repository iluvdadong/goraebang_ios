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
    
    var filemgr:NSFileManager!
    var dataPath:NSURL!
    var documentPath:NSURL!
    var emailPath:NSURL!
    var passwordPath:NSURL!
    var tokenPath:NSURL!
    var myIdPath:NSURL!
    var myListIdPath:NSURL!
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filemgr = NSFileManager.defaultManager()
        
        documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        
//        dataPath = documentPath.URLByAppendingPathComponent("data")
        emailPath = documentPath.URLByAppendingPathComponent("email.txt")
        passwordPath = documentPath.URLByAppendingPathComponent("password.txt")
        tokenPath = documentPath.URLByAppendingPathComponent("token.txt")
        myIdPath = documentPath.URLByAppendingPathComponent("id.txt")
        myListIdPath = documentPath.URLByAppendingPathComponent("myListId.txt")
        
        txtUserEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        txtUserEmail.keyboardAppearance = UIKeyboardAppearance.Dark
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        txtPassword.keyboardAppearance = UIKeyboardAppearance.Dark
        
        //        let filemgr = NSFileManager.defaultManager()
        //
        //        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        //        let dataPath = documentsPath.URLByAppendingPathComponent("data")
        //        let emailPath = dataPath.URLByAppendingPathComponent("email.txt")
        
        
        // email Path 삭제
        //        do {
        //            try filemgr.removeItemAtPath(emailPath.path!)
        //        } catch let error as NSError{
        //            print("Fail")
        //        }
        
        // dataPath 생성
        //        do {
        //            try NSFileManager.defaultManager().createDirectoryAtPath(dataPath.path!, withIntermediateDirectories: true, attributes: nil)
        //        } catch let error as NSError {
        //            NSLog("Unable to create directory \(error.debugDescription)")
        //        }
        
        // Current Directory를 dataPath로 변경
        //        if filemgr.changeCurrentDirectoryPath(dataPath.path!){
        //            print(filemgr.currentDirectoryPath)
        //        }
        //        else{
        //            print("fail")
        //        }
        //
        //        var filelist:[String]?
        //        filelist = nil
        
        // dataPath의 내용을 출력
        //        do{
        //            filelist = try filemgr.contentsOfDirectoryAtPath(dataPath.path!)
        //        } catch let error as NSError {
        //            NSLog("Error = \(error.debugDescription)")
        //        }
        //
        //        if let filelist = filelist{
        //            for filename in filelist {
        //                print(filename)
        //            }
        //        }
        // 파일 존재 확인
        //        if filemgr.fileExistsAtPath(dataPath.URLByAppendingPathComponent("email.txt").path!){
        //            print(dataPath.URLByAppendingPathComponent("email.txt").path!)
        //            print("File exists")
        //            print("email 파일 존재한다.")
        //        } else{
        //            print(dataPath.URLByAppendingPathComponent("email.txt").path!)
        //            print("File not found")
        //            print("Creat File")
        //            filemgr.createFileAtPath(emailPath.path!, contents: nil, attributes: nil)
        //        }
        //
        //        if filemgr.isWritableFileAtPath(emailPath.path!){
        //            print("email.txt file is writeable")
        //        } else{
        //            print("File is read-only")
        //        }
        
        //        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: emailPath.path!){
        //            if file == nil {
        //                print("File open failed")
        //            } else {
        //                let data = ("sohn126@naver.com" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        //                file?.seekToFileOffset(0)
        //                file?.writeData(data!)
        //                file?.closeFile()
        //                print("file write complete")
        //            }
        //        }
        //
        //        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: emailPath.path!){
        //            if file == nil{
        //                print("email.txt file open failed")
        //            } else {
        //                print("email.txt read start")
        //                file?.seekToFileOffset(0)
        //                let databuffer = file?.readDataToEndOfFile()
        //                let databufferstr = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)
        //                print(databufferstr!)
        //                file?.closeFile()
        //            }
        //
        //        }
    }
    
    override func viewDidAppear(animated: Bool) {
        txtPassword.text = ""
         let filemgr = NSFileManager.defaultManager()
        let documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        
        let emailPath = documentPath.URLByAppendingPathComponent("email.txt")
        
        
        let tokenPath = documentPath.URLByAppendingPathComponent("token.txt")
        
        // MARK: tokenPath 파일이 있는 경우는 바로 로그인한다.
        // MARK: 현재 token로그인 함수에서 중복으로 검사중이다(수정필요)*********************
        if filemgr.fileExistsAtPath(tokenPath!.path!){
            tokenLogin(tokenPath!.path!, emailPath: emailPath!.path!)
        }
        
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
        let url:NSURL = NSURL(string: "\(goraebang_url)/json/login")!
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        var loginResultJSON:JSON!
        var isLogin = false
        var isEnd = false
        
        let loginResult = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if let data = data where error == nil{
                loginResultJSON = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error:nil)
                print(loginResultJSON)
                if(loginResultJSON["result"].string! == "SUCCESS"){
                    let filemgr = NSFileManager.defaultManager()
                    
                    let documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
                    
                    let emailPath = documentPath.URLByAppendingPathComponent("email.txt")
                    let passwordPath = documentPath.URLByAppendingPathComponent("password.txt")
                    let tokenPath = documentPath.URLByAppendingPathComponent("token.txt")
                    // 로그인 성공하면 기존 이메일인지 확인 후 정보 업데이트하고
                    // 토큰 받아온다.txtPassword.text = ""
                    //                    self.dismissViewControllerAnimated(true, completion: nil)
                    // 로그인 검사 후 다음 segue
                    
                    // 첫번째, emailPath가 존재하는 지 확인
                    if filemgr.fileExistsAtPath(emailPath!.path!){
                        // 존재한다면 지금 로그인 하는 이메일과 같은지 확인한다.
                        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: emailPath!.path!){
                            if file == nil{ // 이메일 파일이 빈 경우
                                print("email.txt file open failed")
                            } else {
                                print("email.txt read start")
                                file?.seekToFileOffset(0)
                                let databuffer = file?.readDataToEndOfFile()
                                let databufferstr = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)
                                print("이메일 파일이 존재합니다. 비교하기 위해서 read")
                                print(databufferstr!)
                                
                                if(databufferstr! != self.txtUserEmail.text!){ // 지금 로그인하는 유저정보와 다른 경우 전체 업데이트 필요
                                    print("로그인 하려는 유저의 정보가 다릅니다. 정보 업데이트 필요.")
                                    
                                    // 이메일 파일 존재하는 경우 삭제하고 다시 생성
                                    self.writeEmail(self.txtUserEmail.text!, emailPath: emailPath!.path!)
                                    
                                    // 패스워드 파일 존재하는 경우 삭제하고 다시 생성
                                    self.writePassword(self.txtPassword.text!, passwordPath: passwordPath!.path!)
                                    
                                    // 토큰 파일 존재하는 경우 삭제하고 다시 생성
                                    self.writeToken(loginResultJSON["mytoken"].string!, tokenPath: tokenPath!.path!)
                                    isLogin = true
                                    isEnd = true
                                    
                                    
                                } else {
                                    print("로그인 하는 유저가 기존과 같습니다. 토큰 업데이트 필요")
                                    self.writeToken(loginResultJSON["mytoken"].string!, tokenPath: tokenPath!.path!)
                                    isLogin = true
                                    isEnd = true
                                }
                                file?.closeFile()
                            }
                        }
                    } else { // emailPath 가 없으면 그냥 생성하면된다.
                        print("아무 정보도 없는 경우 생성")
                        //                        filemgr.createFileAtPath(emailPath.path!, contents: nil, attributes: nil)
                        self.writeEmail(self.txtUserEmail.text!, emailPath: emailPath!.path!)
                        self.writePassword(self.txtUserEmail.text!, passwordPath: passwordPath!.path!)
                        self.writeToken(loginResultJSON["mytoken"].string!, tokenPath: tokenPath!.path!)
                        
                        self.txtUserEmail.text = ""
                        self.txtPassword.text = ""
                        isLogin = true
                        isEnd = true
                    }
                    
                } else {
                    // 실패한 경우 적절한 AlertView
                    isLogin = false
                    isEnd = true
                }
            } else {
                print("error = \(error.debugDescription)")
            }
        }
        
        loginResult.resume()
        
        while(true){
            if(isEnd == true) {
                break
            }
        }
        
        // 여기서 어떻게 로그인 할지...
        // 로그인 됬는지 어떻게 확인
        if(isLogin == true){
            self.writeMyId(loginResultJSON["id"].int!, myIdPath: myIdPath.path!)
            self.writeMyListId(loginResultJSON["mylist_id"].int!, listPath: myListIdPath.path!)
            self.performSegueWithIdentifier("goto_main", sender: self)
        }
        
        // 여기서 토큰이 생성된 경우 토큰으로 다시 로그인한다.
//        let documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        
        //        let emailPath = documentPath.URLByAppendingPathComponent("email.txt")
        //        let passwordPath = documentPath.URLByAppendingPathComponent("password.txt")
        //        let tokenPath = documentPath.URLByAppendingPathComponent("token.txt")
        //        tokenLogin(tokenPath.path!, emailPath: emailPath.path!)
        //        self.performSegueWithIdentifier("goto_main", sender: self)
        
        //*************************************************
        // 로그인 시에 토큰 받아오는 코드 추가 2016.09.07
        // 만약 기존에 저장된 아이디와 다르다면 이메일과 패스워드 정보까지 업데이트
        
        //************************************************
    }
    
    func writeEmail(email: String, emailPath: String){
        print("Email 생성 시작")
        let filemgr = NSFileManager.defaultManager()
        
        if filemgr.fileExistsAtPath(emailPath){
            do{
                try filemgr.removeItemAtPath(emailPath)
            } catch let error as NSError{
                print("Error = \(error.debugDescription)")
            }
            filemgr.createFileAtPath(emailPath, contents: nil, attributes: nil)
        } else {
            filemgr.createFileAtPath(emailPath, contents: nil, attributes: nil)
        }
        
        // 이메일 파일 작성
        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: emailPath){
            if file == nil {
                print("File open failed")
            } else {
                let data = (email as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                file?.seekToFileOffset(0)
                file?.writeData(data!)
                file?.closeFile()
            }
        }
    }
    
    func writePassword(password: String, passwordPath: String){
        print("Password 생성 시작")
        // 패스워드 파일 존재하는 경우 삭제하고 다시 생성
        let filemgr = NSFileManager.defaultManager()
        if filemgr.fileExistsAtPath(passwordPath){
            do{
                try filemgr.removeItemAtPath(passwordPath)
            } catch let error as NSError{
                print("Error = \(error.debugDescription)")
            }
            filemgr.createFileAtPath(passwordPath, contents: nil, attributes: nil)
            
        } else {
            filemgr.createFileAtPath(passwordPath, contents: nil, attributes: nil)
        }
        // 패스워드 파일 작성
        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: passwordPath){
            if file == nil {
                print("File open failed")
            } else {
                let data = (password as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                file?.seekToFileOffset(0)
                file?.writeData(data!)
                file?.closeFile()
            }
        }
    }
    
    func writeToken(token: String, tokenPath: String){
        print("Token 생성 시작")
        let filemgr = NSFileManager.defaultManager()
        
        if filemgr.fileExistsAtPath(tokenPath){
            do{
                try filemgr.removeItemAtPath(tokenPath)
            } catch let error as NSError{
                print("Error = \(error.debugDescription)")
            }
            filemgr.createFileAtPath(tokenPath, contents: nil, attributes: nil)
        } else {
            filemgr.createFileAtPath(tokenPath, contents: nil, attributes: nil)
        }
        
        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: tokenPath){
            if file == nil {
                print("File open failed")
            } else {
                let data = (token as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                file?.seekToFileOffset(0)
                file?.writeData(data!)
                file?.closeFile()
            }
        }
    }
    
    func writeMyListId(myListId: Int, listPath: String){
        print("My list id 생성")
        if(filemgr.fileExistsAtPath(listPath)){
            do{
                try filemgr.removeItemAtPath(listPath)
            } catch let error as NSError{
                print(error.debugDescription)
            }
            filemgr.createFileAtPath(listPath, contents: nil, attributes: nil)
        } else {
            filemgr.createFileAtPath(listPath, contents: nil, attributes: nil)
        }
        
        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: listPath){
            if file == nil {
                print("myListId.txt File open failed")
            } else {
                let data = (String(myListId) as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                file?.seekToFileOffset(0)
                file?.writeData(data!)
                file?.closeFile()
            }
        }
    }
    
    func writeMyId(id: Int, myIdPath: String){
        if(filemgr.fileExistsAtPath(myIdPath)){
            do{
                try filemgr.removeItemAtPath(myIdPath)
            } catch let error as NSError{
                print(error.debugDescription)
            }
            filemgr.createFileAtPath(myIdPath, contents: nil, attributes: nil)
        } else {
            filemgr.createFileAtPath(myIdPath, contents: nil, attributes: nil)
        }
        
        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: myIdPath){
            if file == nil {
                print("myListId.txt File open failed")
            } else {
                let data = (String(id) as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                file?.seekToFileOffset(0)
                file?.writeData(data!)
                file?.closeFile()
            }
        }
    }
    
    func tokenLogin(tokenPath: String, emailPath: String){
        print("tokenLogin 시작")
        let filemgr = NSFileManager.defaultManager()
        
        if filemgr.fileExistsAtPath(tokenPath){
            if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: tokenPath){
                if file == nil{
                    print("email.txt file open failed")
                } else {
                    file?.seekToFileOffset(0)
                    let databuffer = file?.readDataToEndOfFile()
                    let databufferstr = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)
                    let mytoken = String(databufferstr!)
                    file?.closeFile()
                    
                    let post:NSString = "user[mytoken]=\(mytoken)"
                    let url:NSURL = NSURL(string: "\(goraebang_url)/json/login")!
                    
                    let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                    let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "POST"
                    request.HTTPBody = postData
                    
                    var loginResultJSON:JSON!
                    
                    
                    let loginResult = try NSURLSession.sharedSession().dataTaskWithRequest(request){
                        data, response, error in
                        if let data = data where error == nil{
                            loginResultJSON = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error:nil)
                            
                            print(loginResultJSON["result"].string!)
                            if(loginResultJSON["result"].string! == "SUCCESS"){
                                self.writeMyId(loginResultJSON["id"].int!, myIdPath: self.myIdPath.path!)
                                self.writeMyListId(loginResultJSON["mylist_id"].int!, listPath: self.myListIdPath.path!)
//                                print("token 로그인 결과는 = \(loginResultJSON)")
                                self.performSegueWithIdentifier("goto_main", sender: self)
                            }
                            else {
                                // AlertView 로그인 실패 하고 토큰 삭제시켜야한다.*************
                                
                                // 실패 했을 때 어떻게 할지?
                                // token 으로 로그인 안되는 경우
                            }
                        } else {
                            print("error=\(error.debugDescription)")
                        }
                    }
                    loginResult.resume()
                }
                
            }
        } else{ // token 없는 경우 : 로그아웃 했거나 처음 앱 실행한 경우, 로그아웃인 경우 email만 입력해준다.
            if filemgr.fileExistsAtPath(emailPath){
                if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: emailPath){
                    if file == nil{
                        print("email.txt file open failed")
                    } else {
                        print("Here")
                        print("email.txt read start")
                        print("email path = \(emailPath)")
                        file?.seekToFileOffset(0)
                        let databuffer = file?.readDataToEndOfFile()
                        let databufferstr = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)
                        txtUserEmail.text = String(databufferstr!)
                        print(databufferstr!)
                        file?.closeFile()
                    }
                    
                }
            }
        }
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
