//
//  Song.swift
//  Goraebang
//
//  Created by Sohn on 8/15/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

//import Foundation
import UIKit


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
    
    // MARK: prepare detail view
    // type 0: Top100 Chart, type 1: MyList, type 2: Search, Type 3: Main Page
    func set(json: JSON, row: Int, type: Int){
        if(type == 2){ // SearchResult인 경우
            self.id = json["title"][row]["id"].int
            self.title = json["title"][row]["title"].string
            self.artist = json["title"][row]["artist_name"].string
            self.genre1 = json["title"][row]["genre1"].string
            self.genre2 = json["title"][row]["genre2"].string
            self.highKey = json["title"][row]["highKey"].string
            self.lowKey = json["title"][row]["lowKey"].string
            self.lyrics = json["title"][row]["lyrics"].string
            self.runtime = json["title"][row]["runtime"].string
            self.song_tjnum = json["title"][row]["song_tjnum"].string
            self.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: json["title"][row]["jacket"].string!)!))
        }
        else if(type == 3){ // main page
//            print("Hello")
            self.id = json[row]["id"].int
            self.title = json[row]["title"].string
            self.artist = json[row]["artist_name"].string
            self.genre1 = json[row]["genre1"].string
            self.genre2 = json[row]["genre2"].string
            self.highKey = json[row]["highKey"].string
            self.lowKey = json[row]["lowKey"].string
            self.lyrics = json[row]["lyrics"].string
            self.runtime = json[row]["runtime"].string
            self.song_tjnum = json[row]["song_tjnum"].string
            if(json[row]["jacket_small"] != nil){
                self.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: json[row]["jacket_small"].string!)!))
            }
            
        } else if (type == 0) {
            self.id = json[row]["id"].int
            self.title = json[row]["title"].string
            self.artist = json[row]["artist_name"].string
            self.genre1 = json[row]["genre1"].string
            self.genre2 = json[row]["genre2"].string
            self.highKey = json[row]["highKey"].string
            self.lowKey = json[row]["lowKey"].string
            self.lyrics = json[row]["lyrics"].string
            self.runtime = json[row]["runtime"].string
            self.song_tjnum = json[row]["song_tjnum"].string
            self.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: json[row]["jacket"].string!)!))
        }
        else { // type 1 from mylist
            print(json)
            self.id = json["song"][row]["id"].int
            self.title = json["song"][row]["title"].string
            self.artist = "Unknown Artist"
            self.genre1 = json["song"][row]["genre1"].string
            self.genre2 = json["song"][row]["genre2"].string
            self.highKey = json["song"][row]["highKey"].string
            self.lowKey = json["song"][row]["lowKey"].string
            self.lyrics = json["song"][row]["lyrics"].string
            self.runtime = json["song"][row]["runtime"].string
            self.song_tjnum = json["song"][row]["song_tjnum"].string
            if(json["song"][row]["jacket"] != nil){
                self.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: json["song"][row]["jacket"].string!)!))
            }
            
            
        }
        
    }
}
