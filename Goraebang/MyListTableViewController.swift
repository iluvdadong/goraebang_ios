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
    
    var myListReadableJSON: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyList()
        
        // 테이블 뷰 행 높이 설정
        tableView.rowHeight = 90.0
        
        // table cell gesture recognizer 추가
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getMyList(){
        let url:NSURL = NSURL(string: "http://52.78.101.90/json/song")!
        let jsonData = NSData(contentsOfURL: url) as NSData!
        
        myListReadableJSON = JSON(data: jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
//        print(myListReadableJSON.count)
//        print(myListReadableJSON[0]["jacket"])
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
        print(cell.songImageWebView.frame.size.height)
        cell.songImageWebView.scalesPageToFit = true
        
        // cell gesture recognizer
        
        

        // Configure the cell...

        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowMyListDetails" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            detailViewController.songTitleLabel.title = myListReadableJSON[row!]["title"].string
            detailViewController.artist = "Unknown Artist"
            detailViewController.genre1 = myListReadableJSON[row!]["genre1"].string
            detailViewController.genre2 = myListReadableJSON[row!]["genre2"].string
            detailViewController.highKey = myListReadableJSON[row!]["highkey"].string
            detailViewController.lowKey = myListReadableJSON[row!]["lowkey"].string
            detailViewController.lyrics = myListReadableJSON[row!]["lyrics"].string
            detailViewController.runtime = myListReadableJSON[row!]["runtime"].string
            detailViewController.song_tjnum = myListReadableJSON[row!]["song_tjnum"].string
            var albumImageWebView:UIWebView = UIWebView()
            albumImageWebView.loadRequest(NSURLRequest(URL: NSURL(string: myListReadableJSON[row!]["jacket"].string!)!))
            detailViewController.albumWebView = albumImageWebView
            print(detailViewController.lyrics)
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
    override func tableView(tableView: UITablseView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    

}
