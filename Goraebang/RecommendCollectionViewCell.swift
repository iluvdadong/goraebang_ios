//
//  RecommendCollectionViewCell.swift
//  Goraebang
//
//  Created by Sohn on 03/12/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class RecommendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var phrase: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var tjNumber: UILabel!
    
    // 추가되있는지 안되있는지 나타내는 코드
    var status:Int = 0
    
    @IBAction func ButtonAction(sender: AnyObject) {
        print("Button tapped")
        if status == 0 { // 추가 안되있는 경우
//            addButton.imageView!.image = UIImage(named: "AddButtonActive")
            addButton.setImage(UIImage(named: "AddButtonActive"), forState: .Normal)
            status = 1
        } else {
//            addButton.imageView!.image = UIImage(named: "AddButtonDeactive")
            addButton.setImage(UIImage(named: "AddButtonDeactive"), forState: .Normal)
            status = 0
        }
    }
    
}
