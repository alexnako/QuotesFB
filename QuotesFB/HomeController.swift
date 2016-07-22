//
//  ViewController.swift
//  FBtest
//
//  Created by Alex Nako on 5/19/16.
//  Copyright © 2016 Alex Nako. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class HomeController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var ref = FIRDatabaseReference.init()
    var items = [FIRDataSnapshot]()
    var selectedItem = FIRDataSnapshot()

    var tags = [String]()
    var filteredTags = [String]()
    var quoteStyle = [String]()
    var selectedStyle = String()
    var selectedTag: String!
    var selectedCell: CGRect!
    var selectedIndex: NSIndexPath!

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tagCollection: UICollectionView!
    @IBOutlet weak var quoteCollection: UICollectionView!
    
    @IBOutlet weak var tagDrawer: UIView!
    @IBOutlet weak var tagDrawerHeight: NSLayoutConstraint!
    
    var sizingCell: TagCell?
    var quoteCell: QuoteTileCell?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var inset:CGFloat!
    
    
    var zoomTransition: ZoomTransition!


    override func viewDidLoad() {
        super.viewDidLoad()
        zoomTransition = ZoomTransition()

        // FIREBASE
        ref = FIRDatabase.database().reference()

        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        inset = 2
        
        tagDrawer.frame.size.height = 64
        tagDrawer.clipsToBounds = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)


        searchField.delegate = self
        tagCollection.dataSource = self
        tagCollection.delegate = self
        quoteCollection.delegate = self
        quoteCollection.dataSource = self
        
        // REGISTERING TAGCELL.XIB AS NIB
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.tagCollection.registerNib(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.sizingCell = (cellNib.instantiateWithOwner(nil, options: nil) as NSArray).firstObject as! TagCell?
        self.tagCollection.backgroundColor = UIColor.clearColor()
        
        // REGISTERING QUOTETILECELL AS NIB
        let cellNib2 = UINib(nibName: "QuoteTileCell", bundle: nil)
        self.quoteCollection.registerNib(cellNib2, forCellWithReuseIdentifier: "QuoteTileCell")
        self.quoteCollection.backgroundColor = UIColor.clearColor()
        
        // ADJUSTING QUOTE COLLECTION LAYOUT
        let layout = quoteCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(screenSize.width - inset/2, screenSize.width - inset/2)
        layout.minimumInteritemSpacing = inset
        layout.minimumLineSpacing = inset
        layout.sectionInset = UIEdgeInsetsMake(inset, 0, inset, 0) // overall table inset

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        allQuotes()
        tagsFetch()
    }

    // COLLECTION COUNT
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == tagCollection) {
            return filteredTags.count
        } else  {
            return items.count
        }
    }
    
    // COLLECTION CELL
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (collectionView == tagCollection) {
            let cell = tagCollection.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as! TagCell
            cell.tagName.text = filteredTags[indexPath.row]
            return cell
        } else {
            
            let cell = quoteCollection.dequeueReusableCellWithReuseIdentifier("QuoteTileCell", forIndexPath: indexPath) as! QuoteTileCell
            cell.quote.text = items[indexPath.row].value!["quote"] as? String
            cell.author.text = items[indexPath.row].value!["author"] as? String
            cell.backgroundColor = UIColor.redColor()
            cell.clipsToBounds = true
            cell.layoutSubviews()
            cell.quote.preferredMaxLayoutWidth = cell.quote.frame.width
            
            cell.applyStyle(quoteStyle[indexPath.row])
            return cell
        }
    }
    

    // COLLECTION CELL SIZE
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (collectionView == tagCollection) {
            self.configureTag(self.sizingCell!, forIndexPath: indexPath)
            return self.sizingCell!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        } else {
            if indexPath.row == 0
            {
                return CGSize(width: screenWidth, height: screenWidth)
            }
            return CGSize(width: screenSize.width*0.5 - inset/2, height: screenSize.width*0.5 - inset/2);
        }
    }
    
    // TAG CELL CONFIG
    func configureTag(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = filteredTags[indexPath.row]
        cell.tagName.text = tag
    }


    
    // CELL PRESS
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == quoteCollection) {
            UIView.animateWithDuration(0.1, delay: 0, options:.CurveEaseInOut, animations: {
                    self.quoteCollection.cellForItemAtIndexPath(indexPath)!.transform = CGAffineTransformMakeScale(0.97, 0.97)
                }, completion: { (Bool) in
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == quoteCollection) {
            UIView.animateWithDuration(0.1, delay: 0, options:.CurveEaseInOut, animations: {
                self.quoteCollection.cellForItemAtIndexPath(indexPath)!.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: { (Bool) in
            })
        }
    }
    
    // CELL SELECT
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // TAG
        if (collectionView == tagCollection) {
            for item in 0 ..< collectionView.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TagCell
                cell?.tagSelected = true
                cell?.toggleSelectedState()
            }
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TagCell {
                if (filteredTags[indexPath.row] != selectedTag || selectedTag == nil) {
                    selectedTag = filteredTags[indexPath.row]
                    filteredTagQuotes()
                } else {
                    cell.tagSelected = true
                    selectedTag = nil
                    allQuotes()
                }
                cell.toggleSelectedState()            
            }
            
        //QUOTE
        } else {
            selectedItem = items[indexPath.row]
            selectedStyle = quoteStyle[indexPath.row]
            let rect = self.quoteCollection.cellForItemAtIndexPath(indexPath)!.frame
            selectedCell = self.quoteCollection.convertRect(rect, toView: self.quoteCollection.superview)
            selectedIndex = indexPath
            performSegueWithIdentifier("quoteSelect", sender: self)
        }
    }

    // TAG CELL UNSELECT
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == tagCollection) {
            print("deselect")
            allQuotes()
        }
    }
    
    // FETCH ALL TAGS AND CREATE ARRAY FOR FLOW COLLECTION
    func tagsFetch () {
        ref.child("tags").observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
            for item in snapshot.children {
                self.tags.append(item.key as String)
            }
            self.filteredTags = self.tags
            self.tagCollection.reloadData()
            }, withCancelBlock: { error in
                print(error.description)
        })
    }

    // TAG SEARCH
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            filteredTags = tags
            tagCollection.reloadData()
            return false
        }
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).stringByReplacingCharactersInRange(range, withString: string) as NSString
        if newString.length > 3 {
            filteredTags = tags.filter { $0.containsString(newString as String) }
            if filteredTags.isEmpty {
            
            } else {
                tagCollection.reloadData()
            }
        }
        if newString.length < 1 {
            filteredTags = tags
            tagCollection.reloadData()
        }
        return true
    }
    
    // SHOW/HIDE KEYBOARD
    func keyboardWillShow(notification: NSNotification!) {
        self.tagDrawerHeight.constant = 200
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    func keyboardWillHide(notification: NSNotification!) {
        self.tagDrawerHeight.constant = 64
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // FETCH ALL QUOTES
    func allQuotes () {
        self.items.removeAll()
        ref.child("quotes").removeAllObservers()
        ref.child("quotes").observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
            for item in snapshot.children {
                self.items.append(item as! FIRDataSnapshot)
                self.quoteStyle.append(Styles.Color.variant.randomItem())
            }
            if self.items.isEmpty {
            } else {
            self.quoteCollection.reloadData()
            }
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }

    // FILTER QUOTES BY AUTHOR
    func filteredAuthorQuotes (author: String) {
        ref.child("quotes").queryOrderedByChild(author).queryEqualToValue("A. A. Milne").observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in

            for item in snapshot.children {
                self.items.append(item as! FIRDataSnapshot)
            }
            self.quoteCollection.reloadData()
            }, withCancelBlock: { error in
                print(error.description)
        })
    }

    // FILTER QUOTES BY TAGS
    func filteredTagQuotes () {
        self.items.removeAll()
        ref.child("quotes").removeAllObservers()
        ref.child("quotes").queryOrderedByChild("tags/\(selectedTag)").queryEqualToValue(true).observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
            self.items.removeAll()

            for item in snapshot.children {
                self.items.append(item as! FIRDataSnapshot)
            }
            
            self.quoteCollection.reloadData()

            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // SENDING QUOTE INFO TO QUOTE CONTROLLER
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationViewControler = segue.destinationViewController as! QuoteController
        destinationViewControler.passedQuote = selectedItem
        destinationViewControler.passedStyle = selectedStyle
        
        destinationViewControler.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewControler.transitioningDelegate = zoomTransition
        
    }

}

