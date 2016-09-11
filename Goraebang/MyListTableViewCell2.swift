//
//  MyListTableViewCell2.swift
//  Goraebang
//
//  Created by Sohn on 9/11/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class MyListTableViewCell2: UITableViewCell {

    
    @IBOutlet weak var songAddButton: UIButton!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songNumberLabel: UILabel!
    @IBOutlet weak var songImageWebView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
