//
//  QuoteTileCell.swift
//  QuotesFB
//
//  Created by Alex Nako on 6/13/16.
//  Copyright © 2016 Alex Nako. All rights reserved.
//

import UIKit

class QuoteTileCell: UICollectionViewCell {
    
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var quoteTop: NSLayoutConstraint!
    @IBOutlet weak var quoteLeading: NSLayoutConstraint!
    @IBOutlet weak var quoteTrailing: NSLayoutConstraint!
    @IBOutlet weak var authorTop: NSLayoutConstraint!
    @IBOutlet weak var authorLeading: NSLayoutConstraint!
    @IBOutlet weak var authorTrailing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
//        quote.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        quote.numberOfLines = 0
//        quote.sizeToFit()
//        quote.layoutIfNeeded()
    }
    
}
