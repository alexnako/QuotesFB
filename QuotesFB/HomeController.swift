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
    var tags = [String]()
    var filteredTags = [String]()

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tagCollection: UICollectionView!
    @IBOutlet weak var quoteCollection: UICollectionView!
    
    var sizingCell: TagCell?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var inset:CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIREBASE
        ref = FIRDatabase.database().reference()

        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        inset = screenWidth*0.1 / 2

        searchField.delegate = self
        tagCollection.dataSource = self
        tagCollection.delegate = self
        quoteCollection.delegate = self
        quoteCollection.dataSource = self
        
        // REGISTERING TAGCELL.XIB AS NIB
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.tagCollection.registerNib(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.tagCollection.backgroundColor = UIColor.clearColor()
        self.sizingCell = (cellNib.instantiateWithOwner(nil, options: nil) as NSArray).firstObject as! TagCell?
        
        // REGISTERING QUOTETILECELL AS NIB
        let cellNib2 = UINib(nibName: "QuoteTileCell", bundle: nil)
        self.quoteCollection.registerNib(cellNib2, forCellWithReuseIdentifier: "QuoteTileCell")
        self.quoteCollection.backgroundColor = UIColor.clearColor()
        
        // ADJUSTING QUOTE COLLECTION LAYOUT
        let layout = quoteCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(screenSize.width*0.45 - inset/2, screenSize.width*0.45 - inset/2)
        layout.minimumInteritemSpacing = inset
        layout.minimumLineSpacing = inset
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset) // overall table inset

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
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.whiteColor()
            cell.selectedBackgroundView = bgColorView
            return cell
        
        } else {
            let cell = quoteCollection.dequeueReusableCellWithReuseIdentifier("QuoteTileCell", forIndexPath: indexPath) as! QuoteTileCell
            cell.quote.text = items[indexPath.row].value!["quote"] as? String
            cell.author.text = items[indexPath.row].value!["author"] as? String
            cell.backgroundColor = UIColor.redColor()
            return cell
        }
    }
    
    // COLLECTION CELL SIZE
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (collectionView == tagCollection) {
            self.configureCell(self.sizingCell!, forIndexPath: indexPath)
            return self.sizingCell!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        } else {
            if indexPath.row == 0
            {
                return CGSize(width: screenWidth*0.9, height: screenWidth*0.9)
            }
            return CGSize(width: screenSize.width*0.45 - inset/2, height: screenSize.width*0.45 - inset/2);
        }
    }
    
    // TAG CELL CONFIG
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = filteredTags[indexPath.row]
        cell.tagName.text = tag
        cell.tagName.textColor = cell.selected ? UIColor.whiteColor() : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        cell.backgroundColor = cell.selected ? UIColor(red: 0, green: 1, blue: 0, alpha: 1) : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    
    // TAG CELL SELECT
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

//        let selectedCell = tagCollection.cellForItemAtIndexPath(indexPath)!
//        selectedCell.backgroundColor = UIColor.purpleColor()
//        tagCollection.deselectItemAtIndexPath(indexPath, animated: true)

        
        
//        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TagCell {
//            cell.toggleSelectedState()
//        }
//
        let tag = filteredTags[indexPath.row]
        filteredTagQuotes(tag)
        
    }

    // TAG CELL UNSELECT
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print("deselect")
        allQuotes()
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
    
    // FETCH ALL QUOTES
    func allQuotes () {
        ref.child("quotes").observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
            for item in snapshot.children {
                self.items.append(item as! FIRDataSnapshot)
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
    func filteredTagQuotes (tag: String) {
        self.items.removeAll()
        ref.child("quotes").removeAllObservers()
        
        ref.child("quotes").queryOrderedByChild("tags/\(tag)").queryEqualToValue(true).observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
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

}

