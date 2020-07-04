//
//  detailInfoBookmarkViewController.swift
//  JCWang
//
//  Created by JiaCheng on 2020/6/29.
//  Copyright © 2020 JiaCheng. All rights reserved.
//

import UIKit

class DetailInfoBookmarkViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    var correctedTitleFlag = false
    @IBAction func correctTitleAct(_ sender: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        correctedTitleFlag = true
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var myTitle = "标题未知"
    var myDate = "收藏日期："
    var myWebUrl = "书签网址"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "书签信息"
        if self.myTitle == "标题未知" {
            self.titleTextField.text = ""
        } else {
            self.titleTextField.text = self.myTitle
        }
        self.dateLabel.text = self.myDate
        self.websiteLabel.text = self.myWebUrl
        
        let longPressCopyGes = UILongPressGestureRecognizer(target: self, action: #selector(longPressCopyAct(longPressCopyGes:)))
        longPressCopyGes.minimumPressDuration = 1
        self.websiteLabel.addGestureRecognizer(longPressCopyGes)
    }
    
    @objc func longPressCopyAct(longPressCopyGes: UILongPressGestureRecognizer) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = self.websiteLabel.text
        
        let alert = UIAlertController(title: "网址复制成功", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
