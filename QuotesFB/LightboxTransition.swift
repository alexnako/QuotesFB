//
//  LightboxTransition.swift
//  Quotes
//
//  Created by Alex Nako on 4/27/16.
//  Copyright © 2016 Alex Nako. All rights reserved.
//

import UIKit

class LightboxTransition: BaseTransition {
    
    var overlayView = UIView()
    var cellToScale = UIView()
    var cellContent = QuoteTile()
    var originalCenter = CGPoint()
    var rotationValue = Float()
    var axisX = CGFloat()
    var axisY = CGFloat()
    var bigCell = Bool()
    var scaleCell3D = CGFloat()
    var scaleCell = CGFloat()
    

    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        
        
        let quoteGridController = fromViewController as! HomeController
        let quoteViewController = toViewController as! QuoteController
        quoteViewController.view.alpha = 0
        
        
        cellToScale.frame = quoteGridController.selectedCell
        cellToScale.backgroundColor = UIColor.redColor()
        cellToScale.layer.zPosition = 1000
        originalCenter = cellToScale.center

        cellContent.frame.size = cellToScale.frame.size
        cellContent.frame.origin = CGPoint(x: 0, y: 0)
        cellContent.applyStyleView(quoteViewController.passedStyle)
        cellContent.author.text = quoteViewController.passedQuote.value!["author"] as? String
        cellContent.quote.text = quoteViewController.passedQuote.value!["quote"] as? String


        overlayView.backgroundColor = UIColor.whiteColor()
        overlayView.alpha = 0
        overlayView.frame = fromViewController.view.frame
        fromViewController.view.addSubview(overlayView)
        fromViewController.view.addSubview(cellToScale)
        cellToScale.addSubview(cellContent)
        
        
        
        
//        cellTile.view.frame = quoteGridController.selectedCell
//        print(cellTile)
        
//        fromViewController.view.addSubview(cellTile)
        
                
        quoteGridController.quoteCollection.cellForItemAtIndexPath(quoteGridController.selectedIndex)?.hidden = true
        
        
        rotationValue = Float(abs((cellToScale.frame.center.x - quoteGridController.view.frame.center.x)/4))
        
        if ((cellToScale.frame.center.y - quoteGridController.view.frame.center.y) < 0) {
            axisY = 1
        } else {
            axisY = -1
        }
        if ((cellToScale.frame.center.x - quoteGridController.view.frame.center.x) < 0) {
            axisX = -1
        } else {
            axisX = 1
        }
        
        if (cellToScale.frame.width > quoteGridController.view.frame.width/2) {
            scaleCell = 1
            scaleCell3D = 1.1
            bigCell = true
        } else {
            scaleCell = 2
            scaleCell3D = 1.9
            bigCell = false
        }
        
        
        UIView.animateWithDuration(0.3, delay: 0, options:.CurveEaseIn, animations: {
            
            quoteGridController.quoteCollection.transform = CGAffineTransformMakeScale(0.97, 0.97)
            self.overlayView.alpha = 1
            
            var t = CATransform3DIdentity;
            t.m34 = 1.0 / 500.0;
            let floatValue: CGFloat = self.degreesToRadians(self.rotationValue)
            t =  CATransform3DConcat(CATransform3DMakeScale(self.scaleCell3D, self.scaleCell3D, 1), CATransform3DRotate(t, floatValue, self.axisY, self.axisX, 0))
            self.cellToScale.layer.transform = t;
            self.cellToScale.center = quoteViewController.quoteTile.frame.center
            }, completion: { (Bool) in

                UIView.animateWithDuration(0.4, delay: 0, options:.CurveEaseOut, animations: {
                    
                    self.cellToScale.transform = CGAffineTransformMakeScale(self.scaleCell, self.scaleCell)
                    
                    }, completion: { (Bool) in
                        quoteViewController.view.alpha = 1
                        self.cellToScale.transform = CGAffineTransformMakeScale(1, 1)
                        self.cellToScale.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.finish()
                })
        })
        
        
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {

        let quoteGridController = toViewController as! HomeController
        let quoteViewController = fromViewController as! QuoteController
        
        cellToScale.frame = quoteViewController.quoteTile.frame
        cellToScale.layer.zPosition = 1000

        overlayView.backgroundColor = UIColor.whiteColor()
        overlayView.alpha = 1

        toViewController.view.addSubview(overlayView)
        toViewController.view.addSubview(cellToScale)

        fromViewController.view.alpha = 0
        
        if (bigCell == true){
            scaleCell = 1
        } else {
            scaleCell = 0.5
        }

        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.9, initialSpringVelocity: 20, options:.CurveEaseOut, animations: {
            self.overlayView.alpha = 0
            quoteGridController.quoteCollection.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { (Bool) in
        })
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 20, options:.CurveEaseOut, animations: {
            
            self.cellToScale.center = self.originalCenter
            self.cellToScale.transform = CGAffineTransformMakeScale(self.scaleCell, self.scaleCell)
            
            }, completion: { (Bool) in
                UIView.animateWithDuration(0.2, delay: 0, options:.CurveEaseOut, animations: {

                    }, completion: { (Bool) in
                        quoteGridController.quoteCollection.cellForItemAtIndexPath(quoteGridController.selectedIndex)?.hidden = false
                        self.cellToScale.transform = CGAffineTransformMakeScale(1, 1)
                        self.cellToScale.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.finish()
                })
        })

        

    }
    
    func degreesToRadians(floatValue: Float) -> CGFloat {
        return CGFloat(floatValue) * CGFloat(M_PI) / 180.0
    }

}
