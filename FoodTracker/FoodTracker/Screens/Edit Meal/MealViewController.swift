//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Veronica R on 7/21/20.
//  Copyright © 2020 Veronica R. All rights reserved.
//

import UIKit

protocol AddMealDelegate {
    func addMeal (mealToAdd: Meal?)
    func update(meal: Meal?, forIndex index: Int)
}

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var meal: Meal?
    var selectedIndex : Int?
    var delegate: AddMealDelegate?
    
    var editingModeEnabled : Bool{
        return meal != nil && selectedIndex != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        self.title = "New Meal"
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        cancelMealNavBarItem()
        saveMealNavBarItem()
    }
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Hide the keyboard
        textField.resignFirstResponder()
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.title = nameTextField.text
    }
    
    //MARK:- UIImagePickerControllerDelegate
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyboard in case the user is typing
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        //only allow photos to be picked not taken
        imagePickerController.sourceType = .photoLibrary
        //make sure viewController is notified when the user picks an image
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //animate the dismissal
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following \(info)")
        }
        //set
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - View Delegates&DataSources
extension MealViewController{
    
    //    @objc func pushMealView() {
    //        guard let addMealView = UIStoryboard(name: "Meal", bundle: nil).instantiateViewController(withIdentifier: "MealViewController") as? MealViewController else {return}
    //        self.navigationController?.pushViewController(addMealView, animated: true)
    //    }
    //
    func saveMealNavBarItem(){
        let saveMealBarItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveMealTapped))
        
        navigationItem.rightBarButtonItem = saveMealBarItem
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func saveMealTapped(){
        
        guard let mealObject = Meal(name: nameTextField.text!, photo: photoImageView.image, rating: ratingControl.rating) else { return  }
        if editingModeEnabled{
            delegate?.update(meal: mealObject, forIndex: selectedIndex!)
        }else{
            delegate?.addMeal(mealToAdd: mealObject)
        }
        
        print("new meal: \(mealObject.name)")
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelMealNavBarItem() {
        let cancelMealBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelMealTapped))
        
        navigationItem.leftBarButtonItem = cancelMealBarItem
    }
    
    @objc func cancelMealTapped(){
        // Push --> Pop
        // Present --> Dismiss
        //self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

