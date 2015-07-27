//
//  CustomMemeCell.swift
//  
//
//  Created by Phil Christenson on 7/24/15.
//
//  Class for the custom CollectionViewCell

import UIKit

class CustomMemeCell: UICollectionViewCell {
    
    // outlets
    @IBOutlet weak var bottomTextColCell: UILabel! // a text label at the top of the cell
    @IBOutlet weak var topTextColCell: UILabel!  // a text label at the bottom of the cell
    
    
    // set the text and stylize it to be white with black outline
    func setText(topText: String, bottomText: String) {
        self.topTextColCell.text = topText
        self.bottomTextColCell.text = bottomText
        
        self.topTextColCell.textColor = UIColor.whiteColor()
        self.topTextColCell.shadowColor = UIColor.blackColor()
        
        self.bottomTextColCell.textColor = UIColor.whiteColor()
        self.bottomTextColCell.shadowColor = UIColor.blackColor()
        
    }

}
