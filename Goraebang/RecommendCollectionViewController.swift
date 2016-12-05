//
//  RecommendCollectionViewController.swift
//  Goraebang
//
//  Created by Sohn on 02/12/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

private let color1 = UIColor(white: 0.2, alpha: 0.0).CGColor as CGColorRef
private let color2 = UIColor(white: 0.2, alpha: 0.2).CGColor as CGColorRef
private let color3 = UIColor(white: 0.2, alpha: 0.4).CGColor as CGColorRef
private let color4 = UIColor(white: 0.2, alpha: 0.6).CGColor as CGColorRef
private let color5 = UIColor(white: 0.2, alpha: 0.8).CGColor as CGColorRef
private let color6 = UIColor(white: 0.2, alpha: 1.0).CGColor as CGColorRef


private let reuseIdentifier = "MyCell"
private let sectionInsets = UIEdgeInsets(top: 30.0, left: 10, bottom: 50.0, right: 10)
private let sectionInsetsRight = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 50.0, right: 10.0)
private let itemsPerRow: CGFloat = 2

class RecommendCollectionViewController: UICollectionViewController {
    
    var recommender:Recommender!
    var userInfo = UserInfoGetter()
    let goraebang_url = GlobalSetting.getGoraebangURL()
    var is_my_favorite:[Bool] = [Bool]()
    var gradientLayer:CAGradientLayer!
    
    var sampleImages = [String]()
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func updateIsMyList(n:NSNotification){
        let row = n.userInfo!["row"] as! Int
        let isMyList = n.userInfo!["is_my_list"] as! Bool
        is_my_favorite[row] = isMyList
        collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGradientLayer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecommendTableViewController.updateIsMyList), name: "com.sohn.fromRecommendSongDetail", object: nil)
        recommender = Recommender()
        
        getRecomSong()
        // Register cell classes
//        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    func makeGradientLayer(){
        
    }
    
    func getRecomSong(){
        recommender.getSongRecommendation()
        print(recommender.recommendedSong)
        
        
        for i in 0 ..< recommender.recommendedSong.count{
            is_my_favorite.append(recommender.recommendedSong[i]["is_my_favorite"].bool!)
        }
        
        collectionView?.reloadData()
    }
        
       
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if recommender.recommendedSong != nil {
            return recommender.recommendedSong.count
        } else {
            return 0
        }
        
    }

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//    
//        // Configure the cell
//    
//        return cell
//    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RecommendCollectionViewCell
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1, color2, color3, color4, color5, color6]
        gradientLayer.locations = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        gradientLayer.zPosition = -1
        gradientLayer.frame = CGRect(x: 0, y: 0, width: cell.titleView.bounds.width, height: cell.titleView.bounds.height)
        
        cell.status = 0 // 이거 아마 필요없다.
        cell.titleView.layer.addSublayer(gradientLayer)
        
        cell.tjNumber.text = String(recommender.recommendedSong[indexPath.row]["song_tjnum"])
        cell.songTitle.text = recommender.recommendedSong[indexPath.row]["title"].string
        cell.songArtist.text = recommender.recommendedSong[indexPath.row]["artist_name"].string!
        
        cell.imageView.setImageFromUrl(stringImageUrl: recommender.recommendedSong[indexPath.row]["jacket"].string!)
        
        
        cell.addButton.tag = indexPath.row
        
        if is_my_favorite[indexPath.row] == true { // 내노래 추가된 경우
            cell.addButton.setImage(UIImage(named: "AddButtonActive"), forState: .Normal)
            cell.addButton.removeTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
            cell.addButton.addTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
        } else { // 안된 경우
            cell.addButton.removeTarget(self, action: #selector(songDeleteAction), forControlEvents: .TouchUpInside)
            cell.addButton.setImage(UIImage(named: "AddButtonDeactive"), forState: .Normal)
            cell.addButton.addTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
        }
//        cell.songCount 추가해야한다.
        
        
        // 데이터 입력
//        cell.titleView.backgroundColor = UIColor.redColor()
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("RecommendCollectionDetail", sender: cell)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RecommendCollectionDetail" {
            assert(sender as? UICollectionViewCell != nil, "sender is not a collection view")
            
            let detailViewController = segue.destinationViewController as! MyListDetailViewController
            
            let myIndexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            let row = myIndexPath!.row
            
            detailViewController.row = row
            detailViewController.songInfo = Song()
            detailViewController.songInfo.set(recommender.recommendedSong, row: row, type:2)
            detailViewController.isMylist = false
            detailViewController.from_where = 4
            detailViewController.currentStatus = is_my_favorite[row]
        
        }
    }
    
//    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
//        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RecommendCollectionViewCell
//        
//        let image = UIImage(named: sampleImages[indexPath.row])
//        cell.imageView.image = image
//        return cell
//    }
    
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension RecommendCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let paddingSpace:CGFloat = sectionInsets.left * (itemsPerRow+1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let widthPerHeight:CGFloat = widthPerItem + 30
        let cardSize = CGSize(width: widthPerItem, height: widthPerHeight)

        return cardSize
    }
    
    func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return sectionInsets.left
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
}

extension RecommendCollectionViewController {
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
                print("노래 추가 완료")
//                alertWithWarningMessage("추가되었습니다")
            }
            
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
        // Add Action 삭제
        sender.removeTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
        is_my_favorite[sender.tag] = true
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
        is_my_favorite[sender.tag] = false
        sender.addTarget(self, action: #selector(songAddAction), forControlEvents: .TouchUpInside)
    }
}

extension UIImageView{
    func setImageFromUrl(stringImageUrl url: String){
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOfURL: url) {
                self.image = UIImage(data: data)
            }
        }
    }
}

