//
//  QuoteTile.swift
//  QuotesFB
//
//  Created by Alex Nako on 7/6/16.
//  Copyright © 2016 Alex Nako. All rights reserved.
//

import UIKit

class QuoteTile: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var quoteLeading: NSLayoutConstraint!
    @IBOutlet weak var quoteTrailing: NSLayoutConstraint!
    @IBOutlet weak var quoteTop: NSLayoutConstraint!
    @IBOutlet weak var authorTop: NSLayoutConstraint!
    @IBOutlet weak var authorTrailing: NSLayoutConstraint!
    @IBOutlet weak var authorLeading: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clearColor()
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let nibView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        return nibView
    }
    
}