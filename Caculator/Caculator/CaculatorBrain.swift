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
        case setValueOperation(String, (String, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .setValueOperation(let symbol, _):
                    return symbol
                }
            }
        }
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
    
    var program: AnyObject {
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knowOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(let ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps);
            case .UnaryOperation(_, let operation):
                let operandEvalutaion = evaluate(remainingOps)
                if let operand = operandEvalutaion.result {
                    return (operation(operand), operandEvalutaion.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return(nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knowOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    var operandSymbolStack = [String]()
    
    func pushOperand(symbol: String) -> Double? {
        operandSymbolStack.append(symbol)
        return evaluate()
    }
    
    var variableDict = [String:Double]()
    
    var variableValues: [String:Double] {
        get {
            return variableDict
        }
        set {
            if knowOps.remove{
                var variableV = operandSymbolStack.removeLast()
                variableDict["variableV"] =
            }
        }
    }
    
}