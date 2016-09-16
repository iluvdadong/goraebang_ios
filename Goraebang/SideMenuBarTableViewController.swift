//
//  SideMenuBarTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 8/22/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class SideMenuBarTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.sectionHeaderHeight = 120

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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let userInfoView = UIView()
        userInfoView.backgroundColor = UIColor.whiteColor()
        userInfoView.layer.masksToBounds = false
        userInfoView.layer.shadowOffset = CGSizeMake(0, 3)
        userInfoView.layer.shadowRadius = 5
        userInfoView.layer.shadowOpacity = 0.6
        
        let userTitleLabel = UILabel(frame: CGRect(x: 0, y: 70, width: view.bounds.width-40, height: 20))
        userTitleLabel.text = "고래"
        userTitleLabel.textAlignment = NSTextAlignment.Center
        userInfoView.addSubview(userTitleLabel)
        
        let userSongCountLabel = UILabel(frame: CGRect(x: 0, y: 90, width: view.bounds.width-40, height: 20))
        userSongCountLabel.text = "저장된 곡 개수 3"
        userSongCountLabel.textAlignment = NSTextAlignment.Center
        userSongCountLabel.font = userSongCountLabel.font.fontWithSize(12)
        userInfoView.addSubview(userSongCountLabel)
        
        return userInfoView
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
