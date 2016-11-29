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
    
    var userInfo = UserInfoGetter()
    let goraebang_url = GlobalSetting.getGoraebangURL()
    var is_my_favorite:[Int] = [Int]()
    
    @IBOutlet weak var indicator_view: UIView!
    @IBOutlet weak var indicator_board: UIActivityIndicatorView!
    
//    @IBAction func recommendAction(sender: AnyObject) {
//        print("Recommend Button was clicked")
////        let semaphore = dispatch_semaphore_create(0);
//        is_my_favorite.removeAll()
////        self.tableView = nil
//        let isComplete = activateIndicator()
//        
//        if isComplete == true {
//            getRecomSong()
//        }
////        dispatch_semaphore_signal(semaphore);
////        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
////        getRecomSong()
//    }
//    
    
    override func viewDidDisappear(animated: Bool) {
        // 탭 간 이동시에만 사라져야 한다.
        if(currentTabIndex != self.tabBarController?.selectedIndex){
//            self.navigationController?.popViewControllerAnimated(true)
            self.tableView = nil
            is_my_favorite.removeAll()
            
//            self.tableView.hidden = true
        }
        self.tabBarController?.selectedIndex
    }
    
    func updateIsMyList(n:NSNotification){
        let row = n.userInfo!["row"] as! Int
        let isMyList = n.userInfo!["is_my_list"] as! Int
        is_my_favorite[row] = isMyList
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        needChange = true
        currentTabIndex = self.tabBarController?.selectedIndex
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecommendTableViewController.updateIsMyList), name: "com.sohn.fromRecommendSongDetail", object: nil)
        
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
    
    func activateIndicator(){
        tableView.hidden = true
        indicator_view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
        indicator_board.hidden = false
        indicator_view.hidden = false
    }
    
    func deactivateIndicator(){
        tableView.hidden = false
        indicator_view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0)
        indicator_board.hidden = true
        indicator_view.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        activateIndicator()
        indicator_board.startAnimating()
        
        if(needChange == true){
            getRecomSong()
        }
        
        needChange = false
    }
    
    func getRecomSong() -> Bool{
        
        
        recommender.getSongRecommendation()
        
        indicator_board.stopAnimating()
        deactivateIndicator()
        
        print("추천곡")
        print(recommender.recommendedSong)
        // 아래 여백 삭제 코드
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        
        // 추천 페이지는 처음에 전부 0 일 수 밖에 없다.
        for var i = 0; i < recommender.recommendedSong.count; i++ {
            is_my_favorite.append(0)
        }
        
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
        cell.artistLabel.text = recommender.recommendedSong[row]["artist_name"].string!
        
        cell.songCount.text = String(recommender.recommendedSong[row]["mylist_count"])
        cell.releaseDate.text = recommender.recommendedSong[row]["release"].string!
        
        cell.albumWebView.loadRequest(NSURLRequest(URL: NSURL(string: recommender.recommendedSong[row]["jacket_small"].string!)!))
        cell.albumWebView.scalesPageToFit = true
        cell.albumWebView.userInteractionEnabled = false
        
        cell.songIndexLabel.text = String(row+1)
        
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

        // cell gesture recognizer
        
        // Configure the cell...
        
        return cell
    }
    
    func songAddAction(sender: UIButton!){
        if let image = UIImage(named: "AddButtonActive"){
            sender.setImage(image, forState: .Normal)
        }
        
        let row = sender.tag
        let post:NSString = "id=\(userInfo.myId)&myList_id=\(userInfo.myListId)&song_id=\(recommender.recommendedSong[sender.tag]["id"].int!)"
        
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
        print("Song Delete Action Start Sender tag is \(sender.tag)")
        
        if let image = UIImage(named: "AddButtonDeactive"){
            sender.setImage(image, forState: .Normal)
        }
        
        let post:NSString = "id=\(userInfo.myId)&song_id=\(recommender.recommendedSong[sender.tag]["id"])"
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SongDetailFromRecommend" {
            let detailViewController =  segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            if is_my_favorite[row!] == 1{
                detailViewController.currentStatus = true
            } else {
                detailViewController.currentStatus = false
            }
            
            detailViewController.row = row
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(recommender.recommendedSong, row: row!, type: 2)
            detailViewController.isMylist = false
            detailViewController.from_where = 4
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
