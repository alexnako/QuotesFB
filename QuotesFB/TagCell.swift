//
//  TagCell.swift
//  FBtest
//
//  Created by Alex Nako on 6/7/16.
//  Copyright © 2016 Alex Nako. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    var tagSelected: Bool!
    
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var tagNameMaxWidthConstraint: NSLayoutConstraint!
        
    override func awakeFromNib() {
        tagSelected = false
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.layer.cornerRadius = 4
        self.tagNameMaxWidthConstraint.constant = UIScreen.mainScreen().bounds.width - 8 * 2 - 8 * 2
    }
    
//    func toggleSelectedState() {
//        if tagSelected == false {
//            tagSelected = true
//            print("Selected")
//        } else {
//            tagSelected = false
//            print("Deselected")
//        }
//    }
}
