//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Phil Christenson on 7/12/15.
//  Copyright (c) 2015 Phil Christenson. All rights reserved.
//
//  Class for the collection view of sent memes

import UIKit


class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // class variables
    var memes: [Meme]!  // an array of memes
    
    // outlets
    @IBOutlet weak var colNavItem: UINavigationItem! // the nav bar a the top of the collection view
    @IBOutlet var myCollectionView: UICollectionView! // the collection view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a "plus" button to the nav bar on the top right that calls newMemeFunc
        self.colNavItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newMemeFunc"), animated: true)
        
        // hide the back button that comes by default
        self.colNavItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // get the shared model of memes and set it to our local class variable memes array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    
    }
    
    // Function to tell the table how many items to display
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // function called for each cell item.  This is where we customize the each cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a new reusable cell
        let cell: CustomMemeCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        // get a reference to the appropriate meme for this cell in the collection
        let meme = memes[indexPath.item]
        
        // Set the name and image
        cell.setText(meme.topText!, bottomText: meme.bottomText!)
        let imageView = UIImageView(image: meme.original)
        cell.backgroundView = imageView
        
        return cell
    }
    
    // function called to determine if cells are editable
    func collectionView(collectionView: UICollectionView, canEditItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    // function called when a particular cell is selected by the user
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Don't need any code here because we connected the segue to the cell in the storyboard editor.  It automatically calls the segue with identifier for the right selected cell.
    }
    
    // Function called before the segue actually executes
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMemeDetailSegue2" {  // make sure we have the right segue
            // Get a reference to the destination view controller
            let controller = segue.destinationViewController as!
            MemeDetailViewController
            
            let indexPath = myCollectionView.indexPathForCell(sender as! UICollectionViewCell)
            // set the appropriate class variables for the destination
            controller.selectedMeme = self.memes[indexPath!.row]
            controller.selectedMemeIndex = indexPath!.row
            
        }
    }
    
    // Function called to assist in the collection view layout
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // get the size of the screen
        let screenSize: CGRect = UIScreen.mainScreen().bounds
            
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        // make the cells be 1/3rd the screen width and make them square
        return CGSize(width: screenWidth/3, height: screenWidth/3)
    }
    
    // Function called to determine the buffer space around each collection set
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            let topSpace: CGFloat = self.topLayoutGuide.length
            let bottomSpace: CGFloat = self.bottomLayoutGuide.length
            
            let sectionInsets = UIEdgeInsets(top: topSpace, left: 0.0, bottom: bottomSpace, right: 0.0)
            
            return sectionInsets
    }
    
    // Function called to determine how much horizontal space is between each cell
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            // set it to 0.0 for no space in between
            let interItemSpacing = CGFloat(0.0)
            
            return interItemSpacing
    }
    
    // Function called to determine how much vertical space is between each cell
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            // set it to 0.0 for no space in between
            let interLineSpacing = CGFloat(0.0)
            
            return interLineSpacing
    }
    
    // Function called when user hits the "plus" button to add a new Meme.  Should invoke the editor.
    func newMemeFunc() {
        
        self.performSegueWithIdentifier("newMeme", sender: self)
    }
}
