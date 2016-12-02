//
//  RecommendCollectionViewController.swift
//  Goraebang
//
//  Created by Sohn on 02/12/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MyCell"
private let sectionInsets = UIEdgeInsets(top: 30.0, left: 5, bottom: 50.0, right: 5)
private let sectionInsetsRight = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 50.0, right: 10.0)
private let itemsPerRow: CGFloat = 2

class RecommendCollectionViewController: UICollectionViewController {
    
    
    
    var sampleImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sampleImages = ["Park",
                        "logo",
                        "logo2",
                        "Park",
                        "Park",
                        "Park",
                        "logo",
                        "logo2"]
        
//        UINavigationController* more = self.tabBarController?.moreNavigationController;
        
//        self.tabBarController?.moreNavigationController.navigationBar.tintColor = UIColor.redColor()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        return sampleImages.count
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
        
        let image = UIImage(named: sampleImages[indexPath.row])
        cell.imageView.image = image
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: cell.titleView.bounds.width, height: cell.titleView.bounds.height)
        let color1 = UIColor(white: 0.2, alpha: 0.0).CGColor as CGColorRef
        let color2 = UIColor(white: 0.2, alpha: 0.2).CGColor as CGColorRef
        let color3 = UIColor(white: 0.2, alpha: 0.4).CGColor as CGColorRef
        let color4 = UIColor(white: 0.2, alpha: 0.6).CGColor as CGColorRef
        let color5 = UIColor(white: 0.2, alpha: 0.8).CGColor as CGColorRef
        let color6 = UIColor(white: 0.2, alpha: 1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4, color5, color6]
        gradientLayer.locations = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        gradientLayer.zPosition = -1
        
        cell.status = 0
        cell.titleView.layer.addSublayer(gradientLayer)
        
        // 데이터 입력
//        cell.titleView.backgroundColor = UIColor.redColor()
        return cell
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
        
        let paddingSpace:CGFloat = sectionInsets.left * (itemsPerRow)
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

