//
//  MainTableViewCell.swift
//  FeelWeather
//
//  Created by 김태욱 on 01/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feelstatus: UIImageView!
    @IBOutlet weak var introduce: UILabel!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
