//
//  BookmarkTableViewController.swift
//  JCWang
//
//  Created by JiaCheng on 2020/6/18.
//  Copyright © 2020 JiaCheng. All rights reserved.
//

//由于要展示筛选所有、收藏、关于、未标记等。我用了一个tempBookmarks来表示，对这个与myBookmarks对比，加加减减。在fetch中先让tempBookmarks=myBookmarks，然后因为每次修改bookmark会是在点击cell之后，比如点击下面的标签修改标签（只有添加标签的话还好就改一个，删除标签的话，得改好多个的标签），然后点击detail按钮的话只会修改该bookmark的标题信息，这个还是简单的，上述两个点击都会设置currentSelectedCellNum来告诉你是哪一个cell的，所以修改复杂度还可以接受吧

import UIKit
import SafariServices

class BookmarkTableViewController: UITableViewController {
    var myBookmarks = [Bookmark(bookmarkLink: URL(string: "https://dolnw.github.io")!), Bookmark(bookmarkLink: URL(string: "http://www.baidu.com")!)]
    var tempBookmarks = [Bookmark(bookmarkLink: URL(string: "https://dolnw.github.io")!), Bookmark(bookmarkLink: URL(string: "http://www.baidu.com")!)]
    var currentSelectedCellNum = -1
    
    var formerSegment = 0
    var currentSegment = 0
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func switchSegmentAct(_ sender: UISegmentedControl) {
        switch sender.titleForSegment(at: sender.selectedSegmentIndex) {
        case "All":
            var allIndexPaths: [IndexPath] = []
            for (allIndex, myBookmark) in self.myBookmarks.enumerated() {
                if !myBookmark.isShowing {
//                    myBookmark.isShowing = true
                    myBookmarks[allIndex].isShowing = true
                    self.tempBookmarks.insert(myBookmark, at: allIndex)
                    allIndexPaths.append(IndexPath(row: allIndex, section: 0))
                }
            }
            
            self.tableView.insertRows(at: allIndexPaths, with: .automatic)
        case "Favorite":
            var tempCountIndex = 0
//            var toBeaddedPaths: [IndexPath] = []
//            var toBedeletedPaths: [IndexPath] = []
            //此处不reversed是不行的，因为下面remove之后tempIndex还是有那么原始那么大，所以回Index out of range
            //而且先下面remove再下下面insert是不行的，因为下面的remove不能修改bookmark的ishowing位false
//            for (tempIndex, tempBookmark) in self.tempBookmarks.reversed().enumerated() {
//                if !tempBookmark.favorite {
//                    self.tempBookmarks.remove(at: originCount - tempIndex - 1)
//                    unfavIndexPaths.append(IndexPath(row: originCount - tempIndex - 1, section: 0))
//                }
//            }
//
//            self.tableView.deleteRows(at: unfavIndexPaths, with: .automatic)

            for (allIndex, myBookmark) in self.myBookmarks.enumerated() {
                if myBookmark.favorite && myBookmark.isShowing {
                    tempCountIndex += 1
                } else if myBookmark.favorite && !myBookmark.isShowing {
                    myBookmarks[allIndex].isShowing = true
                    self.tempBookmarks.insert(myBookmark, at: tempCountIndex)
                    self.tableView.insertRows(at: [IndexPath(row: tempCountIndex, section: 0)], with: .automatic)
                } else if !myBookmark.favorite && myBookmark.isShowing {
                    myBookmarks[allIndex].isShowing = false
                    self.tempBookmarks.remove(at: tempCountIndex)
                    self.tableView.deleteRows(at: [IndexPath(row: tempCountIndex, section: 0)], with: .automatic)
                }
            }
        case "About":
            var tempCountIndex = 0
            for (allIndex, myBookmark) in self.myBookmarks.enumerated() {
                if myBookmark.aboutTag && myBookmark.isShowing {
                    tempCountIndex += 1
                } else if myBookmark.aboutTag && !myBookmark.isShowing {
                    myBookmarks[allIndex].isShowing = true
                    self.tempBookmarks.insert(myBookmark, at: tempCountIndex)
                    self.tableView.insertRows(at: [IndexPath(row: tempCountIndex, section: 0)], with: .automatic)
                } else if !myBookmark.aboutTag && myBookmark.isShowing {
                    myBookmarks[allIndex].isShowing = false
                    self.tempBookmarks.remove(at: tempCountIndex)
                    self.tableView.deleteRows(at: [IndexPath(row: tempCountIndex, section: 0)], with: .automatic)
                }
            }
        case "Unread":
            var tempCountIndex = 0
            for (allIndex, myBookmark) in self.myBookmarks.enumerated() {
                if myBookmark.unread && myBookmark.isShowing {
                    tempCountIndex += 1
                } else if myBookmark.unread && !myBookmark.isShowing {
                    myBookmarks[allIndex].isShowing = true
                    self.tempBookmarks.insert(myBookmark, at: tempCountIndex)
                    self.tableView.insertRows(at: [IndexPath(row: tempCountIndex, section: 0)], with: .automatic)
                } else if !myBookmark.unread && myBookmark.isShowing {
                    myBookmarks[allIndex].isShowing = false
                    self.tempBookmarks.remove(at: tempCountIndex)
                    self.tableView.deleteRows(at: [IndexPath(row: tempCountIndex, section: 0)], with: .automatic)
                }
            }
        default:
            break
        }
        
        print(sender.titleForSegment(at: sender.selectedSegmentIndex))
        print(sender.selectedSegmentIndex)
    }
    
