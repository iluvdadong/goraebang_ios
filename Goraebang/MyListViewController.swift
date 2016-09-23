//
//  MyListViewController.swift
//  Goraebang
//
//  Created by Sohn on 9/10/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit


class MyListViewController: UIViewController {

    @IBOutlet weak var storedSongCountLabel: UILabel!
    
    @IBOutlet weak var backgroundWebView: UIWebView!
    
    @IBOutlet weak var preferenceButton: UIButton!
    @IBOutlet weak var myListButton: UIButton!
    @IBOutlet weak var blackListButton: UIButton!
    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var myListContainer: UIView!
    var userInfo:UserInfoGetter!
    var selectLine:UILabel!
    
    @IBAction func preferenceAction(sender: AnyObject) {
        myListContainer.hidden = true          
        selectLine.frame = CGRect(x: view.bounds.width*0, y: 147, width: view.bounds.width*0.3+2.5, height: 2)
    }
    
    
    @IBAction func myListAction(sender: AnyObject) {
        myListContainer.hidden = false
        selectLine.frame = CGRect(x: view.bounds.width*0.3+2.9, y: 147, width: view.bounds.width*0.4+2.5, height: 2)
    }
    
    
    @IBAction func blackListAction(sender: AnyObject) {
        myListContainer.hidden = true
        selectLine.frame = CGRect(x: view.bounds.width*0.7+3.8, y: 147, width: view.bounds.width*0.3, height: 2)
    }
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    
    override func viewDidAppear(animated: Bool) {
//        countMyListSong()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyListViewController.countMyListSong(_:)), name: "com.sohn.myListSongCountKey", object: nil)
        // 처음에 백그라운드 이미지 설정
        setBackgroundWebView()
        
        selectLine = UILabel()
        selectLine.frame = CGRect(x: view.bounds.width*0.3+2.9, y: 147, width: view.bounds.width*0.4+2.5, height: 2)
        selectLine.backgroundColor = UIColor.redColor()
        headerContainer.addSubview(selectLine)
        
        // Do any additional setup after loading the view.
    }
    
    func setBackgroundWebView(){
        // API로 자기 리스트의 노래 중 하나의 앨범을 받아오는 것을 변경
        backgroundWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/080/874/149/80874149_1474595867898_1_600x600.JPG")!))
        
        // 블러처리
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: backgroundWebView.bounds.width, height: 75)
    
        backgroundWebView.addSubview(blurEffectView)
        backgroundWebView.scalesPageToFit = true
        backgroundWebView.userInteractionEnabled = false
        
        backgroundWebView.layer.shadowColor = UIColor.blackColor().CGColor
        backgroundWebView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backgroundWebView.layer.shadowOpacity = 0.25
        backgroundWebView.layer.shadowRadius = 9
    }
    
    func countMyListSong(n:NSNotification){
        
        // 내 리스트에 저장된 개수 API 필요
        let count:Int = Int((n.userInfo!["count"]?.intValue)!)
        
        storedSongCountLabel.text = "저장된 곡 개수 \(count)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
