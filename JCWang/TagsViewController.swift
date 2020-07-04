//
//  TagsViewController.swift
//  JCWang
//
//  Created by JiaCheng on 2020/6/25.
//  Copyright © 2020 JiaCheng. All rights reserved.
//

//user添加一个，又马上删掉一个，我数组中添加的tagnums怎么整？好像可以的还是，因为existing中的一直加进去，然后最后才删除的
//user在一个cell中点进来，删除了一个tag，那么其它cell中有这个tag的就还没有删除，需要删除的

import UIKit

class TagsViewController: UIViewController {
    var deletingTagNums: [Int] = []
    var deletingBtns: [UIButton] = []
    var deletinglabs: [UILabel] = []
    
    var tagX: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var heightSpace: CGFloat = 0.0
    
    @IBOutlet weak var newTagTextField: UITextField!
    @IBOutlet weak var addSureBtn: UIButton!
    var isDeleting = false
    @IBOutlet weak var deTagBtn: UIButton!
    @IBAction func deTagSureAction(_ sender: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        isDeleting = false
        sender.isHidden = true
    }
    
    @objc func longPressAction(longPressGesture: UILongPressGestureRecognizer) {
        switch longPressGesture.state {
        case .began:
            if !isDeleting {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                
                isDeleting = true
                deTagBtn.isHidden = false
                
                //抖动效果
            } else {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
                
                isDeleting = false
                deTagBtn.isHidden = true
            }
        default:
            break
        }
        
    }
    
    @IBAction func addSureAction(_ sender: UIButton) {
        if  self.tempButtons.count >= maxTagsNum {
            let alert = UIAlertController(title: "抱歉", message: "目前只支持最多12个标签", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        self.newTagTextField.resignFirstResponder()
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
//        self.addButton.backgroundColor = .green
//        self.addButton.setTitle("+", for: .normal)

        let newTag = Tag(color: UIColor.myRandomColor(), title: newTagTextField.text!)
        existingTags.append(newTag)
        self.setTags()
        newTagTextField.text = ""
        
        let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.bounds.width * 1.2, y: self.view.bounds.height * 0.3), size: self.tagSize + CGSize(width: 10, height: 8)))
        button.clipsToBounds = true
        button.backgroundColor = newTag.color
        button.layer.cornerRadius = self.cornorRadius
        button.titleLabel?.font = self.tagFont
        button.setTitle(newTag.title.first?.uppercased(), for: .normal)
        button.addTarget(self, action: #selector(self.tapTags), for: .touchUpInside)
        self.view.addSubview(button)
        
        //因为这个button是我在后面再添加进去的
        //时刻注意除以0的情况
        viewHeight = self.view.bounds.height * 0.5 / CGFloat(self.tempButtons.count == 0 ?  1 : self.tempButtons.count)
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: tagX + 35, y: heightSpace + viewHeight * CGFloat(self.tempButtons.count)), size: CGSize(width: 100, height: self.tagSize.height + 8)))
        label.backgroundColor = newTag.color
        label.textColor = UIColor.white
        label.text = newTag.title
        label.textAlignment = .center
        label.font = self.tagFont
        label.alpha = 0
        label.layer.cornerRadius = self.cornorRadius
        label.clipsToBounds = true
        label.transform = CGAffineTransform(translationX: -35, y: 0)
        self.tempLabels.append(label)
        self.view.addSubview(label)
        
        UIView.animate(withDuration: 1.2, delay: 0.3, usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            button.frame.origin = CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(self.tempButtons.count))
        }) { (_) in
            UIView.animate(withDuration: 0.5) {
                label.alpha = 1
                label.transform = .identity
            }
        }
        
        for (index, btn) in tempButtons.enumerated() {
            UIView.animate(withDuration: 1.2, delay: TimeInterval(CGFloat(self.tempButtons.count - index - 1) * 0.1 + 0.3), usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                btn.frame.origin = CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(index))
                self.tempLabels[index].frame.origin = CGPoint(x: self.tagX + 35, y: self.heightSpace + self.viewHeight * CGFloat(index))
            }, completion: nil)
        }
        
        self.tempButtons.append(button)
        
