//
//  RecommendTableViewCell.swift
//  Goraebang
//
//  Created by Sohn on 31/10/2016.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class RecommendTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var songCount: UILabel!
    
    @IBOutlet weak var songIndexLabel: UILabel!
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
