//
//  FirstViewController.swift
//  FoodTracker
//
//  Created by Veronica R on 7/27/20.
//  Copyright © 2020 Veronica R. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ana l First")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToSecondTapped(_ sender: UIButton) {
        guard let secondVC = UIStoryboard(name: "DelegationTest", bundle: nil)
            .instantiateViewController(identifier: "SecondViewController") as? SecondViewController else { return }
        secondVC.delegate = self
        self.present(secondVC, animated: true, completion: nil)
    }
    
}

//MARK:- SecondViewControllerDelegate
extension FirstViewController: SecondViewControllerUpdates{
    func didNameChanged(name: String?) {
        print("\nhis name is: \(name ?? "Unknown")")
    }
    
}

