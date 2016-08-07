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
    var songTitle: String! // title
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
    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    
    // albumWebView에 사용될 변수
    var albumSize: CGFloat!
    var albumStartingXPoint: CGFloat!
    var albumStartingYPoint: CGFloat!
    
    // firstContainer 변수
    var FCFrameXPoint: CGFloat!
    var FCFrameYPoint: CGFloat!
    var FCFrameWidth: CGFloat!
    var FCFrameHeight: CGFloat!
    
    // Navigation Var 때문에 생기는 Top padding
    var fixedTopPadding: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        let phoneSize:CGFloat = view.bounds.width
        fixedTopPadding = 65.0
        
        setMyAlbum(phoneSize)
        setMyFirstContainer(phoneSize)
        
        makeAlbumWebView()
        makeFirstContainer()
        // Do any additional setup after loading the view.
    }
    
    func setMyAlbum(phoneSize:CGFloat){
        if(phoneSize == 320){ // 4inch
            albumSize = 150.0
            albumStartingXPoint = (phoneSize/2 - albumSize)/2
            albumStartingYPoint = fixedTopPadding + albumStartingXPoint
        } else if(phoneSize == 375){ // 4.7inch
            albumSize = 150.0
            albumStartingXPoint = (phoneSize/2 - albumSize)/2
            albumStartingYPoint = fixedTopPadding + albumStartingXPoint
        } else{ // 5.5inch
            albumSize = 150.0
            albumStartingXPoint = (phoneSize/2 - albumSize)/2
            albumStartingYPoint = fixedTopPadding + albumStartingXPoint
        }
    }
    
    func makeAlbumWebView(){
        albumWebView.frame = CGRect(x: albumStartingXPoint, y: albumStartingYPoint, width: albumSize, height: albumSize)
        albumWebView.userInteractionEnabled = false
        albumWebView.scalesPageToFit = true
        super.view.addSubview(albumWebView)
    }
    
    func setMyFirstContainer(phoneSize: CGFloat){
        FCFrameXPoint = phoneSize/2 + 10
        FCFrameYPoint = albumStartingXPoint + fixedTopPadding
        FCFrameWidth = phoneSize/2 - 20
        FCFrameHeight = albumSize
        if(phoneSize == 320){ // 4inch
            
        } else if(phoneSize == 375){ // 4.7inch
            
        } else{ // 5.5inch
            
        }
    }
    
    func makeFirstContainer(){
        firstContainer = UIView(frame: CGRect(x: FCFrameXPoint, y: FCFrameYPoint, width: FCFrameWidth, height: FCFrameHeight))
//        firstContainer.backgroundColor = UIColor.whiteColor()
        super.view.addSubview(firstContainer)
        
        // MARK: Song Title
        let FCTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 10, width: firstContainer.bounds.width, height: 20))
        FCTitle.text = songTitle
        FCTitle.font = FCTitle.font.fontWithSize(16)
        FCTitle.textColor = UIColor.whiteColor()
        firstContainer.addSubview(FCTitle)
        
        // MARK: Song Artist
        let FCArtist: UILabel = UILabel(frame: CGRect(x: 0, y: 30, width: firstContainer.bounds.width, height: 20))
        FCArtist.text = artist
        FCArtist.font = FCArtist.font.fontWithSize(12)
        FCArtist.textColor = UIColor.whiteColor()
        firstContainer.addSubview(FCArtist)
        
        // MARK: Add Button
        
        let FCAddButton: UIButton = UIButton(frame: CGRect(x: firstContainer.bounds.width-80, y: firstContainer.bounds.height - 30, width: 80, height: 30))
        FCAddButton.backgroundColor = UIColor.blueColor()
        FCAddButton.setTitle("Add", forState: UIControlState.Normal)
        firstContainer.addSubview(FCAddButton)
        
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
