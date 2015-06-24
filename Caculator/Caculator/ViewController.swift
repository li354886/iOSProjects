//
//  ViewController.swift
//  Caculator
//
//  Created by 李正宁 on 6/13/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
   
    
    
    
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var brain = CaculatorBrain()
    
    @IBAction func appendDigit(sender: AnyObject) {
        let digit = sender.currentTitle!
        if (digit == "Pi") {
            var pi = M_PI
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + (NSString(format: "%.2f", pi) as String)
            } else {
                display.text = NSString(format: "%.2f", pi) as String
                userIsInTheMiddleOfTypingANumber = true
            }
        } else {
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit!
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }

        }
    }
    
    var operandStack: Array<Double> = Array<Double>()
    
    @IBAction func digitOperation(sender: UIButton) {
    
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
//        switch operation{
//        case "+": performOperation { $0 * $1 }
//        case "÷": performOperation { $1 / $0 }
//        case "+": performOperation { $0 + $1 }
//        case "-": performOperation { $1 - $0 }
//        case "√": performOperation { sqrt($0)}
//        case "·": performOperation { $1 + $0 / 10}
//        case "sin": performOperation { sin($0)}
//        case "cos": performOperation { cos($0)}
//        
//        default: break
//      }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            println(displayValue)
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            println(displayValue)
            enter()
        }
    }

    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

}

