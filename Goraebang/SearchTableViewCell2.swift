//
//  SearchTableViewCell2.swift
//  Goraebang
//
//  Created by Sohn on 9/10/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class SearchTableViewCell2: UITableViewCell {
    
    @IBOutlet weak var songNumberLabel: UILabel!
    @IBOutlet weak var songImageWebView: UIWebView!
    @IBOutlet weak var songArtistLabel: UILabel!
    
    @IBOutlet weak var songAddButton: UIButton!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
