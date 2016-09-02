//
//  HomeTableViewCell.swift
//  Goraebang
//
//  Created by Sohn on 8/27/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var singerBackground: UIImageView!
    
    @IBOutlet weak var album1: UIWebView!
    @IBOutlet weak var album2: UIWebView!
    @IBOutlet weak var album3: UIWebView!
    
    @IBOutlet weak var mylistTitle: UILabel!
    @IBOutlet weak var mylistContents: UILabel!
    @IBOutlet weak var mylistOwner: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
