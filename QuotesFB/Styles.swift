//
//  Styles.swift
//  QuotesFB
//
//  Created by Alex Nako on 6/14/16.
//  Copyright © 2016 Alex Nako. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class Styles {
    
    
    struct Color {
        static let variant = ["yellow", "orange"]
        
        struct Palette {
            static let yellow = UIColor(rgba: "#F8E71C")
            static let orange = UIColor(rgba: "#F7923B")
            static let purple = UIColor(rgba: "#9E63AA")
            static let graywash = UIColor(rgba: "#F0F0F0")
            static let graymid = UIColor(rgba: "#9B9B9B")
            static let blue = UIColor(rgba: "#4A90E2")
            static let white = UIColor(rgba: "#FFFFFF")
        }


        struct Tags {
            static let tint = UIColor(rgba: "#4D5152")
        }

        struct CategoryTable {
            static let cellLight = UIColor(rgba: "#FFEDB4")
            static let cellDark = UIColor(rgba: "#F2B236")
            static let imageBorder = UIColor(rgba: "#FDFCFA")
        }
    }

}


extension UIView {
    func applyStyle(name: String) {
        
        let cell = self as! QuoteTileCell
        let unitSize = self.frame.width
        
        cell.authorTop.constant = unitSize * 0.1
        cell.authorLeading.constant = unitSize * 0.1
        cell.authorTrailing.constant = unitSize * 0.1
        cell.quoteTop.constant = unitSize * 0.1
        cell.quoteLeading.constant = unitSize * 0.1
        cell.quoteTrailing.constant = unitSize * 0.1
        
        if (name == "yellow") {
            cell.quote.textColor = Styles.Color.Palette.blue
            cell.quote.font = UIFont(name: "Avenir-Light", size: unitSize * 0.07)
            cell.author.font = UIFont(name: "Avenir-Light", size: unitSize * 0.07)
            cell.backgroundColor = Styles.Color.Palette.yellow
            
        } else if (name == "orange") {
            cell.quote.textColor = Styles.Color.Palette.white
            cell.quote.font = UIFont(name: "Avenir-Light", size: unitSize * 0.07)
            cell.author.font = UIFont(name: "Avenir-Light", size: unitSize * 0.07)
            cell.backgroundColor = Styles.Color.Palette.orange
        }
    }
    
    func applyStyleView(name: String) {
        
        let cell = self as! QuoteTile
        let unitSize = self.frame.width
        
        cell.authorTop.constant = unitSize * 0.1
        cell.authorLeading.constant = unitSize * 0.1
        cell.authorTrailing.constant = unitSize * 0.1
        cell.quoteTop.constant = unitSize * 0.1
        cell.quoteLeading.constant = unitSize * 0.1
        cell.quoteTrailing.constant = unitSize * 0.1

        if (name == "yellow") {
            cell.quote.textColor = Styles.Color.Palette.blue
            cell.quote.font = UIFont(name: "Avenir-Light", size: unitSize * 0.07)
            cell.author.font = UIFont(name: "Avenir-Light", size: unitSize * 0.07)
            cell.backgroundColor = Styles.Color.Palette.yellow
            
        } else if (name == "orange") {
            cell.quote.textColor = Styles.Color.Palette.white
            cell.quote.font = UIFont(name: "Avenir-Light", size: unitSize * 0.07)
            cell.author.font = UIFont(name: "Avenir-Light", size: unitSize * 0.07)
            cell.backgroundColor = Styles.Color.Palette.orange
        }
    }}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension CGRect {
    var center : CGPoint {
        return CGPointMake(self.midX, self.midY)
    }
}