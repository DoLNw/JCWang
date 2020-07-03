//
//  Helper.swift
//  JCWang
//
//  Created by JiaCheng on 2020/6/25.
//  Copyright © 2020 JiaCheng. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

extension UIColor {
    static var favoriteOrange = UIColor.orange
    static var unreadGreen = UIColor.green
    static var aboutBlue = UIColor.blue
    
    static var myColors = [UIColor.WWDCDark, .WWDCYellow, .WWDCGreen, .kangarooColor, .pandaColor, .polarBearColor, .pigColor, .CaliforniaCondorColor, .gooseColor, .monkeyColor]
    
    static var WWDCDark: UIColor {
        return UIColor(red: 0.059, green: 0.075, blue: 0.137, alpha: 1)
    }
    
    static var WWDCYellow: UIColor {
        return UIColor(red: 0.910, green: 0.816, blue: 0.576, alpha: 1)
    }
    
    static var WWDCGreen: UIColor {
        return UIColor(red: 0.153, green: 0.820, blue: 0.631, alpha: 1)
    }
    
    static var pandaColor: UIColor {
        return UIColor(red: 0.258, green: 0.553, blue: 0.161, alpha: 1)
    }
    
    static var kangarooColor: UIColor {
        return UIColor(red: 0.898, green: 0.247, blue: 0.051, alpha: 1)
    }
    
    static var polarBearColor: UIColor {
        return UIColor(red: 0.404, green: 0.631, blue: 0.816, alpha: 1)
    }
    
    static var pigColor: UIColor {
        return UIColor(red: 0.694, green: 0.302, blue: 0.882, alpha: 1)
    }
    
    static var CaliforniaCondorColor: UIColor {
        return UIColor(red: 0.898, green: 0.404, blue: 0.545, alpha: 1)
    }
    
    static var gooseColor: UIColor {
        return UIColor(red: 0.141, green: 0.267, blue: 0.694, alpha: 1)
    }
    
    static var monkeyColor: UIColor {
        return UIColor(red: 0.918, green: 0.537, blue: 0.091, alpha: 1)
    }
    
    static func randomColor() -> UIColor {
        return UIColor(hue: CGFloat.random0_1(), saturation: CGFloat.random0_1(), brightness: CGFloat.random0_1(), alpha: 1)
    }
    
    static let rand = GKShuffledDistribution(lowestValue: 0, highestValue: UIColor.myColors.count - 1)
    static func myRandomColor() -> UIColor {
        return UIColor.myColors[rand.nextInt()]
    }
}

extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}

extension CGSize {
    static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
}

extension CGFloat {
    static func random0_1() -> CGFloat {
        return CGFloat(arc4random()) / 0xFFFFFFFF
    }
}
