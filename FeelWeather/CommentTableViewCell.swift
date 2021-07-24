//
//  CommentTableViewCell.swift
//  FeelWeather
//
//  Created by 김태욱 on 02/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feelStatus: UIImageView!
    @IBOutlet weak var userName2: UILabel!
    @IBOutlet weak var userComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
