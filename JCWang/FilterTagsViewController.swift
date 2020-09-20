//
//  FilterTagsViewController.swift
//  JCWang
//
//  Created by JiaCheng on 2020/9/19.
//  Copyright © 2020 JiaCheng. All rights reserved.
//

import UIKit

class FilterTagsViewController: UIViewController {
    var tagX: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var heightSpace: CGFloat = 0.0
    
    var tagFont = UIFont.systemFont(ofSize: 13)
    var cornorRadius: CGFloat = 9
    var tagSize = CGSize(width: 18, height: 18)
    
    var tempButtons = [UIButton]()
    var tempLabels = [UILabel]()
    var allButton: UIButton!
    var deleteAllButton: UIButton!
    var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        tagX = self.view.bounds.width * 0.2
        viewHeight = self.view.bounds.height * 0.5 / CGFloat(existingTags.count == 1 ?  1 : existingTags.count - 1)
//        //因为这里none也要加进来，所以不会有0个出现
//        viewHeight = self.view.bounds.height * 0.5 / CGFloat(existingTags.count + 1)
        heightSpace = self.view.bounds.height * 0.1
        
        // Do any additional setup after loading the view.
        for (index, tag) in existingTags.enumerated() {
            let button = UIButton(frame: CGRect(origin: CGPoint(x: self.tagX, y: self.heightSpace + self.viewHeight * CGFloat(index)), size: self.tagSize + CGSize(width: 10, height: 8)))
            button.clipsToBounds = true
            button.backgroundColor = tag.isShown ? tag.color : .gray
            button.layer.cornerRadius = self.cornorRadius
            button.titleLabel?.font = self.tagFont
            button.setTitle(tag.title.first?.uppercased(), for: .normal)
            
            button.addTarget(self, action: #selector(self.tapTags), for: .touchUpInside)
            
            self.tempButtons.append(button)
            self.view.addSubview(button)
            
            let label = UILabel(frame: CGRect(origin: CGPoint(x: self.tagX + 35, y: self.heightSpace + self.viewHeight * CGFloat(index)), size: CGSize(width: 100, height: self.tagSize.height + 8)))
            label.backgroundColor = tag.isShown ? tag.color : .gray
            label.textColor = UIColor.white
            label.text = tag.title
            label.textAlignment = .center
            label.font = self.tagFont
            label.alpha = 1
            label.layer.cornerRadius = self.cornorRadius
            label.clipsToBounds = true
                        
            self.tempLabels.append(label)
            self.view.addSubview(label)
        }
        
        //全部显示按钮
        self.allButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.bounds.width * 0.78, y: self.view.bounds.height * 0.3), size: self.tagSize + CGSize(width: 20, height: 12)))
        self.allButton.clipsToBounds = true
        self.allButton.backgroundColor = UIColor.green
        self.allButton.layer.cornerRadius = self.cornorRadius
        self.allButton.titleLabel?.font = self.tagFont
        self.allButton.setTitle("All", for: .normal)
        
        self.allButton.addTarget(self, action: #selector(self.showAllAct(button:)), for: .touchUpInside)
        self.view.addSubview(self.allButton)
        
        //全部不显示按钮
        self.deleteAllButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.bounds.width * 0.78, y: self.view.bounds.height * 0.35), size: self.tagSize + CGSize(width: 20, height: 12)))
        self.deleteAllButton.clipsToBounds = true
        self.deleteAllButton.backgroundColor = UIColor.red
        self.deleteAllButton.layer.cornerRadius = self.cornorRadius
        self.deleteAllButton.titleLabel?.font = self.tagFont
        self.deleteAllButton.setTitle("DeAll", for: .normal)
        
        self.deleteAllButton.addTarget(self, action: #selector(notShowAllAct(button:)), for: .touchUpInside)
        self.view.addSubview(self.deleteAllButton)
    }
    
    @objc func tapTags(button: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
                
        let index = tempButtons.firstIndex(of: button)!
        
        if button.backgroundColor == .gray {
            button.backgroundColor = existingTags[index].color
            self.tempLabels[index].backgroundColor = existingTags[index].color
        } else {
            button.backgroundColor = .gray
            self.tempLabels[index].backgroundColor = .gray
        }
        
        existingTags[index].isShown.toggle()
    }
    
    @objc func showAllAct(button: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        for tag in existingTags {
            tag.isShown = true
        }
        for (index, button) in tempButtons.enumerated() {
            button.backgroundColor = existingTags[index].color
            self.tempLabels[index].backgroundColor = existingTags[index].color
        }
    }
    @objc func notShowAllAct(button: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
                
        for tag in existingTags {
            tag.isShown = false
        }
        for button in tempButtons {
            button.backgroundColor = .gray
        }
        for label in tempLabels {
            label.backgroundColor = .gray
        }
    }
    
    @IBAction func okAct(_ sender: UIButton) {
        //现在的逻辑是点击才会筛选，但是那些tag的isShown属性不点确定还是被改变了的
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
}
