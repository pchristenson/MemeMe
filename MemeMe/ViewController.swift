//
//  ViewController.swift
//  MemeMe
//
//  Created by Phil Christenson on 6/7/15.
//  Copyright (c) 2015 Phil Christenson. All rights reserved.
//
//  The class for the editor screen of MemeMe

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // class variables
    var originalViewOrigin : CGFloat = 0.0  // a variable to keep track of the view origin
    var unmodifiedImage : UIImage = UIImage() // the original image
    var memedImage : UIImage = UIImage() // the memed image
    var editExisting : Bool = false // flag to indicate that we want to edit an existing meme
    var indexExisting : Int = 0 // The index into the model array of the meme we want to edit

    // Outlets
    @IBOutlet weak var myNavigationItem: UINavigationItem!  // The navigation item at the top
    @IBOutlet weak var TopTextField: UITextField! // The text field at the top of the meme
    @IBOutlet weak var BottomTextField: UITextField!  // The text field at the bottom of the meme
    @IBOutlet weak var imagePickerView: UIImageView! // The image view
    @IBOutlet weak var cameraButton: UIBarButtonItem! // The camera button at the bottom
    @IBOutlet weak var MyBottomToolbar: UIToolbar! // The bottom toolbar
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Add a social share button to the top left of the screen that calls the sendMeme function
        self.myNavigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "sendMeme"), animated: true)
    
        // Add a cancel button to the top right of the screen that calls the cancelMeme function
        self.myNavigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelMeme"), animated: true)
        
        // Hide the share button for now (until an image is selected for the meme)
        self.myNavigationItem.leftBarButtonItem?.enabled = false
        
        // hide the status bar
        UIApplication.sharedApplication().statusBarHidden = true
        
        // we need to have special handling if we came to this screen as a result
        // of someone wanting to edit an existing meme
        if(self.editExisting == true)
        {
            // Get a reference to the memes array (our model) in the appDelegate
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            // get a local copy of the existing meme that the user wants to edit
            var existingMeme = appDelegate.memes[indexExisting]
            
            // set the editor components to match the existing meme that was selected
            self.imagePickerView.image = existingMeme.original
            self.unmodifiedImage = existingMeme.original
            self.TopTextField.text = existingMeme.topText
            self.BottomTextField.text = existingMeme.bottomText
            
            // We can go ahead and enable the share button now because we have a valid meme already
            self.myNavigationItem.leftBarButtonItem?.enabled = true
            // Now that we have handled the edit special case, we can turn the flag off
            self.editExisting = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Set the various font/text properties
        
        // remove the text background
        self.TopTextField.backgroundColor = UIColor.clearColor()
        self.BottomTextField.backgroundColor = UIColor.clearColor()
        
        // approximate the "Impact" font, all caps, white with a black outline
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4.0
        ]
       
        // set the text properties for the top text field
        self.TopTextField.defaultTextAttributes = memeTextAttributes
        self.TopTextField.textAlignment = NSTextAlignment.Center
        self.TopTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        // set the properties for for the bottom text field
        self.BottomTextField.defaultTextAttributes = memeTextAttributes
        self.BottomTextField.textAlignment = NSTextAlignment.Center
        self.BottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        // Tell the app to listen for keyboard notifications so we can respond appropriately
        self.subscribeToKeyboardNotifications()
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // stop listening for keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // Function called when user selects "Album" from the bottom toolbar
    @IBAction func pickAnAlbumImage(sender: AnyObject) {
        // invoke the image picker controller to get pictures from a library
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // Function called when user selects the "camera" button from the bottom toolbar
    @IBAction func pickACameraImage(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        // Have the image Picker controller invoke the phone camera to get the image
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // Function called when the image picker controller dialog has finished and the user has selected an image
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            
            // make sure a valid image was selected
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                // set the screen image to the one picked
                self.imagePickerView.image = image
                self.unmodifiedImage = image
                self.myNavigationItem.leftBarButtonItem?.enabled = true
            }
        // close the Image picker controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // User selected cancel from the image picker controller
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        // just dismiss the view and don't do anything else
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Function called as soon as the user wants to edit either the top or bottom text
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        let defaultStringTop = "TOP"
        let defaultStringBottom = "BOTTOM"
        if(textField.text == defaultStringTop || textField.text == defaultStringBottom){
            // clear the existing text if the defaults were present
            textField.text = nil
        }
    }
    
    // Function called when user is done editing
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // make sure the keyboard is dismissed when a user presses return
        textField.resignFirstResponder()
        
        return true;
    }
    
    // Function to tell the system which keyboard functions we care to list for
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Function to tell the system we are done listening to the keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Function called when the app will display the keyboard to the user
    func keyboardWillShow(notification: NSNotification) {
        // store the original origin before modifying it
        self.originalViewOrigin = self.view.frame.origin.y
        
        // Move everything up if the user is typing in the bottom text field so 
        // the keyboard doesn't block the text
        if self.BottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Function called before the keyboard goes away
    func keyboardWillHide(notification: NSNotification) {
        // restore the origin back to what it was before
        self.view.frame.origin.y = self.originalViewOrigin
        
    }
    
    // Function to determine how much space the keyboard takes up so we can adjust appropriately
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Function called when user selects the social share button
    func sendMeme() {
        //Create the meme
        self.memedImage = self.generateMemedImage()
        
        // set up the Activity View Controller and pass it the memed image
        let nextController = UIActivityViewController(activityItems: [self.memedImage], applicationActivities: nil)
        // show the controller
        self.presentViewController(nextController, animated: true, completion: nil)
        
        // Set up the system to know what happens when the activity view controller is finished
        nextController.completionWithItemsHandler = myCompletionHandler
        
    }
    
    // function called when user selects "cancel" button from edit screen.  Should send back to
    // to the table/collection views
    func cancelMeme() {
        self.performSegueWithIdentifier("CancelEdit", sender: self)
    }
    
    // function to actually save the image into the model
    func save() {
        //Create the meme
        var meme = Meme( topMemeText : self.TopTextField.text, bottomMemeText : self.BottomTextField.text, oldImage : self.unmodifiedImage, newImage : self.memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // function called when the activity view controller is finished (i.e. - after
    // the user has shared the meme
    func myCompletionHandler(activityType:String!, completed: Bool,
        returnedItems: [AnyObject]!, error: NSError!)
    {
        println(activityType, completed, returnedItems, error)
        
        if(completed)
        {
            save()  // actually save the meme now since it was successfully sent
            
            // now do a perform segue with identifier
            self.performSegueWithIdentifier("SeeSavedMemes", sender: self)
            
        }
        else{ // user must have selected cancel or something else didn't work
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // Create a single image that has the image, and top and bottom text
    func generateMemedImage() -> UIImage {
    
        // hide the top and bottom toolbars before grabbing the image
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        self.MyBottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        // save the entire image with text
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // now turn the toolbars back on
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.hidden = false
        self.MyBottomToolbar.hidden = false
        
        return memedImage
    }
    
}

