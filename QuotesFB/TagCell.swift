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
        self.backgroundColor = Styles.Color.Palette.graywash
        self.tagName.textColor = Styles.Color.Palette.blue
        self.layer.cornerRadius = self.frame.height/2
        self.tagNameMaxWidthConstraint.constant = UIScreen.mainScreen().bounds.width - 8 * 2 - 8 * 2
    }
    
    func toggleSelectedState() {
        if tagSelected == false {
            tagSelected = true
            self.backgroundColor = Styles.Color.Palette.blue
            self.tagName.textColor = Styles.Color.Palette.white
        } else {
            tagSelected = false
            self.backgroundColor = Styles.Color.Palette.graywash
            self.tagName.textColor = Styles.Color.Palette.blue
        }
    }
}
