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

class OnSearchContainerViewController: UIViewController {
    
    var searchTextFromPreviousPage:String!
    
    // 현재 검색어를 저장해놓는다. 바뀌는 검색어와 비교하기 위해서
    var currentSearchText:String!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var titleSearchContainer: UIView!
    @IBOutlet weak var artistSearchContainer: UIView!
    @IBOutlet weak var lyricsSearchContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistSearchContainer.hidden = true
        lyricsSearchContainer.hidden = true
        // 검색 페이지로 넘어 왔을 때 처음 검색을 위함
        
        searchText.text = searchTextFromPreviousPage
        currentSearchText = searchTextFromPreviousPage
        searchFromPreviousPage()
    }
    
    @IBAction func songByTitleAction(sender: AnyObject) {
        showByTitle()
    }
    
    @IBAction func songByArtistAction(sender: AnyObject) {
        let realSearchText = ["searchText":currentSearchText]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByArtistKey", object: self, userInfo: realSearchText)

        showByArtist()
    }
    
    
    @IBAction func songByLyricsAction(sender: AnyObject) {
        let realSearchText = ["searchText":currentSearchText]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByLyricsKey", object: self, userInfo: realSearchText)

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
    }
    
    func showByArtist(){
        titleSearchContainer.hidden = true
        artistSearchContainer.hidden = false
        lyricsSearchContainer.hidden = true
    }
    
    func showByLyrics(){
        titleSearchContainer.hidden = true
        artistSearchContainer.hidden = true
        lyricsSearchContainer.hidden = false
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
