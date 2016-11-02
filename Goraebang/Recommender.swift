//
//  Recommender.swift
//  Goraebang
//
//  Created by Sohn on 31/10/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class Recommender{
    
    var userInfo:UserInfoGetter!
    var goraebang_url:String!
    
    var recommendedSong:JSON!
    
    init(){
        userInfo = UserInfoGetter()
        goraebang_url = GlobalSetting.getGoraebangURL()
    }
    
    func getSongRecommendation(){
        let post:NSString = "id=\(userInfo.myId)"
        let url:NSURL = NSURL(string : "\(goraebang_url)/json/recom")!
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        
        do {
            let recommendJsonData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            
            recommendedSong = JSON(data: recommendJsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}