    @objc func addNewBookmark() {
        //识别剪贴板中的内容
        if let paste = UIPasteboard.general.string {
            if paste.hasPrefix("http://") || paste.hasPrefix("https://") {
                UIPasteboard.general.string = ""
                self.myBookmarks.append(Bookmark(bookmarkLink: URL(string: paste)!))
//                self.myBookmarks.last?.isShowing = true
                self.setBookmarks()
                //如果现在处在unread状态下，那么直接加进来的，否则在另外的三个状态下的话，我都变到第一个状态，这样就能可视化我加进去了这个
                if segmentedControl.selectedSegmentIndex == 3 {
                    self.tempBookmarks.append(Bookmark(bookmarkLink: URL(string: paste)!))
                    self.tableView.insertRows(at: [IndexPath(row: self.tempBookmarks.count-1, section: 0)], with: .automatic)
                } else {
                    segmentedControl.selectedSegmentIndex = 0
                    var allIndexPaths: [IndexPath] = []
                    for (allIndex, myBookmark) in self.myBookmarks.enumerated() {
                        if !myBookmark.isShowing {
                            myBookmarks[allIndex].isShowing = true
                            self.tempBookmarks.insert(myBookmark, at: allIndex)
                            allIndexPaths.append(IndexPath(row: allIndex, section: 0))
                        }
                    }
                    self.tableView.insertRows(at: allIndexPaths, with: .automatic)
                }
                
                let row = self.tableView.numberOfRows(inSection: 0)
                self.tableView.scrollToRow(at: IndexPath(row: row-1, section: 0), at: .bottom, animated: true)
                
                return
            }
        }
        let alert = UIAlertController(title: "粘贴板中无链接可添加", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.add, style: .done, target: self, action: #selector(addNewBookmark
            ))

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        self.setBookmarks()
        
        //fetch读取已经包括了iCloud和user里面的值
        if self.fetchBookmarks() {
            print("fetchBookmarks的首个书签url: \(self.myBookmarks.first?.bookmarkLink.absoluteString ?? "self.myBookmarks.first?.bookmarkLink is nil")")
        } else {
            self.setBookmarks()
        }
        
        if self.fetchTags() {
            print("fetchTags的标签个数: \(existingTags.count)")
        } else {
            self.setTags()
        }
        
        addListener()
        
