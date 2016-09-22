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
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var titleSearchContainer: UIView!
    
    @IBOutlet weak var artistSearchContainer: UIView!
    
    //    weak var delegate: OnSearchContainerDelegate?
    //    var searchDelegate: SearchTableViewController?
    
    //    func didSearch() {
    //        print("Success")
    //    }
    
    //    func call(){
    //        delegate?.SearchImplemented()
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistSearchContainer.hidden = true
        
        // 검색 페이지로 넘어 왔을 때 처음 검색을 위함
        searchText.text = searchTextFromPreviousPage
        searchFromPreviousPage()
    }
    
    @IBAction func songByTitleAction(sender: AnyObject) {
        titleSearchContainer.hidden = false
        artistSearchContainer.hidden = true
    }
    
    @IBAction func songByArtistAction(sender: AnyObject) {
        let realSearchText = ["searchText":searchText.text!]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByArtistKey", object: self, userInfo: realSearchText)

        titleSearchContainer.hidden = true
        artistSearchContainer.hidden = false
        
    }
    
    
    @IBAction func songByLyricsAction(sender: AnyObject) {
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
        print("검색어 전달받자")
        
        let searchTextParam = ["searchText":searchText.text!]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByTitleKey", object: self, userInfo: searchTextParam)
    }
    
    @IBAction func searchAction(sender: AnyObject) {
        print("Click Search")
        searchText.resignFirstResponder()
        let searchTextParam = ["searchText":searchText.text!]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByTitleKey", object: self, userInfo: searchTextParam)
        
        //        print(searchDelegate?.searchBarHeight)
        //        searchDelegate?.call()
        //        delegate?.SearchImplemented()
        //        self.call()
        
        
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
