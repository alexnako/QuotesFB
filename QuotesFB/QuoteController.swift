//
//  QuoteController.swift
//  QuotesFB
//
//  Created by Alex Nako on 7/1/16.
//  Copyright © 2016 Alex Nako. All rights reserved.
//

import UIKit
import Firebase
import Social


class QuoteController: UIViewController {

    @IBOutlet weak var quoteTile: QuoteTile!
    var passedQuote: FIRDataSnapshot!
    var passedStyle = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteTile.quote.text = passedQuote.value!["quote"] as? String
        quoteTile.author.text = passedQuote.value!["author"] as? String
        quoteTile.applyStyleView(passedStyle)

    }
    
    
    @IBAction func shareQuote(sender: AnyObject) {
        UIGraphicsBeginImageContextWithOptions(quoteTile.bounds.size, true, 0)
        quoteTile.drawViewHierarchyInRect(quoteTile.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        var sharingItem = [AnyObject]()
        sharingItem.append(image)
        sharingItem.append("Some text")
//        sharingItems.append(url)

        let activityViewController = UIActivityViewController(activityItems: sharingItem, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)

        
        
        
//        // TWITTER
//        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//        
//        // FACEBOOK
//        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//        vc.setInitialText("Look at this great picture!")
//        vc.addImage(UIImage(named: "myImage.jpg")!)
//        vc.addURL(NSURL(string: "https://www.hackingwithswift.com"))
//        presentViewController(vc, animated: true, completion: nil)
        
        
        

//        let textToShare = "Swift is awesome!  Check out this website about it!"
//        
//        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
//            let objectsToShare = [textToShare, myWebsite]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            
//            activityVC.popoverPresentationController?.sourceView = sender as! UIView
//            self.presentViewController(activityVC, animated: true, completion: nil)
//        }
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressButton(sender: AnyObject) {
        
    }

    @IBAction func didPressClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
