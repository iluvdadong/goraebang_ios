//
//  MyListDetailViewController.swift
//  Goraebang
//
//  Created by Sohn on 8/7/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit


class MyListDetailViewController: UIViewController {
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    // Configure: Hide bottom bar on push
    
    // 필요한 정보
    // 노래 제목, 가수, 가사, 발매일 등
    
    
    
    // 받은 정보로 View, Label 생성
    //    var firstContainer: UIView!
    //    var secondContainer: UIView!
    //    var thirdContainer: UIView!
    
    // albumWebView에 사용될 변수
    //    var albumSize: CGFloat!
    //    var albumStartingXPoint: CGFloat!
    //    var albumStartingYPoint: CGFloat!
    
    // firstContainer 변수
    //    var FCFrameXPoint: CGFloat!
    //    var FCFrameYPoint: CGFloat!
    //    var FCFrameWidth: CGFloat!
    //    var FCFrameHeight: CGFloat!
    
    // secondContainer 변수
    //    var SCFrameXPoint: CGFloat!
    //    var SCFrameYPoint: CGFloat!
    //    var SCFrameWidth: CGFloat!
    //    var SCFrameHeight: CGFloat!
    
    // thirdContainer 변수
    //    var TCFrameXPoint: CGFloat!
    //    var TCFrameYPoint: CGFloat!
    //    var TCFrameWidth: CGFloat!
    //    var TCFrameHeight: CGFloat!
    
    // Navigation Var 때문에 생기는 Top padding
    //    var fixedTopPadding: CGFloat!
    //
    //    var phoneSize:CGFloat!
    
    
    // 넘어오기전에 받는 정보
    var songInfo:Song!
    
    // MyList Page인 경우에 true로 넘어온다.
    var isMylist:Bool = false
    
    var userInfo:UserInfoGetter!
    
    
    var row:Int!
    var is_my_list:Int!
    
    // 0 : search by title
    // 1 : search by artist
    // 2 : search by lyrics
    var from_where:Int!
    
    // 190916 Interface Builder로 변경
    
    
    
    @IBOutlet weak var albumJacketWebView: UIWebView!
    
    var currentStatus: Bool! // 0은 추가안됨, 1은 추가됨
    @IBOutlet weak var songAddButton: UIButton!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var TJNumberLabel: UILabel!
    
    @IBOutlet weak var lyricsTextView: UITextView!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var songCount: UILabel!
    
    override func viewDidDisappear(animated: Bool) {
        // 탭 간 이동시에만 사라져야 한다.
        //        if(self.tabBarController?.selectedIndex != 0){
        //            self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.popToRootViewControllerAnimated(true)
        //        }
    }
    
    // TextView 스크롤 가장 위에서 시작
    override func viewDidLayoutSubviews() {
        lyricsTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = UserInfoGetter()
        fillContents()
        // Do any additional setup after loading the view.
    }
    // Activity 추가
    