//        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//            self.newTagTextField.transform = CGAffineTransform(translationX: 200, y: 0)
//        }, completion: nil)
//        UIView.animate(withDuration: 1.2, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//            self.addSureBtn.transform = CGAffineTransform(translationX: 200, y: 0)
//        }, completion: nil)
    }
    
    
    var tagFont: UIFont!
    var cornorRadius: CGFloat = 0.0
    var tagSize = CGSize.zero
    var cellBookmarkNums: [Int] = []
    
    var addButton: UIButton!
    var tempButtons: [UIButton] = []
    var tempLabels: [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.alpha = 0
        
        deTagBtn.isHidden = true
        
        tagX = self.view.bounds.width * 0.2
        viewHeight = self.view.bounds.height * 0.5 / CGFloat(existingTags.count == 1 ?  1 : existingTags.count - 1)
        heightSpace = self.view.bounds.height * 0.1
        // Do any additional setup after loading the view.
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleAction(doubleGesture:) ))
//        doubleTap.numberOfTapsRequired = 2
//        self.view.addGestureRecognizer(doubleTap)
        
        let pressTap = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(longPressGesture:)))
        pressTap.minimumPressDuration = 0.8
        self.view.addGestureRecognizer(pressTap)
        
        let screenEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanAction(screenEdgePanGesture:)))
        screenEdgePan.edges = .left
        self.view.addGestureRecognizer(screenEdgePan)
        
        self.newTagTextField.transform = CGAffineTransform(translationX: 200, y: 0)
        self.addSureBtn.transform = CGAffineTransform(translationX: 200, y: 0)
    }
    
    @objc func screenEdgePanAction(screenEdgePanGesture: UIScreenEdgePanGestureRecognizer) {
        switch screenEdgePanGesture.state {
        case .began:
            if isDeleting {
                if self.deletingTagNums.count > 0 {
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                    
                    let num = self.deletingTagNums.removeLast()
                    self.deletingBtns.last?.isHidden = false
                    self.deletinglabs.last?.isHidden = false
                    self.tempButtons.insert(self.deletingBtns.removeLast(), at: num)
                    self.tempLabels.insert(self.deletinglabs.removeLast(), at: num)
                    
                    viewHeight = self.view.bounds.height * 0.5 / CGFloat(self.tempButtons.count == 1 ?  1 : self.tempButtons.count - 1)
                    
                    for index in 0..<num {
                        let btn = self.tempButtons[index]
                        UIView.animate(withDuration: 1.2, delay: TimeInterval(CGFloat(num - index - 1) * 0.1), usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                            btn.frame.origin = CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(index))
                            self.tempLabels[index].frame.origin = CGPoint(x: self.tagX + 35, y: self.heightSpace + self.viewHeight * CGFloat(index))
                        }, completion: nil)
                    }
                    for index in num..<self.tempButtons.count {
                        let btn = self.tempButtons[index]
                        UIView.animate(withDuration: 1.2, delay: TimeInterval(CGFloat(index - num) * 0.1), usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                            btn.frame.origin = CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(index))
                            self.tempLabels[index].frame.origin = CGPoint(x: self.tagX + 35, y: self.heightSpace + self.viewHeight * CGFloat(index))
                        }, completion: nil)
                    }
                    
//                    for (index, btn) in tempButtons.enumerated() {
//                        if index > num {
//                            UIView.animate(withDuration: 1.2, delay: TimeInterval(CGFloat(index - num - 1) * 0.1), usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
//                                btn.frame.origin = CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(index))
//                                self.tempLabels[index].frame.origin = CGPoint(x: self.tagX + 35, y: self.heightSpace + self.viewHeight * CGFloat(index))
//                            }, completion: nil)
//                        }
//                    }
                } else {
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.view.alpha = 0
                    }) { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.alpha = 0
                }) { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
            }
        default:
            break
        }
    }
    
