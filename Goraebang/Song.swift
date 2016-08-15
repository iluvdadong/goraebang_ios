//
//  Song.swift
//  Goraebang
//
//  Created by Sohn on 8/15/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import Foundation
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
    // JSON 파일과 행 번호 를 받아서 init
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
        
        //        detailViewController.songId = myListReadableJSON[row!]["id"].int
        //        detailViewController.songTitleLabel.title = myListReadableJSON[row!]["title"].string
        //        detailViewController.songTitle = myListReadableJSON[row!]["title"].string
        //        detailViewController.artist = "Unknown Artist"
        //        detailViewController.genre1 = myListReadableJSON[row!]["genre1"].string
        //        detailViewController.genre2 = myListReadableJSON[row!]["genre2"].string
        //        detailViewController.highKey = myListReadableJSON[row!]["highkey"].string
        //        detailViewController.lowKey = myListReadableJSON[row!]["lowkey"].string
        //        detailViewController.lyrics = myListReadableJSON[row!]["lyrics"].string
        //        detailViewController.runtime = myListReadableJSON[row!]["runtime"].string
        //        detailViewController.song_tjnum = myListReadableJSON[row!]["song_tjnum"].string
        //        let albumImageWebView:UIWebView = UIWebView()
        //        albumImageWebView.loadRequest(NSURLRequest(URL: NSURL(string: myListReadableJSON[row!]["jacket"].string!)!))
        //        detailViewController.albumWebView = albumImageWebView
    }
}
