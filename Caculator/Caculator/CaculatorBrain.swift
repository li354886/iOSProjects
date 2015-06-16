//
//  CaculatorBrain.swift
//  Caculator
//
//  Created by 李正宁 on 6/15/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import Foundation

class CaculatorBrain
{
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    private var opStack = [Op]()
    
    private var knowOps = [String:Op]()
    
    init() {
        knowOps["+"] = Op.BinaryOperation("+") { $0 + $1}
        knowOps["⨉"] = Op.BinaryOperation("⨉") { $0 * $1}
        knowOps["÷"] = Op.BinaryOperation("÷") { $1 / $0}
        knowOps["-"] = Op.BinaryOperation("-") { $1 - $0}
        knowOps["√"] = Op.UnaryOperation("√") { sqrt($0)}
    }
    
    func evalute() -> Double? {
        
    }
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(operand: Double) {
        
    }
    
}