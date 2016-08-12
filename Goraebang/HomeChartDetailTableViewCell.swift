//
//  HomeChartDetailTableViewCell.swift
//  Goraebang
//
//  Created by Sohn on 8/12/16.
//  Copyright © 2016 Sohn. All rights reserved.
//

import UIKit

class HomeChartDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var songNumberLabel: UILabel!
    @IBOutlet weak var albumWebView: UIWebView!
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
