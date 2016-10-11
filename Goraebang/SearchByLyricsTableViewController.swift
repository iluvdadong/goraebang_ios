//
//  SearchByLyricsTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 23/09/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//


import UIKit

class SearchByLyricsTableViewController: UITableViewController{
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    var searchResult:JSON!
    // Type 0: Title, Type 1: Artist, Type 2: Lyrics
    var searchType:Int!
    var userInfo:UserInfoGetter!
    
    func searchCall(n:NSNotification){
        let searchText:String = String(n.userInfo!["searchText"]!)
        searchSong(searchText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = UserInfoGetter()
        
        tableView.showsVerticalScrollIndicator = false
        
        if(view.bounds.width == 320){
            tableView.rowHeight = 100.0
        } else if (view.bounds.width == 375){
            tableView.rowHeight = 110.0
        } else {
            tableView.rowHeight = 120.0
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchByArtistTableViewController.searchCall), name: "com.sohn.searchByLyricsKey", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchResult != nil){
            return searchResult.count
        }
        else {
            return 0
        }
    }
    
    func searchSong(searchText: String){
        if(searchText != ""){
            let search_text_UTF8 = searchText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            
//            let urlStr = "\(goraebang_url)/json/search_by_lyrics?query=\(search_text_UTF8!)"
            let urlStr = "\(goraebang_url)/json/search_by?search_by=artist&mytoken=\(userInfo.token)&query=\(search_text_UTF8!)"
            let url = NSURL(string: urlStr)
            
            
            let request: NSMutableURLRequest = NSMutableURLRequest()
            request.URL = NSURL(string: "\(urlStr)")
            request.HTTPMethod = "GET"
            
            if let jsonData = NSData(contentsOfURL: url!) as NSData!{
                searchResult = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
            }
            else{
                searchResult = nil
                //MARK: 검색 결과가 없다는 Alert View 생성
            }
//            print(searchResult)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchByLyricsTableCell", forIndexPath: indexPath) as! SearchByLyricsTableViewCell
        
        let row = indexPath.row
        
        cell.songNumberLabel.font = cell.songNumberLabel.font.fontWithSize(12)
        cell.songNumberLabel.text = String(searchResult[row]["song_tjnum"])
        //        cell.songTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.songTitleLabel.font = cell.songTitleLabel.font.fontWithSize(12)
        cell.songTitleLabel.text = searchResult[row]["title"].string
        //        cell.songArtistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.songArtistLabel.font = cell.songArtistLabel.font.fontWithSize(12)
        //        cell.songArtistLabel.text = myListSongs["artistName"][row].string
        cell.songArtistLabel.text = searchResult[row]["artist_name"].string
        
        if(searchResult[row]["jacket_small"].string != nil){
            cell.songImageWebView.loadRequest(NSURLRequest(URL: NSURL(string: searchResult[row]["jacket_small"].string!)!))
            cell.songImageWebView.scalesPageToFit = true
            cell.songImageWebView.userInteractionEnabled = false
        } else {
            cell.songImageWebView = nil
        }
        //        segmentedController.selectedSegmentIndex == searchType
        
        cell.songAddButton.userInteractionEnabled = true
        cell.songAddButton.tag = searchResult[row]["id"].int! // 여기에 파라미터 넘기자
        
        if searchResult[row]["is_my_favorite"] == true{ // 내노래 추가된 경우
            if let image = UIImage(named: "AddButtonActive"){
                cell.songAddButton.setImage(image, forState: .Normal)
            }
            cell.songAddButton.addTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
        } else { // 안된 경우
            cell.songAddButton.addTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
        }

        
        // Configure the cell...
        return cell
    }
    
    func songAddAction(sender: UIButton!){
        //        print("Button tapped \(sender.tag)")
        if let image = UIImage(named: "AddButtonActive"){
            sender.setImage(image, forState: .Normal)
        }
        
        let post:NSString = "id=\(userInfo.myId)&myList_id=\(userInfo.myListId)&song_id=\(sender.tag)"
        
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
            
            // UIActivityIndicator View 사용하면 확인 버튼 없이 몇 초 후에 사라질 수 있다.
            if(result["message"] == "SUCCESS"){
                alertWithWarningMessage("추가되었습니다")
            }
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        // Add Action 삭제
        sender.removeTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
        sender.addTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
        
    }
    
    func songDeleteAction(sender: UIButton!){
        print("Song Delete Action Start Sender tag is \(sender.tag)")
        
        if let image = UIImage(named: "AddButtonDeactive"){
            sender.setImage(image, forState: .Normal)
        }
        
        let post:NSString = "id=\(userInfo.myId)&song_id=\(sender.tag)"
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
        
        sender.removeTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
        sender.addTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
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

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SongDetailFromLyricsSearch" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            detailViewController.songInfo = Song()
            // type 5 Lyrics인 경우로 생성
            detailViewController.songInfo.set(searchResult, row: row!, type: 5)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
