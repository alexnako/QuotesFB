//
//  FlowLayout.swift
//  TagFlowLayout
//
//  Created by Diep Nguyen Hoang on 7/30/15.
//  Copyright (c) 2015 CodenTrick. All rights reserved.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {
    
    // SET SCROLL TO HORIZONTAL
    override init(){
        super.init()
        scrollDirection = .Horizontal
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.scrollDirection = .Horizontal
    }
    
    // SET VARIABLES: Content height/width and layout attributes
    private var contentWidth: CGFloat  = 0.0
    private var contentHeight: CGFloat  = 90
    private var cache = [UICollectionViewLayoutAttributes]()
    
    
    override func prepareLayout() {
        super.prepareLayout()
        
        cache.removeAll()
        
        // RUNS ONLY ONCE
        if cache.isEmpty {
            var row = 0
            let numberOfRows = 2
            var rowWidth = [CGFloat](count: numberOfRows, repeatedValue: 0)
            var xOffset = [CGFloat](count: numberOfRows, repeatedValue: 0)
            
            let rowHeight = contentHeight / CGFloat(numberOfRows)
            var yOffset = [CGFloat]()
            for row in 0 ..< numberOfRows {
                yOffset.append(CGFloat(row) * rowHeight)
            }
            
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let tag = super.layoutAttributesForItemAtIndexPath(indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                
                attributes.frame = tag!.frame
                attributes.frame.origin.x = xOffset[row]
                attributes.frame.origin.y = yOffset[row]
                cache.append(attributes)
                
                rowWidth[row] = rowWidth[row] + tag!.frame.size.width + 8
                xOffset[row] = xOffset[row] + tag!.frame.size.width + 8
                let otherRow = row >= (numberOfRows - 1) ? 0 : 1
                if rowWidth[row] > rowWidth[otherRow]{
                    row = row >= (numberOfRows - 1) ? 0 : 1
                }
            }
            contentWidth = rowWidth.maxElement()!
        }
    }
    
    // SETS DYNAMIC WIDTH BASED ON TAGS
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // UPDATES CELL ATTRIBUTES
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes  in cache {
            if CGRectIntersectsRect(attributes.frame, rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    
}