//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Veronica R on 7/23/20.
//  Copyright © 2020 Veronica R. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
//MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    
//MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
//MARK: Button Actions
    @objc func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button \(button), is not in the rating array \(ratingButtons)")
        }
        //calculate the rating of the seleced button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            //if selected star represents the current rating, reset the rating to 0
            rating = 0
        } else {
            //otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            
            //set the hint string for currently selected star
            let hintString: String?
            if rating == index + 1{
                hintString = "Tap to reset rating to zero"
            } else {
                hintString = nil
            }
            
            //calculate the value string
            let valueString: String
            switch rating {
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }
            
            //assign the hint string to the value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
        }
    }
    
//MARK: Private Methods
    private func setupButtons (){
        //load button images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        //clear existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for index in 0..<starCount {
            let button = UIButton()
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted,.selected])
            
            //Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //set accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //setup button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // add button to stack
            addArrangedSubview(button)
                
            //add the new button to the rating button array
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
   
}
