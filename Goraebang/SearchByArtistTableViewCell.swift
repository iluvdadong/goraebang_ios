//
//  SearchByArtistTableViewCell.swift
//  Goraebang
//
//  Created by Sohn on 22/09/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class SearchByArtistTableViewCell: UITableViewCell {

    
    @IBOutlet weak var songCount: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var songAddButton: UIButton!
    @IBOutlet weak var songNumberLabel: UILabel!
    @IBOutlet weak var songImageWebView: UIWebView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
