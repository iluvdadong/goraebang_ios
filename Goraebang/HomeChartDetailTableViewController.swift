//
//  HomeChartDetailTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 8/12/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit


class HomeChartDetailTableViewController: UITableViewController {
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    // MARK : JSON 읽을 JSON 변수
    var topChartReadableJSON: JSON!
    var userInfo: UserInfoGetter!
    var currentTabIndex:Int!
    
    // 푸시된 창에서 다른 탭으로 넘어갈 경우 사라지는 코드
    override func viewDidDisappear(animated: Bool) {
        // 탭 간 이동시에만 사라져야 한다.
        if(currentTabIndex != self.tabBarController?.selectedIndex){
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        self.tabBarController?.selectedIndex
    }
    override func viewDidAppear(animated: Bool) {
        currentTabIndex = self.tabBarController?.selectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = UserInfoGetter()
        currentTabIndex = self.tabBarController?.selectedIndex
        
        if(self.view.bounds.width == 320){
            tableView.rowHeight = 100.0
        } else if (self.view.bounds.width == 375){
            tableView.rowHeight = 110.0
        } else {
            tableView.rowHeight = 120.0
        }
        
        
        getTopChart()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getTopChart(){
        // Top 100 read
        let url:NSURL = NSURL(string: "\(goraebang_url)/json/top100")!
        let jsonData = NSData(contentsOfURL: url) as NSData!
        
        topChartReadableJSON = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
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
        return topChartReadableJSON.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopChartTableCell", forIndexPath: indexPath) as! HomeChartDetailTableViewCell
        
        let row = indexPath.row
        cell.rankLabel.text = String(row+1)
        //        cell.songNumberLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        //        cell.songNumberLabel.font = cell.songNumberLabel.font.fontWithSize(12)
        cell.songNumberLabel.text = String(topChartReadableJSON[row]["song_tjnum"])
        //        cell.songTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        //        cell.songTitleLabel.font = cell.songTitleLabel.font.fontWithSize(12)
        cell.songTitleLabel.text = topChartReadableJSON[row]["title"].string
        print(topChartReadableJSON[row]["title"].string)
        print(cell.songTitleLabel.text)
        //        cell.songArtistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        //        cell.artistLabel.font = cell.artistLabel.font.fontWithSize(12)
        if (topChartReadableJSON[row]["artist_name"] != nil){
            cell.artistLabel.text = topChartReadableJSON[row]["artist_name"].string!// artist명 추가
        }
        
        
        // MARK: jacket_middle 맞는지 확인
        if (topChartReadableJSON[row]["jacket_small"] != nil ){
            cell.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: topChartReadableJSON[row]["jacket_small"].string!)!))
        }
        else {
            cell.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: topChartReadableJSON[0]["jacket_small"].string!)!))
//            cell.albumWebView.loadRequest(NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: topChartReadableJSON[0]["jacket_small"].string!)!))
//            cell.albumWebView.loadRequest(NSURLRequest()
        }

        cell.albumWebView.scalesPageToFit = true
        cell.albumWebView.userInteractionEnabled = false
        
        cell.songAddButton.userInteractionEnabled = true
        cell.songAddButton.tag = topChartReadableJSON[row]["id"].int! // 여기에 파라미터 넘기자
        cell.songAddButton.addTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func songAddAction(sender: UIButton!){
//        print("Button tapped \(sender.tag)")
        
        let post:NSString = "id=\(userInfo.myId)&myList_id=\(userInfo.myListId)&song_id=\(sender.tag)"
        
        let url:NSURL = NSURL(string: "\(goraebang_url)/json/mySong_create")!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do {
            // NSURLSession.DataTaskWithRequest 로 변경해야한다.=
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
        if segue.identifier == "ShowSongDetailFromChart" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(topChartReadableJSON, row: row!, type: 0)
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Block") { (action:UITableViewRowAction!, indexPath:NSIndexPath) in
            print("hello \(tableView.tag)")
            //            tableView.endEditing(true)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            //            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            self.addBlack(indexPath.row)
            //            tableView.deselectRowAtIndexPath([indexPath], animated: .Fade)
            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // Write code here
        }
        
        return [shareAction]
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func addBlack(index: Int){
        print("Black 할 아이디= \(topChartReadableJSON[index]["id"])")
        
        let post:NSString = "id=1&song_id=\(topChartReadableJSON[index]["id"])"
        let url:NSURL = NSURL(string: "\(goraebang_url)/json/blacklist_song_create")!
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        let blackResult = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if let data = data where error == nil{
                print(data)
            } else{
                print("error = \(error.debugDescription)")
            }
        }
        
        blackResult.resume()
        
    }
    
    //    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if (editingStyle == UITableViewCellEditingStyle.None) {
    //            // handle delete (by removing the data from your array and updating the tableview)
    //        }
    //    }
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
