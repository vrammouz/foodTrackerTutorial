//
//  Work.swift
//  FoodTracker
//
//  Created by Veronica R on 7/27/20.
//  Copyright © 2020 Veronica R. All rights reserved.
//

import UIKit

protocol Work {
   
    func startWorking()
    func eat()
    func leave()
}



class TEDMOB: Work {

    func startWorking() {
        
    }
    
    func eat() {
        
    }
    
    func leave() {
        
    }
    
    func CEO(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Employee") as? Employee else{
            return
        }
        vc.delegate = self
    }

    
}

class Employee: UIViewController {
    
    
    var delegate : Work?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func pcStarted(){
        delegate?.startWorking()
    }
    
    func yallaToBreak(){
        delegate?.eat()
    }
    
    func yallaNfel(){
        delegate?.leave()
    }
    
}

