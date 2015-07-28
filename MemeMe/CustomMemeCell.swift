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
        topTextColCell.text = topText
        bottomTextColCell.text = bottomText
        
        topTextColCell.textColor = UIColor.whiteColor()
        topTextColCell.shadowColor = UIColor.blackColor()
        
        bottomTextColCell.textColor = UIColor.whiteColor()
        bottomTextColCell.shadowColor = UIColor.blackColor()
        
    }

}