        for i in 0..<self.myBookmarks.count {
            self.myBookmarks[i].isShowing = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        //识别剪贴板中的内容
        if let paste = UIPasteboard.general.string, (paste.hasPrefix("http://") || paste.hasPrefix("https://")) {
            //如果剪贴板中的内容是链接
            let alert = UIAlertController(title: "是否收藏？", message: paste, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { Void in
                UIPasteboard.general.string = ""
                self.myBookmarks.append(Bookmark(bookmarkLink: URL(string: paste)!))
                self.setBookmarks()
                
                //如果现在处在unread状态下，那么直接加进来的，否则在另外的三个状态下的话，我都变到第一个状态，这样就能可视化我加进去了这个
                if self.segmentedControl.selectedSegmentIndex == 3 {
                    self.tempBookmarks.append(Bookmark(bookmarkLink: URL(string: paste)!))
                    self.tableView.insertRows(at: [IndexPath(row: self.tempBookmarks.count-1, section: 0)], with: .automatic)
                } else {
                    self.segmentedControl.selectedSegmentIndex = 0
                    var allIndexPaths: [IndexPath] = []
                    for (allIndex, myBookmark) in self.myBookmarks.enumerated() {
                        if !myBookmark.isShowing {
                            self.myBookmarks[allIndex].isShowing = true
                            self.tempBookmarks.insert(myBookmark, at: allIndex)
                            allIndexPaths.append(IndexPath(row: allIndex, section: 0))
                        }
                    }
                    self.tableView.insertRows(at: allIndexPaths, with: .automatic)
                }
                
                let row = self.tableView.numberOfRows(inSection: 0)
                self.tableView.scrollToRow(at: IndexPath(row: row-1, section: 0), at: .bottom, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
//            //以下其实应该放在Appdelegate中
//            //弹出Alert
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let vc = storyboard.instantiateViewController(withIdentifier: "navi") as? UINavigationController {
//                self.window?.rootViewController = vc
//                vc.present(alert, animated: true, completion: nil)
//           }
       }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tempBookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkTableViewCell", for: indexPath) as! BookmarkTableViewCell
        
        //这样就能通过cell知道该cell是第几个
        cell.tag = indexPath.row
        
        // Configure the cell...
        let bookmark = self.tempBookmarks[indexPath.row]
        
        cell.bookmarkLink.text = bookmark.bookmarkLink?.absoluteString
        cell.bookmarkTitle.text = bookmark.title
        cell.readNum.text = "\(bookmark.readNum)"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setTrailingTags(tapGesture:)))
        cell.trailingTags.addGestureRecognizer(tapGesture)
        cell.favTag.alpha = bookmark.favorite ? 1 : 0
        cell.aboutTag.alpha = bookmark.aboutTag ? 1 : 0
        cell.unreadTag.alpha = bookmark.unread ? 1 : 0
        
        //删掉一个标签之后，
        var index = 0
        for (ind, num) in bookmark.numsAttachedBookmark.enumerated() {
            //numsAttachedBookmark里面的序号都会是从小到大的，因为遍历button的时候从0到最后的么，有就添加进去，所以大了直接break，而不是continue
            //当然，如果我删除tag后处理的好，这个break理论上是不会出现的
            if num >= existingTags.count {
                bookmark.numsAttachedBookmark.remove(at: ind)
                print("删除tag后，别的书签的tag可能没删除完，出现错误了")
                break
            }
            let tagLabel = cell.trailingTags.subviews[index] as! UILabel
            index += 1
            let tag = existingTags[num]
            tagLabel.backgroundColor = tag.color
            tagLabel.text = tag.title.first?.uppercased()
            tagLabel.isHidden = false
        }
        for i in index..<cell.trailingTags.subviews.count {
            cell.trailingTags.subviews[i].isHidden = true
        }
        
        if bookmark.numsAttachedBookmark.count == 0 {
            let tagLabel = cell.trailingTags.subviews.first as! UILabel
            tagLabel.backgroundColor = noneTag.color
            tagLabel.text = noneTag.title.first?.uppercased()
            tagLabel.isHidden = false
        }
        
        return cell
    }
    
    @objc func setTrailingTags(tapGesture: UITapGestureRecognizer) {
        let cellContentView = tapGesture.view?.superview?.superview as! BookmarkTableViewCell
        //根据cellContentView.tag得知现在是第几个cell
        currentSelectedCellNum = cellContentView.tag
//        let baseLoca = cellContentView.trailingTags.frame.origin
//        let baseBaseLoca = cellContentView.frame.origin
        
        //各个标签view
        let subViews = tapGesture.view!.subviews
//        let subViews = cellContentView.trailingTags.subviews
        
        let tagsiewController = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "tagsViewController") as! TagsViewController
        let label = subViews.last as! UILabel
        tagsiewController.tagFont = label.font
        tagsiewController.tagSize = label.bounds.size
        tagsiewController.cornorRadius = label.layer.cornerRadius
        tagsiewController.cellBookmarkNums = self.tempBookmarks[currentSelectedCellNum].numsAttachedBookmark
        
        //防止模态弹出, 不加是模态弹出
        tagsiewController.modalPresentationStyle = .overFullScreen
//        tagsiewController.hidesBottomBarWhenPushed = true
        self.present(tagsiewController, animated: false)
//        self.show(tagsiewController, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var showIndex = -1
        var resIndexInmyBookmarks = 0
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            resIndexInmyBookmarks = indexPath.row
        case 1:
            for (index, bookmark) in self.myBookmarks.enumerated() {
                if bookmark.favorite {
                    showIndex += 1
                    if showIndex == indexPath.row {
                        resIndexInmyBookmarks = index
                    }
                }
            }
            break
        case 2:
            for (index, bookmark) in self.myBookmarks.enumerated() {
                if bookmark.aboutTag {
                    showIndex += 1
                    if showIndex == indexPath.row {
                        resIndexInmyBookmarks = index
                    }
                }
            }
            break
        case 3:
            for (index, bookmark) in self.myBookmarks.enumerated() {
                if bookmark.aboutTag {
                    showIndex += 1
                    if showIndex == indexPath.row {
                        resIndexInmyBookmarks = index
                    }
                }
            }
            break
        default:
            break
        }
        self.myBookmarks[resIndexInmyBookmarks].readNum += 1
        if self.myBookmarks[resIndexInmyBookmarks].readNum >= 5 {
            self.myBookmarks[resIndexInmyBookmarks].unread = false
        }
        self.setBookmarks()
        
        self.tempBookmarks[indexPath.row].readNum += 1
        self.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        if self.tempBookmarks[indexPath.row].readNum >= 5 {
            self.tempBookmarks[indexPath.row].unread = false
            self.tempBookmarks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.myBookmarks[resIndexInmyBookmarks].isShowing = false
        }
        
        if let url = self.tempBookmarks[indexPath.row].bookmarkLink {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let sfWebviewCon = SFSafariViewController(url: url, configuration: config)
//            sfWebviewCon.delegate = self
//            self.navigationController?.pushViewController(sfWebviewCon, animated: true)
            
            self.present(sfWebviewCon, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
//    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//    }
    //tell the delegate that the user tapped the detail button for the specified row
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let detailInfoBookmarkViewController = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "detailInfoBookmarkViewController") as! DetailInfoBookmarkViewController
        
        self.currentSelectedCellNum = indexPath.row
        let bookmark = self.tempBookmarks[self.currentSelectedCellNum]
        //这样获取下一个vc的UI是不行的，因为还没初始化出来，所以需要先做一个变量进去, 然后下面转场返回是可以从textfield获取数据的
        detailInfoBookmarkViewController.myTitle = bookmark.title
        detailInfoBookmarkViewController.myDate = bookmark.date
        detailInfoBookmarkViewController.myWebUrl = bookmark.bookmarkLink.absoluteString
        
//        detailInfoBookmarkViewController.modalPresentationStyle = .overFullScreen
//        self.present(detailInfoBookmarkViewController, animated: false)
        self.navigationController?.pushViewController(detailInfoBookmarkViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cellInfo = self.tempBookmarks[indexPath.row]
        let cell = self.tableView.cellForRow(at: indexPath) as! BookmarkTableViewCell
        let likeAction = UIContextualAction(style: .normal, title: cellInfo.favorite ? "unfav" : "fav") { (_, _, completion) in
            cellInfo.favorite.toggle()
            
            cell.favTag.alpha = cellInfo.favorite ? 1 : 0
            self.setBookmarks()
            completion(true)
        }
        
        likeAction.backgroundColor = UIColor.orange
        if cellInfo.favorite {
            likeAction.image = UIImage(named: "unfav")
        } else {
            likeAction.image = UIImage(named: "fav")
        }
        
        return UISwipeActionsConfiguration(actions: [likeAction])
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.tempBookmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            var showIndex = -1
            var removedIndexInmyBookmarks = 0
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                removedIndexInmyBookmarks = indexPath.row
            case 1:
                for (index, bookmark) in self.myBookmarks.enumerated() {
                    if bookmark.favorite {
                        showIndex += 1
                        if showIndex == indexPath.row {
                            removedIndexInmyBookmarks = index
                        }
                    }
                }
                break
            case 2:
                for (index, bookmark) in self.myBookmarks.enumerated() {
                    if bookmark.aboutTag {
                        showIndex += 1
                        if showIndex == indexPath.row {
                            removedIndexInmyBookmarks = index
                        }
                    }
                }
                break
            case 3:
                for (index, bookmark) in self.myBookmarks.enumerated() {
                    if bookmark.aboutTag {
                        showIndex += 1
                        if showIndex == indexPath.row {
                            removedIndexInmyBookmarks = index
                        }
                    }
                }
                break
            default:
                break
            }
            
            self.myBookmarks.remove(at: removedIndexInmyBookmarks)
            self.setBookmarks()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    //一返场就存到本地存到iCloud，没有改变啥也存储了，会不会效率低了点？？？
    @IBAction func backToBookmarkTableViewController(segue: UIStoryboardSegue) {
        if let fromVC = segue.source as? TagsViewController {
            let deletingNums = fromVC.deletingTagNums
            
            for deleNum in deletingNums {
                for (index, bookmark) in self.tempBookmarks.enumerated() {
                    //numsAttachedBookmark是由小到大的，因为遍历btns的时候也是有小到大的
                    //这么写应该不对吧，这个应该是值复制吧？
//                    bookmark.numsAttachedBookmark = bookmark.numsAttachedBookmark.map { $0 > deleNum ? $0 - 1 : $0}
                    self.tempBookmarks[index].numsAttachedBookmark = (bookmark.numsAttachedBookmark.filter {return $0 != deleNum}).map { $0 > deleNum ? $0 - 1 : $0}
                }
            }
            self.tempBookmarks[currentSelectedCellNum].numsAttachedBookmark = fromVC.cellBookmarkNums
            
            var showIndex = -1
            var resIndexInmyBookmarks = 0
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                resIndexInmyBookmarks = currentSelectedCellNum
            case 1:
                for (index, bookmark) in self.myBookmarks.enumerated() {
                    if bookmark.favorite {
                        showIndex += 1
                        if showIndex == currentSelectedCellNum {
                            resIndexInmyBookmarks = index
                        }
                    }
                }
                break
            case 2:
                for (index, bookmark) in self.myBookmarks.enumerated() {
                    if bookmark.aboutTag {
                        showIndex += 1
                        if showIndex == currentSelectedCellNum {
                            resIndexInmyBookmarks = index
                        }
                    }
                }
                break
            case 3:
                for (index, bookmark) in self.myBookmarks.enumerated() {
                    if bookmark.aboutTag {
                        showIndex += 1
                        if showIndex == currentSelectedCellNum {
                            resIndexInmyBookmarks = index
                        }
                    }
                }
                break
            default:
                break
            }
            for deleNum in deletingNums {
                for (index, bookmark) in self.myBookmarks.enumerated() {
                    self.myBookmarks[index].numsAttachedBookmark = (bookmark.numsAttachedBookmark.filter {return $0 != deleNum}).map { $0 > deleNum ? $0 - 1 : $0}
                }
            }
            //因为还有添加的标签，所以这一个被添加的需要写在这里
            self.myBookmarks[resIndexInmyBookmarks].numsAttachedBookmark = fromVC.cellBookmarkNums
            self.setBookmarks()
//            print(self.myBookmarks[currentSelectedCell].numsAttachedBookmark)
            self.tableView.reloadData()
        } else if let fromVC = segue.source as? DetailInfoBookmarkViewController {
            if fromVC.correctedTitleFlag {
                //上面accessoryButtonTappedForRowWith进入的时候不可以直接给textfield设置text的，因为UI们还是nil状态的
                self.tempBookmarks[currentSelectedCellNum].title = fromVC.titleTextField.text!
                
                var showIndex = -1
                var resIndexInmyBookmarks = 0
                switch segmentedControl.selectedSegmentIndex {
                case 0:
                    resIndexInmyBookmarks = currentSelectedCellNum
                case 1:
                    for (index, bookmark) in self.myBookmarks.enumerated() {
                        if bookmark.favorite {
                            showIndex += 1
                            if showIndex == currentSelectedCellNum {
                                resIndexInmyBookmarks = index
                            }
                        }
                    }
                    break
                case 2:
                    for (index, bookmark) in self.myBookmarks.enumerated() {
                        if bookmark.aboutTag {
                            showIndex += 1
                            if showIndex == currentSelectedCellNum {
                                resIndexInmyBookmarks = index
                            }
                        }
                    }
                    break
                case 3:
                    for (index, bookmark) in self.myBookmarks.enumerated() {
                        if bookmark.aboutTag {
                            showIndex += 1
                            if showIndex == currentSelectedCellNum {
                                resIndexInmyBookmarks = index
                            }
                        }
                    }
                    break
                default:
                    break
                }
                self.myBookmarks[resIndexInmyBookmarks].title = fromVC.titleTextField.text!
                self.setBookmarks()
                self.tableView.reloadData()
            }
        }
    }
    
    deinit {
        let store = NSUbiquitousKeyValueStore.default
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: store)
    }
}

