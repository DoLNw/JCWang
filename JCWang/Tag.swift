//
//  Tag.swift
//  JCWang
//
//  Created by JiaCheng on 2020/6/25.
//  Copyright © 2020 JiaCheng. All rights reserved.
//

import Foundation
import UIKit

let maxTagsNum = 12
var noneTag = Tag(color: .darkGray, title: "None")
var existingTags: [Tag] = [Tag(color: .orange, title: "暖文"), Tag(color: .brown, title: "技术"), Tag(color: .red, title: "娱乐")]
class Tag: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(self.color, forKey: "color")
        coder.encode(self.title, forKey: "title")
    }
    
    required init?(coder: NSCoder) {
        self.color = coder.decodeObject(forKey: "color") as! UIColor
        self.title = coder.decodeObject(forKey: "title") as! String
    }
    
    var color: UIColor
    var title: String
        
    init(color: UIColor, title: String) {
        self.color = color
        self.title = title
    }
}