    @IBAction func songAddAction(sender: AnyObject) {
        if currentStatus == true {
            if let image = UIImage(named: "AddButtonDeactive"){
                songAddButton.setImage(image, forState: .Normal)
            }
            
            let post:NSString = "id=\(userInfo.myId)&song_id=\(songInfo.id)"
            let url:NSURL = NSURL(string: "\(goraebang_url)/json/mySong_delete")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            
            do {
                // NSURLSession.DataTaskWithRequest 로 변경해야한다.
                try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
                //            let mySongDeleteResultJSON = JSON(data: mySongDeleteResult, options: NSJSONReadingOptions.MutableContainers, error: nil)
                
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            let detailParam = ["is_my_list":0, "row":row!]
            
            if from_where == 0{ // 제목검색 으로
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromTitleSongDetail", object: self, userInfo: detailParam)
            } else if from_where == 1 { // 가수검색 으로
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromArtistSongDetail", object: self, userInfo: detailParam)
            } else if from_where == 2 { // 가사검색 으로
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromLyricsSongDetail", object: self, userInfo: detailParam)
            } else if from_where == 3 { // top100에서 온 경우
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromTopChartSongDetail", object: self, userInfo: detailParam)
            } else if from_where == 4 {
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromRecommendSongDetail", object: self, userInfo: detailParam)
            }
            
            currentStatus = false
        } else {
            if let image = UIImage(named: "AddButtonActive"){
                songAddButton.setImage(image, forState: .Normal)
            }
            
            
            let post:NSString = "id=\(userInfo.myId)&myList_id=\(userInfo.myListId)&song_id=\(songInfo.id)"
            
            let url:NSURL = NSURL(string: "\(goraebang_url)/json/mySong_create")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            
            do {
                // NSURLSession.DataTaskWithRequest 로 변경해야한다.
                let addSongResultData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
                
                let result = JSON(data: addSongResultData, options: NSJSONReadingOptions.MutableContainers, error: nil)
                
                print(result)
                
                // UIActivityIndicator View 사용하면 확인 버튼 없이 몇 초 후에 사라질 수 있다.
                if(result["message"] == "SUCCESS"){
                    alertWithWarningMessage("추가되었습니다")
                    
                    //                let tmpController = self.revealViewController().frontViewController as! MyTabBarController
                    //                self.performSegueWithIdentifier("AddSong", sender: self)
                    
                }
                
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            currentStatus = true
            
            let detailParam = ["is_my_list":1, "row":row!]
            
            if from_where == 0{
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromTitleSongDetail", object: self, userInfo: detailParam)
            } else if from_where == 1 {
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromArtistSongDetail", object: self, userInfo: detailParam)
            } else if from_where == 2{
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromLyricsSongDetail", object: self, userInfo: detailParam)
            } else if from_where == 3{
                NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromTopChartSongDetail", object: self, userInfo: detailParam)
            } else if from_where == 4{ // recommend 로 정보 전송
                    NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.fromRecommendSongDetail", object: self, userInfo: detailParam)
            }
            
        }
        
        
    }
    
    func alertWithWarningMessage(message: String){
        let alertView:UIAlertView = UIAlertView(frame: CGRect(x: 0, y: 1, width: 80, height: 40))
        
        alertView.message = message
        alertView.delegate = self
        alertView.show()
        
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertView.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
    func fillContents(){
        if albumJacketWebView != nil {
            albumJacketWebView.loadRequest(NSURLRequest(URL: NSURL(string: songInfo.albumWebViewString)!))
        }
        
        songTitleLabel.text = songInfo.title
        artistLabel.text = songInfo.artist
        TJNumberLabel.text = songInfo.song_tjnum!
        songCount.text = songInfo.songCount
        releaseDate.text = songInfo.releaseDate
        
        if songInfo.lyrics != nil {
            let  attrStr: NSMutableAttributedString = try! NSMutableAttributedString(data: songInfo.lyrics.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attrStr.length))
            lyricsTextView.attributedText = attrStr
        }
        
        lyricsTextView.showsVerticalScrollIndicator = false
        
        if currentStatus != nil{
            if currentStatus == true{
                if let image = UIImage(named: "AddButtonActive"){
                    songAddButton.setImage(image, forState: .Normal)
                }
                //            addTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
            } else { // 안된 경우
                //            songAddButton.addTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
            }
        }
        
        // 마이 리스트의 경우 추가 삭제 버튼이 필요하지 않다.
        if isMylist == true {
            songAddButton.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func setMyAlbum(phoneSize:CGFloat){
    //        if(phoneSize == 320){ // 4inch
    //            albumSize = 150.0
    //            albumStartingXPoint = (phoneSize/2 - albumSize)/2
    //            albumStartingYPoint = fixedTopPadding + albumStartingXPoint
    //        } else if(phoneSize == 375){ // 4.7inch
    //            albumSize = 150.0
    //            albumStartingXPoint = (phoneSize/2 - albumSize)/2
    //            albumStartingYPoint = fixedTopPadding + albumStartingXPoint
    //        } else{ // 5.5inch
    //            albumSize = 150.0
    //            albumStartingXPoint = (phoneSize/2 - albumSize)/2
    //            albumStartingYPoint = fixedTopPadding + albumStartingXPoint
    //        }
    //    }
    
    //    func makeMyAlbumWebView(){
    //        songInfo.albumWebView.frame = CGRect(x: albumStartingXPoint, y: albumStartingYPoint, width: albumSize, height: albumSize)
    //        songInfo.albumWebView.userInteractionEnabled = false
    //        songInfo.albumWebView.scalesPageToFit = true
    //        super.view.addSubview(songInfo.albumWebView)
    //    }
    
    //    func setMyFirstContainer(phoneSize: CGFloat){
    //        FCFrameXPoint = phoneSize/2 + 10
    //        FCFrameYPoint = albumStartingXPoint + fixedTopPadding
    //        FCFrameWidth = phoneSize/2 - 20
    //        FCFrameHeight = albumSize
    //        if(phoneSize == 320){ // 4inch
    //
    //        } else if(phoneSize == 375){ // 4.7inch
    //
    //        } else{ // 5.5inch
    //
    //        }
    //    }
    
    //    func makeMyFirstContainer(){
    //        firstContainer = UIView(frame: CGRect(x: FCFrameXPoint, y: FCFrameYPoint, width: FCFrameWidth, height: FCFrameHeight))
    //        //        firstContainer.backgroundColor = UIColor.whiteColor()
    //        super.view.addSubview(firstContainer)
    //
    //        // MARK: Song Title
    //        let FCTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 10, width: firstContainer.bounds.width, height: 20))
    //        FCTitle.text = songInfo.title
    //        FCTitle.font = FCTitle.font.fontWithSize(16)
    //        FCTitle.textColor = UIColor.whiteColor()
    //        firstContainer.addSubview(FCTitle)
    //
    //        // MARK: Song Artist
    //        let FCArtist: UILabel = UILabel(frame: CGRect(x: 0, y: 30, width: firstContainer.bounds.width, height: 20))
    //        FCArtist.text = songInfo.artist
    //        FCArtist.font = FCArtist.font.fontWithSize(12)
    //        FCArtist.textColor = UIColor.whiteColor()
    //        firstContainer.addSubview(FCArtist)
    //
    //        // MARK: Add Button
    //
    //        // 마이리스트인 경우는 Add Button없도록
    //        if(isMylist == false){
    //            let FCAddButton: UIButton = UIButton(frame: CGRect(x: firstContainer.bounds.width-80, y: firstContainer.bounds.height - 30, width: 80, height: 30))
    //            FCAddButton.backgroundColor = UIColor.blueColor()
    //            FCAddButton.setTitle("Add", forState: UIControlState.Normal)
    //            FCAddButton.addTarget(self, action: #selector(addSong), forControlEvents: .TouchUpInside)
    //
    //            firstContainer.addSubview(FCAddButton)
    //        }
    //    }
    
    
    // MARK: 두번째 컨테이너 설정
    //    func setMySecondContainer(phoneSize: CGFloat){
    //        SCFrameXPoint = 10
    //        SCFrameYPoint = FCFrameYPoint + FCFrameHeight + 10
    //        SCFrameWidth = phoneSize - 20
    //        SCFrameHeight = 120
    //    }
    
    // MARK: 두번째 컨테이너 생성
    //    func makeMySecondContainer(){
    //        secondContainer = UIView(frame: CGRect(x: SCFrameXPoint, y: SCFrameYPoint, width: SCFrameWidth, height: SCFrameHeight))
    //        secondContainer.backgroundColor = UIColor.whiteColor()
    //        super.view.addSubview(secondContainer)
    //    }
    
    // MARK: 세번째 컨테이너 설정
    //    func setMyThirdContainer(phoneSize1: CGFloat){
    //        TCFrameXPoint = 10
    //        TCFrameYPoint = SCFrameYPoint + SCFrameHeight + 10
    //        TCFrameWidth = phoneSize - 20
    //        TCFrameHeight = view.bounds.height - TCFrameYPoint - 10
    //    }
    
    //    func makeMyThirdContainer(){
    //        thirdContainer = UIView(frame: CGRect(x: TCFrameXPoint, y: TCFrameYPoint, width: TCFrameWidth, height: TCFrameHeight))
    //        thirdContainer.backgroundColor = UIColor.whiteColor()
    //        super.view.addSubview(thirdContainer)
    //
    //        // UITextView 사용하는 방법
    //        let lyricsTextView = UITextView(frame: CGRect(x: 10, y:10, width:TCFrameWidth - 20, height: TCFrameHeight - 20))
    //        lyricsTextView.showsVerticalScrollIndicator = false
    //
    //        let  attrStr: NSAttributedString = try! NSAttributedString(data: songInfo.lyrics.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    //
    //        lyricsTextView.attributedText = attrStr
    //        lyricsTextView.editable = false
    //        lyricsTextView.selectable = false // make text can`t selectable
    //
    //        thirdContainer.addSubview(lyricsTextView)
    
    
    // MARK: webView사용하는 방식
    //        var lyricsWebView = UIWebView(frame: CGRect(x: 10, y:10, width:TCFrameWidth - 20, height: TCFrameHeight - 20))
    //
    //        lyricsWebView.userInteractionEnabled = true
    //        lyricsWebView.scalesPageToFit = true
    //        lyricsWebView.loadHTMLString(lyrics, baseURL: nil)
    
    
    //        var lyricsTextField = UITextField(frame: CGRect(x: 10, y:10, width:TCFrameWidth - 20, height: TCFrameHeight - 20))
    //        lyricsTextField = lyrics.dataUsingEncoding(NSUTF8StringEncoding)
    //        thirdContainer.addSubview(lyricsTextField)
    
    //    }
    
    // MARK*: addSong 후에는 마이리스트 리로드 해야한다.(추가)
    //    func addSong(sender: UIButton!){
    //        print("button tapped")
    //
    //
    //        let post:NSString = "id=\(userInfo.myId)&myList_id=\(userInfo.myListId)&song_id=\(songInfo.id)"
    //
    //        let url:NSURL = NSURL(string: "\(goraebang_url)/json/mySong_create")!
    //
    //        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
    //
    //        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
    //        request.HTTPMethod = "POST"
    //        request.HTTPBody = postData
    //
    //        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
    //
    //        do {
    //            // NSURLSession.DataTaskWithRequest 로 변경해야한다.
    //            let addSongResultData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
    //
    //
    //            let result = JSON(data: addSongResultData, options: NSJSONReadingOptions.MutableContainers, error: nil)
    //
    //            print(result)
    //
    //            // UIActivityIndicator View 사용하면 확인 버튼 없이 몇 초 후에 사라질 수 있다.
    //            if(result["message"] == "SUCCESS"){
    //                alertWithWarningMessage("추가되었습니다")
    //
    //                //                let tmpController = self.revealViewController().frontViewController as! MyTabBarController
    //                //                self.performSegueWithIdentifier("AddSong", sender: self)
    //
    //            }
    //
    //        } catch let error as NSError{
    //            print(error.localizedDescription)
    //        }
    //
    //    }
    
    // MARK*: UIAlertController로 변경할 것
    // MARK: 사이즈 조절 방법 찾을 것
    
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "AddSong" {
    //            let controller = segue.destinationViewController as! MyListTableViewController
    //
    //
    //
    //
    ////            controller.removeFromParentViewController()
    //
    //        }
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
