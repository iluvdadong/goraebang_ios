//
//  Communicator.swift
//  Goraebang
//
//  Created by Sohn on 08/10/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class Communicator {
    
    init(){
        
    }
    
    func communicateWithRequest(post: NSString, url: NSURL, method: String){
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        request.HTTPBody = postData
//        var json:JSON!
        
        let result = try NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if let data = data where error == nil{
//                json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            } else {
                print("error=\(error.debugDescription)")
            }
        }
        result.resume()
    }
}
