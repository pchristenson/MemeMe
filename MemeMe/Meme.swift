//
//  Meme.swift
//  MemeMe
//
//  Created by Phil Christenson on 6/13/15.
//  Copyright (c) 2015 Phil Christenson. All rights reserved.
//
//  A class to describe a memed image

import Foundation
import UIKit

class Meme {
    
    // class variables
    var topText : String?  // text at the top of the meme
    var bottomText : String?  // text at the bottom of the meme
    var original : UIImage! // the original unedited image
    var memeImage : UIImage!  // the whole meme that combines the image and text
    
    // initialize the class instance with passed in variables
    init (topMemeText : String, bottomMemeText : String, oldImage : UIImage, newImage : UIImage) {
        self.topText = topMemeText
        self.bottomText = bottomMemeText
        self.original = oldImage
        self.memeImage = newImage
    }
    
}