//
extension BookmarkTableViewController {
    //包括了iCloud和本地的
    func setBookmarks() {
        let user = UserDefaults.standard
        do {
            try user.setValue(NSKeyedArchiver.archivedData(withRootObject: self.myBookmarks, requiringSecureCoding: false), forKey: "bookmarks")
            user.synchronize()
            print("本地存储Bookmarks成功")
        } catch let error {
            print("本地存储Bookmarks失败, error: \(error)")
        }
        
        saveBookmarksToiCloudUsingKeyValueStorage()
    }
    func setBookmarksWithoutCloud() {
        let user = UserDefaults.standard
        do {
            try user.setValue(NSKeyedArchiver.archivedData(withRootObject: self.myBookmarks, requiringSecureCoding: false), forKey: "bookmarks")
            user.synchronize()
            print("本地存储Bookmarks成功")
        } catch let error {
            print("本地存储Bookmarks失败, error: \(error)")
        }
    }
    
    func fetchBookmarks() -> Bool {
        let store = NSUbiquitousKeyValueStore.default
        do {
            if let data = store.object(forKey: "bookmarks") as? Data {
                if let bookmarks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Bookmark] {
                    print("iCloud读取Bookmarks成功")
                    self.myBookmarks = bookmarks
                    self.tempBookmarks = self.myBookmarks
                    return true
                }
            }
        } catch let error {
            print("iCloud读取Bookmarks失败, error: \(error)")
        }
        
