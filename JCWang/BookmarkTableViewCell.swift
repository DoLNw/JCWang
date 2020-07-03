//
//  BookmarkTableViewCell.swift
//  JCWang
//
//  Created by JiaCheng on 2020/6/18.
//  Copyright © 2020 JiaCheng. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    @IBOutlet weak var favTag: UILabel!
    @IBOutlet weak var aboutTag: UILabel!
    @IBOutlet weak var unreadTag: UILabel!
    @IBOutlet weak var trailingTags: UIStackView!
    @IBOutlet weak var bookmarkLink: UILabel!
    @IBOutlet weak var bookmarkTitle: UILabel!
    @IBOutlet weak var readNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
