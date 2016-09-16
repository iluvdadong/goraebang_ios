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
    var documentPath:NSURL!
    var myIdPath:NSURL!
    var myListIdPath:NSURL!
    
    init() {
        documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        myIdPath = documentPath.URLByAppendingPathComponent("id.txt")
        myListIdPath = documentPath.URLByAppendingPathComponent("myListId.txt")
        
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
    }
}