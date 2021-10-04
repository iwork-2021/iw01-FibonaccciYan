//
//  Calculator.swift
//  Calculator
//
//  Created by 严思远 on 2021/10/4.
//

import Foundation

class Calculator:NSObject{
    enum Operation{
        case UnaryOp((Double)->Double)
        case BinaryOp((Double,Double)->Double)
        case EqualOp
        case Constant(Double)
    }
    
    var operations = [
        "+": Operation.BinaryOp{
            (op1, op2) in
            return op1 + op2
        },
        
        "-": Operation.BinaryOp{
            (op1, op2) in
            return op1 - op2
        },
        
        "x":Operation.BinaryOp{
            (op1, op2) in
            return op1 * op2
        },
        
        "/":Operation.BinaryOp{
            (op1, op2) in
            return op1 / op2
        },
        
        "=":Operation.EqualOp,
        
        "%":Operation.UnaryOp{
            op in
            return op / 100.0
        },
        
        "+/-":Operation.UnaryOp{
            op in
            return -op
        },
        
        "AC":Operation.UnaryOp{
            _ in
            return 0
        }
    ]
    
    struct InterMediate{
        var firstOp: Double
        var waitingOperation: (Double, Double) -> Double
    }
    var pendingOp: InterMediate? = nil
    
    func performOperation(operation: String, operand: Double) -> Double? {
        if let op = operations[operation] {
            switch op {
            case .BinaryOp(let function):
                pendingOp = InterMediate(firstOp: operand, waitingOperation: function)
                return nil
            case .UnaryOp(let function):
                return function(operand)
            case .EqualOp:
                return pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
            case .Constant(let value):
                return value
            }
        }
        
        return nil
    }
}
