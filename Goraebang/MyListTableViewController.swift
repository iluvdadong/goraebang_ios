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
    
    let tmpMyListId = 1
    let tmpUserId = 2
    var myListReadableJSON: JSON!
    var myListSongs: JSON!
    var myLists: JSON!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getMyList()
        
        // 테이블 뷰 행 높이 설정
        tableView.rowHeight = 90.0
        tableView.sectionHeaderHeight = 120
        
        // table cell gesture recognizer 추가
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getMyList(){
        // Mylist read api
        
        let post:NSString = "id=\(tmpUserId)"
        
        //        let post:NSString = "id=\(tmpUserId)&user[name]=sohn&user[password]=\(password)&user[password_confirmation]=\(confirm_password)&user[gender]=0"
        
        let turl:NSURL = NSURL(string: "http://52.78.113.43/json/myList_read")!
        print("Watch Here\n\n\n")
        print(turl)
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: turl)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        //            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        //            request.setValue("application/x-www-0form-urlencoded", forHTTPHeaderField: "Content-Type")
        //            request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print(request)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do {
            // NSURLSession.DataTaskWithRequest 로 변경해야한다.
            let myListsJsonData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            
            print(response)
            
            
            myLists = JSON(data: myListsJsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        if((myLists) != nil){
            print("watch this shit")
            print(myLists)
            print(myLists[0]["id"]) // 내 리스트의 아이디 출력
            getMyListSong(1)
        }
        
        
        // 마이리스트 내부 노래 read
        
        
        //            var responseError: NSError?
        //            var response: NSURLResponse?
        
        //        let mySession = NSURLSession.sharedSession()
        //
        //        // NSURLDataSessionTask Retrun 한다
        //        let task = mySession.dataTaskWithRequest(request){
        //            (let data, let response, let error) in
        //
        //            guard let _:NSData = data, let _: NSURLResponse = response where error == nil else{
        //                print("error")
        //                return
        //            }
        //
        //            self.myLists = JSON(data: data!)
        //            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //            print(dataString)
        //            print(self.myLists)
        //        }
        //
        //        task.resume()
        
        // Top 100 read
        let url:NSURL = NSURL(string: "http://52.78.113.43/json/song")!
        let jsonData = NSData(contentsOfURL: url) as NSData!
        
        myListReadableJSON = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        
        //        print(myListReadableJSON[0]["lyrics"])
        //        print(myListReadableJSON.count)
        //        print(myListReadableJSON[0]["jacket"])
    }
    
    func getMyListSong(id: Int){
        let post:NSString = "id=\(tmpUserId)&myList_id=\(id)"
        
        let url:NSURL = NSURL(string: "http://52.78.113.43/json/mySong_read")!
        print("Watch Here\n")
        print(url)
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        print(request)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do {
            // NSURLSession.DataTaskWithRequest 로 변경해야한다.
            let myListsJsonData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            
            print(response)
            myListSongs = JSON(data: myListsJsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        print("Print my list songs")
        print(myListSongs)
        
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
        return myListReadableJSON.count
        //        return myListSongs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyListTableCell", forIndexPath: indexPath) as! MyListTableViewCell
        
        let row = indexPath.row
        //        cell.songNumberLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.songNumberLabel.font = cell.songNumberLabel.font.fontWithSize(12)
        cell.songNumberLabel.text = String(myListReadableJSON[row]["song_tjnum"])
        //        cell.songTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.songTitleLabel.font = cell.songTitleLabel.font.fontWithSize(12)
        cell.songTitleLabel.text = myListReadableJSON[row]["title"].string
        //        cell.songArtistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.songArtistLabel.font = cell.songArtistLabel.font.fontWithSize(12)
        cell.songArtistLabel.text = "Unkown Artist"
        
        
        cell.songImageWebView.loadRequest(NSURLRequest(URL: NSURL(string: myListReadableJSON[row]["jacket"].string!)!))
        cell.songImageWebView.frame.size.height = 63.5
        cell.songImageWebView.frame.size.width = 63.5
        cell.songImageWebView.scalesPageToFit = true
        cell.songImageWebView.userInteractionEnabled = false
        
        // cell gesture recognizer
        
        
        
        // Configure the cell...
        
        return cell
    }
    
    //    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section"
    //    }
    
    // MARK: Section Header
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let userInfoView = UIView()
        userInfoView.backgroundColor = UIColor.whiteColor()
        userInfoView.layer.masksToBounds = false
        userInfoView.layer.shadowOffset = CGSizeMake(0, 3)
        userInfoView.layer.shadowRadius = 5
        userInfoView.layer.shadowOpacity = 0.6
        
        let userTitleLabel = UILabel(frame: CGRect(x: 0, y: 70, width: view.bounds.width, height: 20))
        userTitleLabel.text = "고래"
        userTitleLabel.textAlignment = NSTextAlignment.Center
        userInfoView.addSubview(userTitleLabel)
        
        let userSongCountLabel = UILabel(frame: CGRect(x: 0, y: 90, width: view.bounds.width, height: 20))
        userSongCountLabel.text = "저장된 곡 개수  \(myListReadableJSON.count)"
        userSongCountLabel.textAlignment = NSTextAlignment.Center
        userSongCountLabel.font = userSongCountLabel.font.fontWithSize(12)
        userInfoView.addSubview(userSongCountLabel)
        
        return userInfoView
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMyListDetails" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(myListReadableJSON, row: row!)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            // json으로 삭제 요청하고
            // mylistReadable json 다시 받은 뒤에 reload dAta
            
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





