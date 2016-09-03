//
//  SearchTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 9/2/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    
    var searchResult:JSON!

    var searchBar:UITextField!
    // MARK: Width, Height Settings
    var searchBarWidth:CGFloat!
    var searchBarHeight:CGFloat!
    var searchBarStartingXPoint:CGFloat!
    var searchBarStartingYPoint:CGFloat!
    
    var searchButtonWidth:CGFloat!
    var searchButtonStartingXPoint:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        setSize(view.bounds.width)
        
        
        // 테이블 뷰 행 높이 설정
        tableView.rowHeight = 90.0
        tableView.sectionHeaderHeight = 120

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: 아이폰 사이즈 마다 변수 값 세팅
    func setSize(phoneSize:CGFloat){
//        contentNum = 6
        searchBarStartingXPoint = 30
        searchBarStartingYPoint = 50
        
        searchBarWidth = 220
        searchBarHeight = 40
        
        searchButtonStartingXPoint = searchBarStartingXPoint + searchBarWidth
        searchButtonWidth = 40
        if(phoneSize == 320){ // 4inch
            
        } else if(phoneSize == 375){ // 4.7inch
            
        } else{ // 5.5inch
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    // MARK: Section Header
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let userInfoView = UIView()
        userInfoView.backgroundColor = UIColor.grayColor()
        //        userInfoView.backgroundColor = UIColor.whiteColor()
        
        userInfoView.layer.masksToBounds = false
        userInfoView.layer.shadowOffset = CGSizeMake(0, 3)
        userInfoView.layer.shadowRadius = 5
        userInfoView.layer.shadowOpacity = 0.6
        
        searchBar = UITextField()
        searchBar.frame = CGRect(x: searchBarStartingXPoint, y: searchBarStartingYPoint, width: searchBarWidth, height: searchBarHeight)
        searchBar.backgroundColor = UIColor.darkGrayColor()
        searchBar.textAlignment = NSTextAlignment.Left
        searchBar.placeholder = "검색어를 입력하세요."
        userInfoView.addSubview(searchBar)
        
        let searchButton = UIButton(frame: CGRectMake(searchButtonStartingXPoint, searchBarStartingYPoint, searchButtonWidth, searchBarHeight))
        //        showTop100DetailButton.backgroundColor = UIColor.whiteColor()
        searchButton.backgroundColor = UIColor.blueColor()
        searchButton.tintColor = UIColor.redColor()
        searchButton.setTitle("검색", forState: .Normal)
        searchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        searchButton.addTarget(self, action: #selector(searchSong), forControlEvents: .TouchUpInside)
        userInfoView.addSubview(searchButton)
        
        
        
//        let userInfoBackground = UIImageView()
//        userInfoBackground.frame = CGRect(x: 0, y: 0, width: 322, height: 120)
//        userInfoBackground.image = UIImage(named: "Park")
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = userInfoBackground.bounds
//        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        userInfoBackground.addSubview(blurEffectView)
//        userInfoView.addSubview(userInfoBackground)
        
        
//        let userTitleLabel = UILabel(frame: CGRect(x: 0, y: 70, width: view.bounds.width, height: 20))
//        userTitleLabel.text = "고래"
//        userTitleLabel.textColor = UIColor.whiteColor()
//        userTitleLabel.textAlignment = NSTextAlignment.Center
//        userInfoView.addSubview(userTitleLabel)
//        
//        let userSongCountLabel = UILabel(frame: CGRect(x: 0, y: 90, width: view.bounds.width, height: 20))
//        userSongCountLabel.textColor = UIColor.whiteColor()
//        userSongCountLabel.text = "저장된 곡 개수 1"
//        userSongCountLabel.textAlignment = NSTextAlignment.Center
//        userSongCountLabel.font = userSongCountLabel.font.fontWithSize(12)
//        userInfoView.addSubview(userSongCountLabel)
        
        return userInfoView
    }

    func searchSong(sender: UIButton!){
        print("search button tapped")
        print(goraebang_url)
        print("검색어 : \(searchBar.text!)")
        
        let search_text_UTF8 = searchBar.text?.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        print(search_text_UTF8)
        let urlStr = "\(goraebang_url)/json/search?query=\(search_text_UTF8!)"
        print(urlStr)
        
//        let url = NSURL(string: "\(goraebang_url)/json/song")
        
        let url = NSURL(string: urlStr)
        
//        let url:NSURL = NSURL(string: "http://52.78.127.110/json/search?query=연가")!
//        print(url)
        
        var request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: "\(urlStr)")
        
        request.HTTPMethod = "GET"
        print(request)
        
        let jsonData = NSData(contentsOfURL: url!) as NSData!
        
        searchResult = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
//
        
        print(searchResult["lyrics"])
        print(searchResult["lyrics"].count)
        
//        if let search_text = searchBar.text {
//            print(search_text)
////            let url:NSURL = NSURL(string: "\(goraebang_url)/json/search?query=\(search_text)")!
//            let url:NSURL = NSURL(string: "http://52.78.127.110/json/search?query=연가")!
//            let jsonData = NSData(contentsOfURL: url) as NSData!
//            
//            searchResult = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
//            
//            print(searchResult)
//        }
        
        // searchBar.text 의 텍스트로 검색 후 결과를 JSON에 저장하고
        // Table Cell을 리로드
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
