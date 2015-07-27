//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Phil Christenson on 7/12/15.
//  Copyright (c) 2015 Phil Christenson. All rights reserved.
//
//  Class to controll the table view of sent memes

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // outlets
    @IBOutlet weak var tableNavItem: UINavigationItem! // The nav bar at the top of the table view
    @IBOutlet var myTableView: UITableView!  // the table view
    
    // class variables
    var memes: [Meme]! // an array of memes
    
    override func viewWillAppear(animated: Bool) {
        // Add a "plus" button to the nav bar on the top right that calls newMemeFunc
        self.tableNavItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newMemeFunc"), animated: true)
        
        // hide the back button that comes by default
        self.tableNavItem.setHidesBackButton(true, animated: true)
        
        super.viewWillAppear(animated)
        
        // get the shared model of memes and set it to our local class variable memes array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    // Function to tell the table how many rows to display
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // function called for each row.  This is where we customize the table cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get a new reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        // get a reference to the appropriate meme for this row in the table
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText! + " " + meme.bottomText!
        cell.imageView?.image = meme.memeImage
        
        // Try to set the image portion of the row cell to be a consistent size
        // (this code doesn't seem to work, but leaving for future reference)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        cell.imageView?.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, (screenWidth / 2) , (screenWidth / 2))
        cell.imageView?.bounds = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, (screenWidth / 2) , (screenWidth / 2))
        
        return cell
    }
    
    // function called to determine if rows are editable
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
        
    {
        return true
    }
    
    // function called when user selects a particular row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // show the detailed view of the meme
        self.performSegueWithIdentifier("ShowMemeDetailSegue", sender: self)
        
    }
    
    // Function called before the segue actually executes
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMemeDetailSegue" {  // make sure we have the right segue
            // Get a reference to the destination view controller
            let controller = segue.destinationViewController as!
            MemeDetailViewController
            // set the appropriate class variables for the destination
            controller.selectedMeme = self.memes[myTableView.indexPathForSelectedRow()!.row]
            controller.selectedMemeIndex = myTableView.indexPathForSelectedRow()!.row
            
        }       
    }
    
    // Function called when user hits the "plus" button to add a new Meme.  Should invoke the editor.
    func newMemeFunc() {
        
        self.performSegueWithIdentifier("newMeme2", sender: self)
    }
    
}
