//
//  Bookmark.swift
//  JCWang
//
//  Created by JiaCheng on 2020/6/25.
//  Copyright © 2020 JiaCheng. All rights reserved.
//

import Foundation

class Bookmark: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.bookmarkLink.absoluteString, forKey: "bookmarkLink")
        coder.encode(self.favorite, forKey: "favorite")
        coder.encode(self.aboutTag, forKey: "aboutTag")
        coder.encode(self.unread, forKey: "unread")
//        coder.encode(self.isShowing, forKey: "unread")
        coder.encode(self.readNum, forKey: "readNum")
        coder.encode(self.numsAttachedBookmark, forKey: "numsAttachedBookmark")
    }
    
    required init?(coder: NSCoder) {
        super.init()
        
        self.title = coder.decodeObject(forKey: "title") as! String
        self.date = coder.decodeObject(forKey: "date") as! String
        self.bookmarkLink = URL(string: ((coder.decodeObject(forKey: "bookmarkLink") as! String)))
        self.favorite = coder.decodeBool(forKey: "favorite")
        self.aboutTag = coder.decodeBool(forKey: "aboutTag")
        self.unread = coder.decodeBool(forKey: "unread")
//        self.isShowing = coder.decodeBool(forKey: "isShowing")
        self.readNum = Int(coder.decodeInt32(forKey: "readNum"))
        self.numsAttachedBookmark = coder.decodeObject(forKey: "numsAttachedBookmark") as! [Int]
    }
    
    var title = "标题未知"
    var date = "xxxx-xx-xx"
    var bookmarkLink: URL!
    //重点收藏1
    var favorite: Bool = false
    //收藏2  有关
    var aboutTag: Bool = false
    //未读标记
    var unread: Bool = true
    
    var isShowing = true
    
    var readNum: Int = 0
    
    //这里面对应的就是亮着的该书签存在的标签
    var numsAttachedBookmark: [Int] = []
    
    init(bookmarkLink: URL) {
        self.bookmarkLink = bookmarkLink
    }
}
