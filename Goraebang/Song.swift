//
//  Song.swift
//  Goraebang
//
//  Created by Sohn on 8/15/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

//import Foundation
import UIKit
import SwiftyJSON

class Song{
    var id:Int!
    var title:String!
    var artist:String!
    var genre1:String!
    var genre2:String!
    var highKey:String!
    var lowKey:String!
    var lyrics:String!
    var runtime:String!
    var song_tjnum:String!
    var albumWebView:UIWebView!
    
    init() {
        self.id = nil
        self.title = nil
        self.artist = nil
        self.genre1 = nil
        self.highKey = nil
        self.lowKey = nil
        self.lyrics = nil
        self.runtime = nil
        self.song_tjnum = nil
        self.albumWebView = UIWebView()
    }
    
    func set(json: JSON, row: Int){
        self.id = json[row]["id"].int
        self.title = json[row]["title"].string
        self.artist = "Unknown Artist"
        self.genre1 = json[row]["genre1"].string
        self.genre2 = json[row]["genre2"].string
        self.highKey = json[row]["highKey"].string
        self.lowKey = json[row]["lowKey"].string
        self.lyrics = json[row]["lyrics"].string
        self.runtime = json[row]["runtime"].string
        self.song_tjnum = json[row]["song_tjnum"].string
        self.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: json[row]["jacket"].string!)!))
    }
}
