//
//  SearchContainerViewController.swift
//  Goraebang
//
//  Created by Sohn on 9/18/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class SearchContainerViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    
    @IBAction func searchAction(sender: AnyObject) {
        
        performSegueWithIdentifier("onSearch", sender: self)
        
        // 실제 검색 페이지로 이동할 때
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "onSearch"){
            let OnSearchView = (segue.destinationViewController as! OnSearchContainerViewController)
            print("지금 넘기려는 검색어는 \(searchText.text!)")
            
            OnSearchView.searchTextFromPreviousPage = searchText.text!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
