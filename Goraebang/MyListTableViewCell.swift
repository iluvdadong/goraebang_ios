//
//  MyListTableViewCell.swift
//  Goraebang
//
//  Created by Sohn on 8/6/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class MyListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songNumberLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songAddButton: UIButton!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumWebView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
