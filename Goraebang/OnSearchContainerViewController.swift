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
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var songTitleSearchContainer: UIView!
    
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
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OnSearchContainerViewController.call) , name: "com.sohn.specialNotificationKey"
        //            , object: nil)
        
        //        searchDelegate = SearchTableViewController()
        //        searchDelegate?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func call(){
        print("Succcess")
        print("Call Succces")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchAction(sender: AnyObject) {
        print("Click Search")
        searchText.resignFirstResponder()
        let serachText = ["searchText":searchText.text!]
        NSNotificationCenter.defaultCenter().postNotificationName("com.sohn.searchByTitleKey", object: self, userInfo: serachText)
        
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
