//
//  MyListDetailViewController.swift
//  Goraebang
//
//  Created by Sohn on 8/7/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class MyListDetailViewController: UIViewController {
    
    // Configure: Hide bottom bar on push
    
    // 필요한 정보
    // 노래 제목, 가수, 가사, 발매일 등
    @IBOutlet weak var songTitleLabel: UINavigationItem! // title
    
    // 넘어오기전에 받는 정보
    var artist: String! // none
    var lyrics: String! // lyrics
    var genre1: String! // ganre1
    var genre2: String! // ganre2
    var runtime: String! // runtime
    var song_tjnum:String! // song_tjnum
    var lowKey: String! // lowkey
    var highKey: String! // highkey
    var albumWebView: UIWebView!
    
    // 받은 정보로 View, Label 생성
    
    // albumWebView에 사용될 변수
    var albumSize: CGFloat!
    var albumStartingXPoint: CGFloat!
    var albumStartingYPoint: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        setValue(view.bounds.width)
        makeAlbumWebView()
        // Do any additional setup after loading the view.
    }

    
    // 이름 바꾸자
    func setValue(phoneSize:CGFloat){
        if(phoneSize == 320){ // 4inch
            albumSize = 150.0
            albumStartingXPoint = (phoneSize/2 - albumSize)/2
            albumStartingYPoint = 65 + albumStartingXPoint
        } else if(phoneSize == 375){ // 4.7inch
            albumSize = 150.0
            albumStartingXPoint = (phoneSize/2 - albumSize)/2
            albumStartingYPoint = 65 + albumStartingXPoint
        } else{ // 5.5inch
            albumSize = 150.0
            albumStartingXPoint = (phoneSize/2 - albumSize)/2
            albumStartingYPoint = 65 + albumStartingXPoint
        }
    }
    
    func makeAlbumWebView(){
        albumWebView.frame = CGRect(x: albumStartingXPoint, y: albumStartingYPoint, width: albumSize, height: albumSize)
        albumWebView.userInteractionEnabled = false
        albumWebView.scalesPageToFit = true
        super.view.addSubview(albumWebView)
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
