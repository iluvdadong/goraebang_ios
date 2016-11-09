//
//  RecommendTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 31/10/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class RecommendTableViewController: UITableViewController {
    
    var recommender:Recommender!
    var currentTabIndex:Int!
    var needChange:Bool!
    
    @IBOutlet weak var indicator_view: UIView!
    @IBOutlet weak var indicator_board: UIActivityIndicatorView!
    
    
    override func viewDidDisappear(animated: Bool) {
        // 탭 간 이동시에만 사라져야 한다.
        if(currentTabIndex != self.tabBarController?.selectedIndex){
//            self.navigationController?.popViewControllerAnimated(true)
            self.tableView = nil
//            self.tableView.hidden = true
        }
        self.tabBarController?.selectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        needChange = true
        currentTabIndex = self.tabBarController?.selectedIndex
        activateIndicator()
        
        
        if(view.bounds.width == 320){
            tableView.rowHeight = 90.0
        } else if(view.bounds.width == 375) {
            
            tableView.rowHeight = 100.0
        } else {
            tableView.rowHeight = 110.0
        }
        
        recommender = Recommender()
        
//        getRecomSong()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func activateIndicator() {
        indicator_view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
        
        indicator_board.hidden = false
        indicator_view.hidden = false
    }
    
    func deactivateIndicator(){
        indicator_view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0)
        indicator_board.hidden = true
        indicator_view.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if(needChange == true){
            getRecomSong()
        }
        
        needChange = false
    }
    
    func getRecomSong() -> Bool{
        indicator_board.startAnimating()
        recommender.getSongRecommendation()
        print(recommender.recommendedSong)
        indicator_board.stopAnimating()
        deactivateIndicator()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        tableView.reloadData()
        
        
        return true
    }

    // MARK: - Table view data source

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // 행의 개수는 JSON을 count한 것과 같다.
        //        print(myListSongs)
//        return myListSongs["song"].count
        if recommender.recommendedSong != nil{
            return recommender.recommendedSong.count
        } else {
            return 0
        }
        
        //        return myListSongs[0].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecommendTableCell", forIndexPath: indexPath) as! RecommendTableViewCell
        
        let row = indexPath.row
        
        cell.songNumberLabel.font = cell.songNumberLabel.font.fontWithSize(12)
        cell.songNumberLabel.text = String(recommender.recommendedSong[row]["song_tjnum"])
        
        cell.songTitleLabel.font = cell.songTitleLabel.font.fontWithSize(12)
        cell.songTitleLabel.text = recommender.recommendedSong[row]["title"].string
        
        cell.artistLabel.font = cell.artistLabel.font.fontWithSize(12)
        cell.artistLabel.text = recommender.recommendedSong[row].string
        
        cell.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: recommender.recommendedSong[row]["jacket_small"].string!)!))
        cell.albumWebView.scalesPageToFit = true
        cell.albumWebView.userInteractionEnabled = false
        
        cell.songIndexLabel.text = String(row+1)
        // cell gesture recognizer
        
        // Configure the cell...
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SongDetailFromRecommend" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(recommender.recommendedSong, row: row!, type: 2)
            detailViewController.isMylist = false
        }
    }

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
