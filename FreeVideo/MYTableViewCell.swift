//
//  MYTableViewCell.swift
//  FreeVideo
//
//  Created by 微向暖年未央 on 2018/2/13.
//  Copyright © 2018年 微向暖年未央. All rights reserved.
//

import UIKit

class MYTableViewCell: UITableViewCell {

    @IBOutlet weak var videoProgress: UIProgressView!
    @IBOutlet weak var videoParseName: UILabel!
    @IBOutlet weak var videoTime: UILabel!
    @IBOutlet weak var videoRefresh: UIButton!
    @IBOutlet weak var videoPlayOne: UIButton!
    @IBOutlet weak var videoPlayTwo: UIButton!
    @IBOutlet weak var videoDownLoad: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