        let user = UserDefaults.standard
        do {
            if let data = user.object(forKey: "bookmarks") as? Data {
                if let bookmarks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Bookmark] {
                    print("本地读取Bookmarks成功")
                    self.myBookmarks = bookmarks
                    return true
                }
            }
        } catch let error {
            print("本地读取Bookmarks失败, error: \(error)")
        }
        return false
    }
    
    //包括了iCloud和本地的
    func setTags() {
        let user = UserDefaults.standard
        do {
            try user.setValue(NSKeyedArchiver.archivedData(withRootObject: existingTags, requiringSecureCoding: false), forKey: "existingTags")
            user.synchronize()
            print("本地存储Tags成功")
        } catch let error {
            print("本地存储Tags失败, error: \(error)")
        }
        
        saveTagsToiCloudUsingKeyValueStorage()
    }
    func setTagsWithouCloud() {
        let user = UserDefaults.standard
        do {
            try user.setValue(NSKeyedArchiver.archivedData(withRootObject: existingTags, requiringSecureCoding: false), forKey: "existingTags")
            user.synchronize()
            print("本地存储Tags成功")
        } catch let error {
            print("本地存储Tags失败, error: \(error)")
        }
    }
    
    func fetchTags() -> Bool {
        let store = NSUbiquitousKeyValueStore.default
        do {
            if let data = store.object(forKey: "existingTags") as? Data {
                if let tempExistingTags = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Tag] {
                    print("iCloud读取Tags成功")
                    existingTags = tempExistingTags
                    return true
                }
            }
        } catch let error {
            print("iCloud读取Tags失败, error: \(error)")
        }
        
        let user = UserDefaults.standard
        do {
            if let data = user.object(forKey: "existingTags") as? Data {
                if let tempExistingTags = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Tag] {
                    print("本地读取Tags成功")
                    existingTags = tempExistingTags
                    return true
                }
            }
        } catch let error {
            print("本地读取Tags失败, error: \(error)")
        }
        return false
    }
}

