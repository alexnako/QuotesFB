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
    
//    class var sharedInstance : NestedSingleton {
//        struct Static {
//            static let instance : NestedSingleton = NestedSingleton()
//        }
//        return Static.instance
//    }
//    
    
    struct Color {
        
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