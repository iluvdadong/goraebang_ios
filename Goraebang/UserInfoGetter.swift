//
//  UserInfoGetter.swift
//  Goraebang
//
//  Created by Sohn on 9/10/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import Foundation

class UserInfoGetter{
    var myListId:Int!
    var myId:Int!
    var myName:String!
    var token:String!
    
    var documentPath:NSURL!
    var myIdPath:NSURL!
    var myListIdPath:NSURL!
    var myTokenPath:NSURL!
    var myNamePath:NSURL!
    
    let filemgr = NSFileManager.defaultManager()
    
    init() {
        documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        myIdPath = documentPath.URLByAppendingPathComponent("id.txt")
        myListIdPath = documentPath.URLByAppendingPathComponent("myListId.txt")
        myTokenPath = documentPath.URLByAppendingPathComponent("token.txt")
        myNamePath = documentPath.URLByAppendingPathComponent("name.txt")
        
        if let file:NSFileHandle? = NSFileHandle(forUpdatingAtPath: myListIdPath.path!){
            if file == nil{
                print("my Id File open failed")
            } else {
                file?.seekToFileOffset(0)
                let databuffer = file?.readDataToEndOfFile()
                let databufferStr = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)
                // 여기서 클래스의 멤버 변수에 아이디값 설정할 수 있다
                print("my id = \(databufferStr!)")
                myListId = Int(databufferStr! as String)
                file?.closeFile()
            }
        }
        
        if let file:NSFileHandle? = NSFileHandle(forUpdatingAtPath: myIdPath.path!){
            if file == nil{
                print("my Id File open failed")
            } else {
                file?.seekToFileOffset(0)
                let databuffer = file?.readDataToEndOfFile()
                let databufferStr = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)
                // 여기서 클래스의 멤버 변수에 아이디값 설정할 수 있다
                print("my id = \(databufferStr!)")
                myId = Int(databufferStr! as String)
                file?.closeFile()
            }
        }
        
        if let file:NSFileHandle? = NSFileHandle(forUpdatingAtPath: myTokenPath.path!){
            if file == nil{
                print("my Id File open failed")
            } else {
                file?.seekToFileOffset(0)
                let databuffer = file?.readDataToEndOfFile()
                let databufferStr = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)
                // 여기서 클래스의 멤버 변수에 아이디값 설정할 수 있다
//                print("my id = \(databufferStr!)")
                token = databufferStr! as String
                file?.closeFile()
            }
        }
    }
    
    // myName 파라미터로 document폴더에 name.txt 저장한다.
    // 개인정보 수정에서 수정 했을 때 setName 필요하다.
    // 로그아웃 하는 경우 name.txt 를 삭제 할껀데
    // 다시 로그인 한 경우 name.txt가 삭제 되어 있으므로 myList에서 getName을 실패 할 것이다.
    // getName 실패한 경우 서버에서 이름을 불러와 setName하고 다시 getName이 필요하다..
    // 로그인 할때 setName 필요..
    
    func setName(myName: String!){
        if filemgr.fileExistsAtPath(myNamePath!.path!){
            do{
                try filemgr.removeItemAtPath(myNamePath!.path!)
            } catch let error as NSError{
                print("Error = \(error.debugDescription)")
            }
            filemgr.createFileAtPath(myNamePath!.path!, contents: nil, attributes: nil)
        } else {
            filemgr.createFileAtPath(myNamePath!.path!, contents: nil, attributes: nil)
        }
        
        if let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: myNamePath!.path!){
            if file == nil {
                print("File open failed")
            } else {
                let data = (myName as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                file?.seekToFileOffset(0)
                file?.writeData(data!)
                file?.closeFile()
            }
        }
    }
    
    func getName() -> String{
        // 휴대폰에 myNamePath가 저장되있으면 이름을 거기서 불러온다.
        if filemgr.fileExistsAtPath(myNamePath!.path!){
            print("파일 존재 확인")
            if let file:NSFileHandle? = NSFileHandle(forUpdatingAtPath: myNamePath.path!){
                if file == nil{
                    print("my Id File open failed")
                } else {
                    file?.seekToFileOffset(0)
                    let databuffer = file?.readDataToEndOfFile()
                    let databufferStr = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)
                    myName = databufferStr! as String
                    file?.closeFile()
                }
            }
            print("myName 확인 = \(myName)")
            return myName
        } else{
            print("myName 존재하지않ㄴ")
            return ""
        }
        
        
    }
    
    func deleteName(){
        
    }
}