extension BookmarkTableViewController {
    // Save to iCloud
    func saveBookmarksToiCloudUsingKeyValueStorage() {
        let store = NSUbiquitousKeyValueStore.default
        do {
            try store.set(NSKeyedArchiver.archivedData(withRootObject: self.myBookmarks, requiringSecureCoding: false), forKey: "bookmarks")
            print("bookmarks Saving to iCloud")
            store.synchronize()
        } catch let error {
            print("iCloud存储Bookmarks失败, error: \(error)")
        }
    }
    func saveTagsToiCloudUsingKeyValueStorage() {
        let store = NSUbiquitousKeyValueStore.default
        do {
            try store.set(NSKeyedArchiver.archivedData(withRootObject: existingTags, requiringSecureCoding: false), forKey: "existingTags")
            print("existingTags Saving to iCloud")
            store.synchronize()
        } catch let error {
            print("iCloud存储Tags失败, error: \(error)")
        }
    }
    
    func addListener() {
        let store = NSUbiquitousKeyValueStore.default
        NotificationCenter.default.addObserver(self, selector: #selector(updateKeyValuePairs(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: store)
        store.synchronize()
    }
    
    
    @objc func updateKeyValuePairs(notification: NSNotification) {
        print("updateKeyValuePairs")
        let userInfo = notification.userInfo
        let changeReason = userInfo?["NSUbiquitousKeyValueStoreChangeReasonKey"]
        var reason = -1
        if (changeReason == nil) {
            print("failed")
            return
        } else {
            reason = changeReason as! Int
            print("reason is: \(reason)")
        }
        
        if (reason == NSUbiquitousKeyValueStoreServerChange) || (reason == NSUbiquitousKeyValueStoreInitialSyncChange) {
            let changeKeys = userInfo?["NSUbiquitousKeyValueStoreChangedKeysKey"] as! [String]
            let store = NSUbiquitousKeyValueStore.default
            
            for key in changeKeys {
                switch key {
                case "bookmarks":
                    do {
                        if let data = store.object(forKey: "bookmarks") as? Data {
                            if let bookmarks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Bookmark] {
                                self.myBookmarks = bookmarks
                                
                                self.tableView.reloadData()
                                //iCloud更新后我自动读取到，然后我再存回iCloud，有自动读取到，不是循环了么？？？傻啊
                                self.setBookmarksWithoutCloud()
                            }
                        }
                    } catch let error {
                        print("存储失败, error: \(error)")
                    }
                case "existingTags":
                    do {
                        if let data = store.object(forKey: "existingTags") as? Data {
                            if let tempExistingTags = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Tag] {
                                existingTags = tempExistingTags
                                
                                self.tableView.reloadData()
                                self.setTagsWithouCloud()
                            }
                        }
                    } catch let error {
                        print("存储失败, error: \(error)")
                    }
                default:
                    break
                }
            }
        }
    }
}

//extension BookmarkTableViewController: SFSafariViewControllerDelegate {
//    //当用户单击导航栏左边的按钮调用委托回调，在这个调用中，视图控制器被销毁。
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//
//    }
//    //当SFSafariViewController完成加载传递给初始化器的URL时，将调用此方法。它不会在相同的SFSafariViewController实例中调用任何后续页面加载。
//    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
//
//    }
//}