//    @objc func doubleAction(doubleGesture: UITapGestureRecognizer) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    //注意先调用了BookmarkTableViewController的backToBookmarkTableViewController(segue: UIStoryboardSegue)然后再调用下面的viewWillDisappear, 所以此处写在viewwilldisappear无效
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        for (index, btn) in self.tempButtons.enumerated() {
//            if btn.backgroundColor == .gray {
//                self.bookmarkTags.append(Tag(tag: index + 1, color: btn.backgroundColor!, title: self.tempLabels[index].text!))
//            }
//        }
//
//        let generator = UISelectionFeedbackGenerator()
//        generator.selectionChanged()
//
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.alpha = 0
//        }) { (_) in
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    @IBAction func backAction(_ sender: UIButton) {
        
        for index in self.deletingTagNums {
            existingTags.remove(at: index)
        }
        self.setTags()
        self.cellBookmarkNums.removeAll(keepingCapacity: true)
        
        for btn in self.tempButtons {
            if !(btn.backgroundColor == .gray) {
                self.cellBookmarkNums.append(tempButtons.firstIndex(of: btn)!)
            }
        }
//        print(self.cellBookmarkNums)
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0
        }) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //在ViewDidLoad里面下面的动画无效
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.view.alpha = 1
        }) { [unowned self] (_) in
            for (index, tag) in existingTags.enumerated() {
                let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.bounds.width * 1.2, y: self.view.bounds.height * 0.3), size: self.tagSize + CGSize(width: 10, height: 8)))
                button.clipsToBounds = true
                button.backgroundColor = self.cellBookmarkNums.contains(index) ? tag.color : .gray
                button.layer.cornerRadius = self.cornorRadius
                button.titleLabel?.font = self.tagFont
                button.setTitle(tag.title.first?.uppercased(), for: .normal)
                
                button.addTarget(self, action: #selector(self.tapTags), for: .touchUpInside)
                
                self.view.addSubview(button)
                self.tempButtons.append(button)
                
                let label = UILabel(frame: CGRect(origin: CGPoint(x: self.tagX + 35, y: self.heightSpace + self.viewHeight * CGFloat(index)), size: CGSize(width: 100, height: self.tagSize.height + 8)))
                label.backgroundColor = self.cellBookmarkNums.contains(index) ? tag.color : .gray
                label.textColor = UIColor.white
                label.text = tag.title
                label.textAlignment = .center
                label.font = self.tagFont
                label.alpha = 0
                label.layer.cornerRadius = self.cornorRadius
                label.clipsToBounds = true
                
                label.transform = CGAffineTransform(translationX: -35, y: 0)
                
                self.tempLabels.append(label)
                self.view.addSubview(label)
                
                UIView.animate(withDuration: 1.2, delay: TimeInterval(CGFloat(index) * 0.1), usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    button.frame.origin = CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(index))
//                    button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                })  { (_) in
                    UIView.animate(withDuration: 0.5) {
                        label.alpha = 1
                        label.transform = .identity
                    }
                }
            }
            
            //添加按钮
            self.addButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.bounds.width * 1.2, y: self.view.bounds.height * 0.3), size: self.tagSize + CGSize(width: 10, height: 8)))
            self.addButton.clipsToBounds = true
            self.addButton.backgroundColor = UIColor.green
            self.addButton.layer.cornerRadius = self.cornorRadius
            self.addButton.titleLabel?.font = self.tagFont
            self.addButton.setTitle("十", for: .normal)
            
            self.addButton.addTarget(self, action: #selector(self.addTag(button:)), for: .touchUpInside)
            self.view.addSubview(self.addButton)
            
            UIView.animate(withDuration: 1.2, delay: TimeInterval(CGFloat(existingTags.count) * 0.1), usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.addButton.frame.origin = CGPoint(x: self.view.bounds.width * 0.78, y: self.view.bounds.height * 0.3)
//                self.addButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }, completion: nil)
        }
    }
    
    @objc func tapTags(button: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        if isDeleting {
            let num = self.tempButtons.firstIndex(of: button)!
            self.tempButtons[num].isHidden = true
            self.tempLabels[num].isHidden = true
            
            self.deletingBtns.append(self.tempButtons[num])
            self.deletinglabs.append(self.tempLabels[num])
            self.deletingTagNums.append(num)
            
            self.tempButtons.remove(at: num)
            self.tempLabels.remove(at: num)
            
            viewHeight = self.view.bounds.height * 0.5 / CGFloat(self.tempButtons.count == 1 ?  1 : self.tempButtons.count - 1)
            
            for index in 0..<num {
                let btn = self.tempButtons[index]
                UIView.animate(withDuration: 1.2, delay: TimeInterval(CGFloat(num - index - 1) * 0.1), usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    btn.frame.origin = CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(index))
                    self.tempLabels[index].frame.origin = CGPoint(x: self.tagX + 35, y: self.heightSpace + self.viewHeight * CGFloat(index))
                }, completion: nil)
            }
            for index in num..<self.tempButtons.count {
                let btn = self.tempButtons[index]
                UIView.animate(withDuration: 1.2, delay: TimeInterval(CGFloat(index - num) * 0.1), usingSpringWithDamping: 0.55, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    btn.frame.origin = CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(index))
                    self.tempLabels[index].frame.origin = CGPoint(x: self.tagX + 35, y: self.heightSpace + self.viewHeight * CGFloat(index))
                }, completion: nil)
            }
        } else {
            if button.backgroundColor == .gray {
                let index = tempButtons.firstIndex(of: button)!
                button.backgroundColor = existingTags[index].color
                self.tempLabels[index].backgroundColor = existingTags[index].color
            } else {
                let index = tempButtons.firstIndex(of: button)!
                button.backgroundColor = .gray
                self.tempLabels[index].backgroundColor = .gray
            }
        }
    }
    @objc func addTag(button: UIButton) {
        self.newTagTextField.resignFirstResponder()
        if self.addButton.backgroundColor == .red {
            self.addButton.backgroundColor = .green
            self.addButton.setTitle("+", for: .normal)
            
            UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.newTagTextField.transform = CGAffineTransform(translationX: 200, y: 0)
            }, completion: nil)
            UIView.animate(withDuration: 1.2, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.addSureBtn.transform = CGAffineTransform(translationX: 200, y: 0)
            }, completion: nil)
        } else if self.addButton.backgroundColor == .green {
            self.addButton.backgroundColor = .red
            self.addButton.setTitle("-", for: .normal)
            
            UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.newTagTextField.transform = .identity
            }, completion: nil)
            UIView.animate(withDuration: 1.2, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.addSureBtn.transform = .identity
            }, completion: nil)
        }
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

extension TagsViewController {
    func setTags() {
        let user = UserDefaults.standard
        do {
            try user.setValue(NSKeyedArchiver.archivedData(withRootObject: existingTags, requiringSecureCoding: false), forKey: "existingTags")
            print("本地存储Tags成功")
            user.synchronize()
        } catch let error {
            print("本地存储Tags失败, error: \(error)")
        }
        
        saveTagsToiCloudUsingKeyValueStorage()
    }
}

extension TagsViewController {
    func saveTagsToiCloudUsingKeyValueStorage() {
        let store = NSUbiquitousKeyValueStore.default
        do {
            try store.set(NSKeyedArchiver.archivedData(withRootObject: existingTags, requiringSecureCoding: false), forKey: "existingTags")
            print("existingTags Saving to iCloud")
            store.synchronize()
        } catch let error {
            print("本地存储Tags失败, error: \(error)")
        }
    }
}
