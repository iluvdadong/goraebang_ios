//
//  UserInfoSetter.swift
//  Goraebang
//
//  Created by Sohn on 31/10/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class UserInfoSetter{
    
    var filemgr:NSFileManager!
    var documentPath:NSURL!
    var emailPath:String!
    var passwordPath:String!
    var tokenPath:String!
    var myIdPath:String!
    var myListIdPath:String!
    
    init(){
        filemgr = NSFileManager.defaultManager()
        documentPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        emailPath = documentPath.URLByAppendingPathComponent("email.txt")!.path!
        passwordPath = documentPath.URLByAppendingPathComponent("password.txt")!.path!
        tokenPath = documentPath.URLByAppendingPathComponent("token.txt")!.path!
        myIdPath = documentPath.URLByAppendingPathComponent("id.txt")!.path!
        myListIdPath = documentPath.URLByAppendingPathComponent("myListId.txt")!.path!
    }
    
    func writeEmail(email: String){
        if filemgr.fileExistsAtPath(emailPath){
            do{
                try filemgr.removeItemAtPath(emailPath)
            } catch let error as NSError {
                print("Error = \(error.debugDescription)")
            }
            filemgr.createFileAtPath(emailPath, contents: nil, attributes: nil)
        } else {
            filemgr.createFileAtPath(emailPath, contents: nil, attributes: nil)
        }
        
        if let file: NSFileHandle? = NSFileHandle(forReadingAtPath: emailPath){
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
    
    
}
