//
//  ChatllistTableViewCell.swift
//  FeelWeather
//
//  Created by 김태욱 on 04/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit

class ChatlistTableViewCell: UITableViewCell {

    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
