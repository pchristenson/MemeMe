//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Phil Christenson on 7/26/15.
//  Copyright (c) 2015 Phil Christenson. All rights reserved.
//
//  The view controller that displays a selected meme and also has a delete and edit button

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var selectedMeme: Meme!  // The Meme passed from the table or collection views because it was selected
    var selectedMemeIndex: Int! // The index into the array for the selected meme
    
    var memes: [Meme]! // A reference to the stored array of memes
    
    @IBOutlet weak var MemeImageView: UIImageView!  // The image of the entire sent meme

    @IBOutlet weak var SegueDVNItem: UINavigationItem! //
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // an array of items to add to the nav bar
        var barItemsArray: [UIBarButtonItem] = [
        UIBarButtonItem(barButtonSystemItem:  .Trash, target: self, action: "deleteMeme"),
        UIBarButtonItem(barButtonSystemItem:  .Edit, target: self, action: "editMeme")
        ] // an edit button, a trash can button
        
        // add the buttons to the navigation bar at top right
        SegueDVNItem.setRightBarButtonItems(barItemsArray, animated: true)
        
        
    }
    
    // function to delete a meme based on the user selected the trash can item from the detail view screen
    func deleteMeme()
    {
        // Details for an alert that asks the user if they really want to delete the meme
        var refreshAlert = UIAlertController(title: "Delete Meme?", message: "Do you really want to delete this meme?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add button to the alert for OK
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Ok logic here")
            
            // actually do the deleting because the user has selected ok
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(self.selectedMemeIndex)
            
            // now do a perform segue with identifier
            self.performSegueWithIdentifier("TrashMemeSegue", sender: self)
            
        }))
        
        // add button to the alert for Canceling the delete
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
            
            // user decided they didn't really want to delete.  Just do nothing and dismiss.
            
        }))
        
        // now display the alert
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    // function that is called when user selects edit button from the detail view screen
    func editMeme()
    {
        // now do a perform segue with identifier to go back to edit screen
        performSegueWithIdentifier("EditMemeSegue", sender: self)
    }
    

    override func viewWillAppear(animated:Bool)
    {
        super.viewWillAppear(animated)
        
        // The selected meme was passed to us from either the table view or collection view
        // set the image to the appropriate one
        MemeImageView.image = selectedMeme.memeImage
        
    }
    
    // Do work prior to executing the segue to go back to the edit screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // first check if we are dealing with the right segue
        if segue.identifier == "EditMemeSegue" {
            // get a reference to the destination controller
            let navController = segue.destinationViewController as!
            UINavigationController
            
            // since the destination controller was a navigation controller, we 
            // need to get the view controller it is pointing to in order to set
            // the appropriate variable
            let editViewController = navController.viewControllers[0] as! ViewController
            
            // set the class variables to tell the edit screen that we want to edit
            // a particular meme that already exists
            editViewController.editExisting = true
            editViewController.indexExisting = selectedMemeIndex
            
        }
    }
}