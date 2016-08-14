//
//  MyListDetailViewController.swift
//  Goraebang
//
//  Created by Sohn on 8/7/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyListDetailViewController: UIViewController {
    
    // Configure: Hide bottom bar on push
    
    // 필요한 정보
    // 노래 제목, 가수, 가사, 발매일 등
    @IBOutlet weak var songTitleLabel: UINavigationItem! // title
    
    // 넘어오기전에 받는 정보
    var songId: Int! // MyList에 추가할 때 서버에 song id를 넘기기 위해
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
    
    // secondContainer 변수
    var SCFrameXPoint: CGFloat!
    var SCFrameYPoint: CGFloat!
    var SCFrameWidth: CGFloat!
    var SCFrameHeight: CGFloat!
    
    // thirdContainer 변수
    var TCFrameXPoint: CGFloat!
    var TCFrameYPoint: CGFloat!
    var TCFrameWidth: CGFloat!
    var TCFrameHeight: CGFloat!
    
    // Navigation Var 때문에 생기는 Top padding
    var fixedTopPadding: CGFloat!
    
    var phoneSize:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        phoneSize = view.bounds.width
        
        fixedTopPadding = 65.0
        print(songId)
        
        setMyAlbum(phoneSize)
        setMyFirstContainer(phoneSize)
        setMySecondContainer(phoneSize)
        setMyThirdContainer(phoneSize)
        
        makeMyAlbumWebView()
        makeMyFirstContainer()
        makeMySecondContainer()
        makeMyThirdContainer()
        
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
    
    func makeMyAlbumWebView(){
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
    
    func makeMyFirstContainer(){
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
        FCAddButton.addTarget(self, action: #selector(addSong), forControlEvents: .TouchUpInside)
        
        firstContainer.addSubview(FCAddButton)
    }
    
    
    // MARK: 두번째 컨테이너 설정
    func setMySecondContainer(phoneSize: CGFloat){
        SCFrameXPoint = 10
        SCFrameYPoint = FCFrameYPoint + FCFrameHeight + 10
        SCFrameWidth = phoneSize - 20
        SCFrameHeight = 120
    }
    
    // MARK: 두번째 컨테이너 생성
    func makeMySecondContainer(){
        secondContainer = UIView(frame: CGRect(x: SCFrameXPoint, y: SCFrameYPoint, width: SCFrameWidth, height: SCFrameHeight))
        secondContainer.backgroundColor = UIColor.whiteColor()
        super.view.addSubview(secondContainer)
    }
    
    // MARK: 세번째 컨테이너 설정
    func setMyThirdContainer(phoneSize: CGFloat){
        TCFrameXPoint = 10
        TCFrameYPoint = SCFrameYPoint + SCFrameHeight + 10
        TCFrameWidth = phoneSize - 20
        TCFrameHeight = view.bounds.height - TCFrameYPoint - 10
    }
    
    func makeMyThirdContainer(){
        thirdContainer = UIView(frame: CGRect(x: TCFrameXPoint, y: TCFrameYPoint, width: TCFrameWidth, height: TCFrameHeight))
        thirdContainer.backgroundColor = UIColor.whiteColor()
        super.view.addSubview(thirdContainer)
        
        // UITextView 사용하는 방법
        let lyricsTextView = UITextView(frame: CGRect(x: 10, y:10, width:TCFrameWidth - 20, height: TCFrameHeight - 20))
        lyricsTextView.showsVerticalScrollIndicator = false
        
        let  attrStr: NSAttributedString = try! NSAttributedString(data: lyrics.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        
        lyricsTextView.attributedText = attrStr
        lyricsTextView.editable = false
        lyricsTextView.selectable = false // make text can`t selectable
        
        thirdContainer.addSubview(lyricsTextView)
        
        
        // MARK: webView사용하는 방식
        //        var lyricsWebView = UIWebView(frame: CGRect(x: 10, y:10, width:TCFrameWidth - 20, height: TCFrameHeight - 20))
        //
        //        lyricsWebView.userInteractionEnabled = true
        //        lyricsWebView.scalesPageToFit = true
        //        lyricsWebView.loadHTMLString(lyrics, baseURL: nil)
        
        
        //        var lyricsTextField = UITextField(frame: CGRect(x: 10, y:10, width:TCFrameWidth - 20, height: TCFrameHeight - 20))
        //        lyricsTextField = lyrics.dataUsingEncoding(NSUTF8StringEncoding)
        //        thirdContainer.addSubview(lyricsTextField)
        
    }
    
    func addSong(sender: UIButton!){
        print("button tapped")
        let tmpUserId = 1
        let tmpMyListId = 1
        let post:NSString = "id=\(tmpUserId)&myList_id=\(tmpMyListId)&song_id=\(songId)"
        
        let url:NSURL = NSURL(string: "http://52.78.113.43/json/mySong_create")!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do {
            // NSURLSession.DataTaskWithRequest 로 변경해야한다.
            let addSongResultData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            
            
            let result = JSON(data: addSongResultData, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            // UIActivityIndicator View 사용하면 확인 버튼 없이 몇 초 후에 사라질 수 있다.
            if(result["message"] == "SUCCESS"){
                alertWithMyMessage("추가되었습니다")
            }
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    // MARK*: UIAlertController로 변경할 것
    // MARK: 사이즈 조절 방법 찾을 것
    func alertWithMyMessage(message: String){
        let alertView:UIAlertView = UIAlertView(frame: CGRect(x: 0, y: 1, width: 80, height: 40))
        
        alertView.message = message
        alertView.delegate = self
        alertView.show()
        
        let delay = 0.7 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertView.dismissWithClickedButtonIndex(-1, animated: true)
        })
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
