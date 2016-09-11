//
//  MyListTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 8/6/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit
import SwiftyJSON


class MyListTableViewController: UITableViewController {
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    
    var myListReadableJSON: JSON!
    var myListSongs: JSON!
    var myLists: JSON!
    
    var userInfo:UserInfoGetter!
    
    override func viewDidAppear(animated: Bool) {
        getMyList()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        userInfo = UserInfoGetter()
        
        getMyList()
//        getMyListSong(userInfo.myListId)
        
        // 테이블 뷰 행 높이 설정
        if(view.bounds.width == 320){
            tableView.rowHeight = 90.0
        } else if(view.bounds.width == 375) {
            tableView.rowHeight = 100.0
        } else {
            tableView.rowHeight = 110.0
        }
        
//        tableView.sectionHeaderHeight = 120
        
        // table cell gesture recognizer 추가
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getMyList(){
        // Mylist read api
        
        let post:NSString = "id=\(userInfo.myListId)"
        let turl:NSURL = NSURL(string: "\(goraebang_url)/json/myList_read")!

        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: turl)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do {
            // NSURLSession.DataTaskWithRequest 로 변경해야한다.
            let myListsJsonData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            
            myLists = JSON(data: myListsJsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        if((myLists) != nil){
            getMyListSong(userInfo.myListId)
        }
    }
    
    func getMyListSong(id: Int){
        let post:NSString = "id=\(userInfo.myId)&myList_id=\(id)"
        
        let url:NSURL = NSURL(string: "\(goraebang_url)/json/mySong_read")!

        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData

        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do {
            // NSURLSession.DataTaskWithRequest 로 변경해야한다.
            let myListsJsonData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            
            print(response)
            myListSongs = JSON(data: myListsJsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // 행의 개수는 JSON을 count한 것과 같다.
        print(myListSongs)
        return myListSongs["song"].count
        //        return myListSongs[0].count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyListTableCell", forIndexPath: indexPath) as! MyListTableViewCell
        
        let row = indexPath.row
        //        cell.songNumberLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.songNumberLabel.font = cell.songNumberLabel.font.fontWithSize(12)
        cell.songNumberLabel.text = String(myListSongs["song"][row]["song_tjnum"])
        //        cell.songTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.songTitleLabel.font = cell.songTitleLabel.font.fontWithSize(12)
        cell.songTitleLabel.text = myListSongs["song"][row]["title"].string
        //        cell.songArtistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.artistLabel.font = cell.artistLabel.font.fontWithSize(12)
        cell.artistLabel.text = myListSongs["artistName"][row].string
        
        
        cell.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: myListSongs["song"][row]["jacket_small"].string!)!))
        cell.albumWebView.scalesPageToFit = true
        cell.albumWebView.userInteractionEnabled = false
        
        
        
        // cell gesture recognizer
        
        // Configure the cell...
        
        return cell
    }
    
    //    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section"
    //    }
    
    // MARK: Section Header
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let userInfoView = UIView()
////        userInfoView.backgroundColor = UIColor.whiteColor()
//        
//        userInfoView.layer.masksToBounds = false
//        userInfoView.layer.shadowOffset = CGSizeMake(0, 3)
//        userInfoView.layer.shadowRadius = 5
//        userInfoView.layer.shadowOpacity = 0.6
//        
//        let userInfoBackground = UIImageView()
//        userInfoBackground.frame = CGRect(x: 0, y: 0, width: 322, height: 120)
//        userInfoBackground.image = UIImage(named: "Park")
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = userInfoBackground.bounds
//        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        userInfoBackground.addSubview(blurEffectView)
//        userInfoView.addSubview(userInfoBackground)
//        
//        
//        let userTitleLabel = UILabel(frame: CGRect(x: 0, y: 70, width: view.bounds.width, height: 20))
//        userTitleLabel.text = "고래"
//        userTitleLabel.textColor = UIColor.whiteColor()
//        userTitleLabel.textAlignment = NSTextAlignment.Center
//        userInfoView.addSubview(userTitleLabel)
//        
//        let userSongCountLabel = UILabel(frame: CGRect(x: 0, y: 90, width: view.bounds.width, height: 20))
//        userSongCountLabel.textColor = UIColor.whiteColor()
////        userSongCountLabel.text = "저장된 곡 개수  \(myListReadableJSON.count)"
//        userSongCountLabel.textAlignment = NSTextAlignment.Center
//        userSongCountLabel.font = userSongCountLabel.font.fontWithSize(12)
//        userInfoView.addSubview(userSongCountLabel)
//        
//        return userInfoView
//    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMyListDetails" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(myListSongs, row: row!, type: 1)
            detailViewController.isMylist = true
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            // json으로 삭제 요청하고
            // mylistReadable json 다시 받은 뒤에 reload dAta
            
            // MARK ****: JSON 파일에 mySong_id가 필요하다. 삭제하려면 *************
            
            let row = indexPath.row
            let post:NSString = "id=\(userInfo.myId)&mySong_id=\(myListSongs["mylistSongId"][row])"
            let url:NSURL = NSURL(string: "\(goraebang_url)/json/mySong_delete")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
//            print(request)
            
            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            
            do {
                // NSURLSession.DataTaskWithRequest 로 변경해야한다.
                let mySongDeleteResult = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
                
                print(response)
                print(mySongDeleteResult)
                let mySongDeleteResultJSON = JSON(data: mySongDeleteResult, options: NSJSONReadingOptions.MutableContainers, error: nil)
                print(mySongDeleteResultJSON)
                
                
            } catch let error as NSError{
                print(error.localizedDescription)
            }

            getMyListSong(userInfo.myListId)
            
            self.tableView.reloadData()
            
        }
    }
    
    //    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    //        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share") { (action:UITableViewRowAction!, indexPath:NSIndexPath) in
    //            print("hello")
    //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //            // Write code here
    //        }
    //
    //        return [shareAction]
    //    }
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
 override func tableView(tableView: UITablseView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */





