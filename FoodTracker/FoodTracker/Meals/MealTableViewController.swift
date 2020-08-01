//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Veronica R on 7/24/20.
//  Copyright © 2020 Veronica R. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController, UINavigationControllerDelegate{
    
    //MARK: Properties
    var meals = [Meal]()
    var newMeal = Meal (name: "", photo: nil, rating: 0)
    
    //   let mealObject = addMeal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
        
        addMealNavBarItem()
        
    }
    
}

//MARK:- LoadData
extension MealTableViewController:AddMealDelegate{
    
    func update(meal: Meal?, forIndex index: Int) {
        guard let newMeal = meal else{return}
        meals[index] = newMeal
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func addMeal(mealToAdd: Meal?) {
        guard let meal = mealToAdd else {
            return
        }
        meals.append(meal)
        saveMeals()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Private methods
    private func loadSampleMeals(){
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    private func loadMeals () -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
}

//MARK:- NavBarItems
extension MealTableViewController{
    
    func addMealNavBarItem(){
        let addMealBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMealTapped))
        navigationItem.rightBarButtonItem = addMealBarItem
    }
    
    @objc func addMealTapped(){
        
        guard let addMealViewControllerNavVC = UIStoryboard(name: "Meal", bundle: nil).instantiateViewController(withIdentifier: "MealNavVC") as? UINavigationController else {
            return
        }
        
        guard let mealViewController = addMealViewControllerNavVC.viewControllers.first as? MealViewController else { return }
        
        //set delegate to self
        mealViewController.delegate = self
        
        DispatchQueue.main.async {
            self.present(addMealViewControllerNavVC, animated: true, completion: nil)
        }
        
        //self.navigationController?.pushViewController(addMealViewController, animated: true)
    }
}

//MARK:- TableViewDelegates&DataSources
extension MealTableViewController{
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued table cell is not an instance of MealTableViewCell")
        }
        
        // fetches appropriate meal for data source layout
        let meal = meals[indexPath.row]
        
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mealToPass = meals[indexPath.row]
        
        guard let addMealViewControllerNavVC = UIStoryboard(name: "Meal", bundle: nil).instantiateViewController(withIdentifier: "MealNavVC") as? UINavigationController else {
            return
        }
        
        guard let mealViewController = addMealViewControllerNavVC.viewControllers.first as? MealViewController else { return }
        
        //pass the meal
        mealViewController.meal = mealToPass
        
        //set delegate to self
        mealViewController.delegate = self
        
        //Inject cell's index
        mealViewController.selectedIndex = indexPath.row
        
        
        DispatchQueue.main.async {
            self.present(addMealViewControllerNavVC, animated: true, completion: nil)
        }
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete row from data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert{
            //create new instance of class, insert into array and add into table view
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
}
