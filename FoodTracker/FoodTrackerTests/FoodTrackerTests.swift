//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Veronica R on 7/21/20.
//  Copyright © 2020 Veronica R. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    

 //MARK: Meal class tests
    //confirm meal initializer returns Meal object when passed valid parameters
    func testMealInitializationSucceeds (){
        //zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        //highest positive
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
        
    }
    
    //when passed negative rating or empty nmame confirm Meal initializer returns nil
    func testMealInitializerFails(){
        //negative rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        //exceeds max
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        //empty string
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
    
}
