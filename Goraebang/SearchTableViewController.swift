//
//  SearchTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 9/2/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit
//
//protocol SearchTableDelegate: class{
//    func didSearch()
//}

class SearchTableViewController: UITableViewController, UITextFieldDelegate {
    
    //    var OnSearchDelegate: OnSearchContainerViewController!
    
    //    weak var delegate: SearchTableDelegate?
    /*
     View delegate Call
     */
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    
    var searchResult:JSON!
    var userInfo:UserInfoGetter!
    
    // Type 0: Title, Type 1: Artist, Type 2: Lyrics
    var searchType:Int!
    var is_my_favorite:[Int]!
    
    func searchCall(n:NSNotification){
        let searchText:String = String(n.userInfo!["searchText"]!)
        searchSong(searchText)
    }
    
    func updateIsMyList(n:NSNotification){
        let row = n.userInfo!["row"] as! Int
        let isMyList = n.userInfo!["is_my_list"] as! Int
        is_my_favorite[row] = isMyList
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = UserInfoGetter()
        is_my_favorite = [Int]()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchTableViewController.searchCall), name: "com.sohn.searchByTitleKey", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchTableViewController.updateIsMyList), name: "com.sohn.fromTitleSongDetail", object: nil)
        tableView.showsVerticalScrollIndicator = false
        
        // 테이블 뷰 행 높이 설정
        if(view.bounds.width == 320){
            tableView.rowHeight = 100.0
        } else if (view.bounds.width == 375){
            tableView.rowHeight = 110.0
        } else {
            tableView.rowHeight = 120.0
        }
        
        //        tableView.sectionHeaderHeight = 95
    }
    
    // MARK: Return Key 입력 시 검색
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        searchBar.endEditing(true)
    //
    //        if(searchBar.text != ""){
    //            let search_text_UTF8 = searchBar.text?.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    //
    //            let urlStr = "\(goraebang_url)/json/search?query=\(search_text_UTF8!)"
    //
    //
    //            print(search_text_UTF8)
    //            let url = NSURL(string: urlStr)
    //
    //            let request: NSMutableURLRequest = NSMutableURLRequest()
    //            request.URL = NSURL(string: "\(urlStr)")
    //
    //            request.HTTPMethod = "GET"
    //
    //            if let jsonData = NSData(contentsOfURL: url!) as NSData!{
    //                searchResult = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
    //                print(searchResult.count)
    //
    //            } else{
    //                searchResult = nil
    //                // MARK: 검색 결과가 없습니다. Alert View 생성
    //            }
    //
    //            self.tableView.reloadData()
    //        }
    //        return true
    //    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: 아이폰 사이즈 마다 변수 값 세팅
    func setSize(phoneSize:CGFloat){
        if(phoneSize == 320){ // 4inch
            
        } else if(phoneSize == 375){ // 4.7inch
            
        } else{ // 5.5inch
            
        }
        
    }
    
    func searchSong(searchText: String){
        if(searchText != ""){
            let search_text_UTF8 = searchText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            
            let urlStr = "\(goraebang_url)/json/search_by?search_by=title&mytoken=\(userInfo.token)&query=\(search_text_UTF8!)"
            let url = NSURL(string: urlStr)
            
            let request: NSMutableURLRequest = NSMutableURLRequest()
            request.URL = NSURL(string: "\(urlStr)")
            request.HTTPMethod = "GET"
            
            if let jsonData = NSData(contentsOfURL: url!) as NSData!{
                searchResult = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
                print(searchResult)
                
                for var i = 0; i < searchResult.count; i++ {
                    is_my_favorite.append(searchResult[i]["is_my_favorite"].int!)
                }
            }
            else{
                searchResult = nil
                //MARK: 검색 결과가 없다는 Alert View 생성
            }
            self.tableView.reloadData()
        }
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTableCell", forIndexPath: indexPath) as! SearchTableViewCell
        
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
        }
        cell.songImageWebView.scalesPageToFit = true
        cell.songImageWebView.userInteractionEnabled = false
        
        cell.songAddButton.userInteractionEnabled = true
        cell.songAddButton.tag = row // 여기에 파라미터 넘기자
        
        if is_my_favorite[row] == 1{ // 내노래 추가된 경우
            cell.songAddButton.setImage(UIImage(named: "AddButtonActive"), forState: .Normal)
            cell.songAddButton.removeTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
            cell.songAddButton.addTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
        } else { // 안된 경우
            cell.songAddButton.removeTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
            cell.songAddButton.setImage(UIImage(named: "AddButtonDeactive"), forState: .Normal)
            cell.songAddButton.addTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
        }
        
//        if searchResult[row]["is_my_favorite"] == true{ // 내노래 추가된 경우
//            if let image = UIImage(named: "AddButtonActive"){
//                cell.songAddButton.setImage(image, forState: .Normal)
//            }
//            cell.songAddButton.addTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
//        } else { // 안된 경우
//            cell.songAddButton.addTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
//        }
        
        // addAction delete Action 은 실행 후 서로 바꿔줘야 한다.
        // ADd Action 은 빨간색으로 delete 는 흰색으로 변경
        //        segmentedController.selectedSegmentIndex == searchType
        
        // Configure the cell...
        return cell
    }
    
    func songAddAction(sender: UIButton!){
        //        print("Button tapped \(sender.tag)")
        if let image = UIImage(named: "AddButtonActive"){
            sender.setImage(image, forState: .Normal)
        }
        
        let post:NSString = "id=\(userInfo.myId)&myList_id=\(userInfo.myListId)&song_id=\(searchResult[sender.tag]["id"])"
        
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
        
        // Add Action 삭제
        sender.removeTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
        is_my_favorite[sender.tag] = 1
        sender.addTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
    }
    
    func songDeleteAction(sender: UIButton!){
//        print("Song Delete Action Start Sender tag is \(sender.tag)")
        
        if let image = UIImage(named: "AddButtonDeactive"){
            sender.setImage(image, forState: .Normal)
        }
        
        let post:NSString = "id=\(userInfo.myId)&song_id=\(searchResult[sender.tag]["id"])"
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
        is_my_favorite[sender.tag] = 0
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
        if segue.identifier == "SongDetailFromTitleSearch" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            if is_my_favorite[row!] == 1{
                detailViewController.currentStatus = true
            } else {
                detailViewController.currentStatus = false
            }
            
            detailViewController.from_where = 0
            detailViewController.row = row
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(searchResult, row: row!, type: 2)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
