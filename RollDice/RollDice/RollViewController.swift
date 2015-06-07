//
//  ViewController.swift
//  RollDice
//
//  Created by 李正宁 on 6/7/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class RollViewController: UIViewController {

        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "rollDice" {
          
            let controller = segue.destinationViewController as!
            DiceViewController
            
            controller.firstValue = self.randomDiceValue()
            controller.secondValue = self.randomDiceValue()
            println(controller.firstValue)
            println(controller.secondValue)
        }
    }
    
    func randomDiceValue() -> Int {
        
        // Generate a random Int32 using arc4Random
        let randomValue = 1 + arc4random() % 6
        
        // Return a more convenient Int, initialized with the random value
        return Int(randomValue)
    }




}

