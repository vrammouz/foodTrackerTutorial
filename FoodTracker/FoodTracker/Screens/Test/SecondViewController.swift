//
//  SecondViewController.swift
//  FoodTracker
//
//  Created by Veronica R on 7/27/20.
//  Copyright © 2020 Veronica R. All rights reserved.
//

import UIKit

protocol SecondViewControllerUpdates{
    func didNameChanged(name : String?)
}

class SecondViewController: UIViewController {

    var delegate: SecondViewControllerUpdates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    

    @IBAction func getMyNameTapped(_ sender: UIButton) {
        delegate?.didNameChanged(name: nameTextField.text)
    }
}
