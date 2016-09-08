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
    
    // Type 0: Title, Type 1: Artist, Type 2: Lyrics
    var searchType:Int!
    
    var searchBar:UITextField!
    
    // MARK: Segmented Control
    var segmentedController:UISegmentedControl!
    
    // MARK: Width, Height Settings
    var searchBarWidth:CGFloat!
    var searchBarHeight:CGFloat!
    var searchBarStartingXPoint:CGFloat!
    var searchBarStartingYPoint:CGFloat!
    
    var searchButtonWidth:CGFloat!
    var searchButtonStartingXPoint:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        searchType = 0
        
        let items = ["제목", "가수", "가사"]
        segmentedController = UISegmentedControl(items: items)
        segmentedController.selectedSegmentIndex = 0
        
        segmentedController.addTarget(self, action: #selector(SearchTableViewController.segmentedControllerAction(_:)), forControlEvents: .ValueChanged)
        segmentedController.addTarget(self, action: #selector(SearchTableViewController.segmentedControllerAction(_:)), forControlEvents: .TouchUpInside)
        
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        // hide keyboard
        
        setSize(view.bounds.width)
        tableView.showsVerticalScrollIndicator = false
        
        // 테이블 뷰 행 높이 설정
        tableView.rowHeight = 90.0
        tableView.sectionHeaderHeight = 120
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        
        segmentedController.frame = CGRect(x: 0, y: searchBarStartingYPoint + 45, width: view.bounds.width, height: 25)
        segmentedController.tintColor = UIColor.whiteColor()
        segmentedController.backgroundColor = UIColor.darkGrayColor()
        //        segmentedController.layer.masksToBounds = true
        segmentedController.layer.cornerRadius = 0
        segmentedController.layer.borderColor = UIColor.darkGrayColor().CGColor
        segmentedController.layer.borderWidth = 2.0
        
        userInfoView.addSubview(segmentedController)
        
        return userInfoView
    }
    
    func segmentedControllerAction(segment: UISegmentedControl){
        print("Selected Index is \(segment.selectedSegmentIndex)")
        
        searchType = segment.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    func searchSong(sender: UIButton!){
        searchBar.endEditing(true)
        
        if(searchBar.text != ""){
            let search_text_UTF8 = searchBar.text?.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            
            let urlStr = "\(goraebang_url)/json/search?query=\(search_text_UTF8!)"
            
            //        let url = NSURL(string: "\(goraebang_url)/json/song")
            
            let url = NSURL(string: urlStr)
            
            //        let url:NSURL = NSURL(string: "http://52.78.127.110/json/search?query=연가")!
            //        print(url)
            
            let request: NSMutableURLRequest = NSMutableURLRequest()
            request.URL = NSURL(string: "\(urlStr)")
            
            request.HTTPMethod = "GET"
            //        print(request)
            
            //        let jsonData = NSData(contentsOfURL: url!) as NSData!
            
            if let jsonData = NSData(contentsOfURL: url!) as NSData!{
                searchResult = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
                print(searchResult.count)
                
            }
            else{
                searchResult = nil
                print("jsonData 없는 경우")
                print("검색결과가 없습니다")
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchResult != nil){
            if(searchType == 0){
                segmentedController.selectedSegmentIndex == 0
                return searchResult["title"].count
            }
            else if(searchType == 1){
                segmentedController.selectedSegmentIndex == 1
                return searchResult["artist"].count
            }
            else {
                segmentedController.selectedSegmentIndex == 2
                return searchResult["lyrics"].count
            }
        }
        else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTableCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        let row = indexPath.row
        
        if(searchType == 0){
            cell.songNumberLabel.font = cell.songNumberLabel.font.fontWithSize(12)
            cell.songNumberLabel.text = String(searchResult["title"][row]["song_tjnum"])
            //        cell.songTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.songTitleLabel.font = cell.songTitleLabel.font.fontWithSize(12)
            cell.songTitleLabel.text = searchResult["title"][row]["title"].string
            //        cell.songArtistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.songArtistLabel.font = cell.songArtistLabel.font.fontWithSize(12)
            //        cell.songArtistLabel.text = myListSongs["artistName"][row].string
            cell.songArtistLabel.text = searchResult["title"][row]["artist_name"].string
            
            cell.songImageWebView.loadRequest(NSURLRequest(URL: NSURL(string: searchResult["title"][row]["jacket_small"].string!)!))
            cell.songImageWebView.frame.size.height = 63.5
            cell.songImageWebView.frame.size.width = 63.5
            cell.songImageWebView.scalesPageToFit = true
            cell.songImageWebView.userInteractionEnabled = false
        }
        else if(searchType == 1){
            cell.songNumberLabel.font = cell.songNumberLabel.font.fontWithSize(12)
            cell.songNumberLabel.text = String(searchResult["artist"][row]["song_tjnum"])
            //        cell.songTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.songTitleLabel.font = cell.songTitleLabel.font.fontWithSize(12)
            cell.songTitleLabel.text = searchResult["artist"][row]["title"].string
            //        cell.songArtistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.songArtistLabel.font = cell.songArtistLabel.font.fontWithSize(12)
            //        cell.songArtistLabel.text = myListSongs["artistName"][row].string
            cell.songArtistLabel.text = searchResult["artist"][row]["artist_name"].string
            
            cell.songImageWebView.loadRequest(NSURLRequest(URL: NSURL(string: searchResult["artist"][row]["jacket_small"].string!)!))
            cell.songImageWebView.frame.size.height = 63.5
            cell.songImageWebView.frame.size.width = 63.5
            cell.songImageWebView.scalesPageToFit = true
            cell.songImageWebView.userInteractionEnabled = false
        }
        else{
            cell.songNumberLabel.font = cell.songNumberLabel.font.fontWithSize(12)
            cell.songNumberLabel.text = String(searchResult["lyrics"][row]["song_tjnum"])
            //        cell.songTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.songTitleLabel.font = cell.songTitleLabel.font.fontWithSize(12)
            cell.songTitleLabel.text = searchResult["lyrics"][row]["title"].string
            //        cell.songArtistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.songArtistLabel.font = cell.songArtistLabel.font.fontWithSize(12)
            //        cell.songArtistLabel.text = myListSongs["artistName"][row].string
            cell.songArtistLabel.text = searchResult["lyrics"][row]["artist_name"].string
            
            cell.songImageWebView.loadRequest(NSURLRequest(URL: NSURL(string: searchResult["lyrics"][row]["jacket_small"].string!)!))
            cell.songImageWebView.frame.size.height = 63.5
            cell.songImageWebView.frame.size.width = 63.5
            cell.songImageWebView.scalesPageToFit = true
            cell.songImageWebView.userInteractionEnabled = false
        }
        
        segmentedController.selectedSegmentIndex == searchType
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSongDetailFromSearch" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(searchResult, row: row!, type: 2)
            
        }
    }
    
    
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
