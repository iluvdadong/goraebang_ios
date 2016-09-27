//
//  OnSearchContainerViewController.swift
//  Goraebang
//
//  Created by Sohn on 9/20/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

//protocol OnSearchContainerDelegate: class {
//    func SearchImplemented()
//}

class OnSearchContainerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lyricsButton: UIButton!
    @IBOutlet weak var artistButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var currentLocationLine: UILabel!
    var searchTextFromPreviousPage:String!
    
    // 현재 검색어를 저장해놓는다. 바뀌는 검색어와 비교하기 위해서
    var currentSearchText:String!
    var currentTitleSearchText:String!
    var currentArtistSearchText:String!
    var currentLyricsSearchText:String!
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var titleSearchContainer: UIView!
    @IBOutlet weak var artistSearchContainer: UIView!
    @IBOutlet weak var lyricsSearchContainer: UIView!
    
    var overlayView:UIView!
    var currentPage:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPage = 0
        
        searchText.delegate = self
        
        artistSearchContainer.hidden = true
        lyricsSearchContainer.hidden = true
        // 검색 페이지로 넘어 왔을 때 처음 검색을 위함
        
        searchText.text = searchTextFromPreviousPage
        currentSearchText = searchTextFromPreviousPage
        searchFromPreviousPage()
    }
    
    // 리턴 키로 검색했을 때
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        currentSearchText = searchText.text!
        searchText.resignFirstResponder()
        showByTitle()
        let searchTextParam = ["searchText":searchText.text!]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByTitleKey", object: self, userInfo: searchTextParam)
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchText.endEditing(true)
        
    }
    
    @IBAction func searchEditingBegin(sender: AnyObject) {
        // 테이블 뷰 위에 덮어씌울 뷰 생성
        overlayView = UIView()
        overlayView.frame = CGRect(x: 0, y: 0, width: titleSearchContainer.bounds.width, height: titleSearchContainer.bounds.height)
        overlayView.backgroundColor = UIColor.blackColor() // 투명하게 하고
        overlayView.alpha = 0.2
        if currentPage == 0 {
            titleSearchContainer.addSubview(overlayView)
        } else if currentPage == 1{
            artistSearchContainer.addSubview(overlayView)
        } else {
            lyricsSearchContainer.addSubview(overlayView)
        }
    }
    
    @IBAction func searchEditingDidEnd(sender: AnyObject) {
        overlayView.removeFromSuperview()
    }
    
    
    
    
    @IBAction func songByTitleAction(sender: AnyObject) {
        showByTitle()
    }
    
    @IBAction func songByArtistAction(sender: AnyObject) {
        if currentSearchText != currentArtistSearchText{
            let realSearchText = ["searchText":currentSearchText]
            NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByArtistKey", object: self, userInfo: realSearchText)
        }
        currentArtistSearchText = currentSearchText
        showByArtist()
    }
    
    
    @IBAction func songByLyricsAction(sender: AnyObject) {
        if currentSearchText != currentLyricsSearchText {
            let realSearchText = ["searchText":currentSearchText]
            NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByLyricsKey", object: self, userInfo: realSearchText)
            
            
        }
        currentLyricsSearchText = currentSearchText
        showByLyrics()
    }
    
    func call(){
        print("Succcess")
        print("Call Succces")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchFromPreviousPage(){
        
        let searchTextParam = ["searchText":searchText.text!]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByTitleKey", object: self, userInfo: searchTextParam)
    }
    
    // 검색할 시 무조건 제목 검색으로 넘어와야 한다.
    @IBAction func searchAction(sender: AnyObject) {
        print("Click Search")
        // 현재 검색어를 저장
        currentSearchText = searchText.text!
        searchText.resignFirstResponder()
        showByTitle()
        let searchTextParam = ["searchText":searchText.text!]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByTitleKey", object: self, userInfo: searchTextParam)
        
        //        print(searchDelegate?.searchBarHeight)
        //        searchDelegate?.call()
        //        delegate?.SearchImplemented()
        //        self.call()
        
        
    }
    
    func showByTitle(){
        titleSearchContainer.hidden = false
        artistSearchContainer.hidden = true
        lyricsSearchContainer.hidden = true
        
        currentPage = 0
        let frm: CGRect = currentLocationLine.frame
        let changedLoc: CGRect = titleButton.frame
        currentLocationLine.frame = CGRect(x: changedLoc.minX, y: frm.minY, width: frm.size.width, height: frm.size.height)
    }
    
    func showByArtist(){
        titleSearchContainer.hidden = true
        artistSearchContainer.hidden = false
        lyricsSearchContainer.hidden = true
        currentPage = 1
        
        let frm: CGRect = currentLocationLine.frame
        let changedLoc: CGRect = artistButton.frame
        currentLocationLine.frame = CGRect(x: changedLoc.minX, y: frm.minY, width: frm.size.width, height: frm.size.height)
    }
    
    func showByLyrics(){
        currentPage = 2
        titleSearchContainer.hidden = true
        artistSearchContainer.hidden = true
        lyricsSearchContainer.hidden = false
        
        let frm: CGRect = currentLocationLine.frame
        let changedLoc: CGRect = lyricsButton.frame
        currentLocationLine.frame = CGRect(x: changedLoc.minX, y: frm.minY, width: frm.size.width, height: frm.size.height)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
