//
//  ChatTableViewCell.swift
//  FeelWeather
//
//  Created by 김태욱 on 04/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var myText: UILabel!
    @IBOutlet weak var feelstatusImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var chatText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
