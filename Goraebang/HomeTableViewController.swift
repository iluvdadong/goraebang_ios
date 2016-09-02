//
//  HomeTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 8/27/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 180.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    // 셀의 개수
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableCell", forIndexPath: indexPath) as! HomeTableViewCell
        
        let row = indexPath.row
        let albumShadowOffset = CGSizeMake(2, -2)
        let albumShadowRadius:CGFloat = 1
        let albumShadowOpacity:Float = 0.4
        let image = UIImage(named: "Park")
        let image2 = UIImage(named: "Bewhy")
        
        if(row%2==0){
//            cell.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 130/255, alpha: 0.7)
            cell.singerBackground.image = image
            cell.singerBackground.layer.zPosition = -1
            cell.album1.hidden = true
            cell.album2.hidden = true
            cell.album3.hidden = true
            cell.mylistOwner.text = "PLAYLIST BY PARK HYO SHIN"
            cell.mylistTitle.text = "야생화"
            cell.mylistOwner.textColor = UIColor.whiteColor()
            cell.mylistTitle.textColor = UIColor.whiteColor()
            cell.mylistContents.textColor = UIColor.whiteColor()
//            cell.mylistTitle.textAlignment = NSTextAlignment.Right
//            cell.mylistOwner.textAlignment = NSTextAlignment.Right
//            cell.mylistContents.textAlignment = NSTextAlignment.Right
            
        }
        else {
            cell.singerBackground.image = image2
            cell.singerBackground.layer.zPosition = -1
            cell.album1.hidden = true
            cell.album2.hidden = true
            cell.album3.hidden = true
            cell.mylistOwner.text = "PLAYLIST BY BEWHY"
            cell.mylistTitle.text = "Bewhy!"
            cell.mylistOwner.textColor = UIColor.blackColor()
            cell.mylistTitle.textColor = UIColor.blackColor()
            cell.mylistContents.textColor = UIColor.blackColor()
            
        }
//        else{
//            cell.backgroundColor = UIColor.init(red: 90/255, green: 160/255, blue: 110/255, alpha: 0.6)
//            cell.album1.loadRequest(NSURLRequest(URL: NSURL(string: "http://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/080/784/293/80784293_1453884534908_1_100x100.JPG")!))
//            cell.album1.frame.size.height = 63.5
//            cell.album1.frame.size.width = 63.5
//            cell.album1.scalesPageToFit = true
//            cell.album1.userInteractionEnabled = false
//            cell.album1.layer.zPosition = 3
//            //shadow
//            cell.album1.layer.masksToBounds = false
//            cell.album1.layer.shadowOffset = albumShadowOffset
//            cell.album1.layer.shadowRadius = albumShadowRadius
//            cell.album1.layer.shadowOpacity = albumShadowOpacity
//            
//            cell.album2.loadRequest(NSURLRequest(URL: NSURL(string: "http://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/080/784/293/80784293_1453884534908_1_100x100.JPG")!))
//            cell.album2.frame.size.height = 63.5
//            cell.album2.frame.size.width = 63.5
//            cell.album2.scalesPageToFit = true
//            cell.album2.userInteractionEnabled = false
//            cell.album2.layer.zPosition = 2
//            //shadow
//            cell.album2.layer.masksToBounds = false
//            cell.album2.layer.shadowOffset = albumShadowOffset
//            cell.album2.layer.shadowRadius = albumShadowRadius
//            cell.album2.layer.shadowOpacity = albumShadowOpacity
//            
//            cell.album3.loadRequest(NSURLRequest(URL: NSURL(string: "http://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/080/784/293/80784293_1453884534908_1_100x100.JPG")!))
//            cell.album3.frame.size.height = 63.5
//            cell.album3.frame.size.width = 63.5
//            cell.album3.scalesPageToFit = true
//            cell.album3.userInteractionEnabled = false
//            cell.album3.layer.zPosition = 1
//            //shadow
//            cell.album3.layer.masksToBounds = false
//            cell.album3.layer.shadowOffset = albumShadowOffset
//            cell.album3.layer.shadowRadius = albumShadowRadius
//            cell.album3.layer.shadowOpacity = albumShadowOpacity
//        }
        
        
    
        
        // Configure the cell...

        return cell
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
