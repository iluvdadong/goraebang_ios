//
//  SearchByArtistTableViewController.swift
//  Goraebang
//
//  Created by Sohn on 22/09/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class SearchByArtistTableViewController: UITableViewController{
    
    let goraebang_url = GlobalSetting.getGoraebangURL()
    var searchResult:JSON!
    // Type 0: Title, Type 1: Artist, Type 2: Lyrics
    var searchType:Int!
    
    func searchCall(n:NSNotification){
        let searchText:String = String(n.userInfo!["searchText"]!)
        searchSong(searchText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.showsVerticalScrollIndicator = false
        
        if(view.bounds.width == 320){
            tableView.rowHeight = 100.0
        } else if (view.bounds.width == 375){
            tableView.rowHeight = 110.0
        } else {
            tableView.rowHeight = 120.0
        }
        
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchByArtistTableViewController.searchCall), name: "com.sohn.searchByArtistKey", object: nil)
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
            
            let urlStr = "\(goraebang_url)/json/search_by_artist?query=\(search_text_UTF8!)"
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
            print(searchResult)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchByArtistTableCell", forIndexPath: indexPath) as! SearchByArtistTableViewCell
        
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
        
        // Configure the cell...
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SongDetailFromArtistSearch" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(searchResult, row: row!, type: 4)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
