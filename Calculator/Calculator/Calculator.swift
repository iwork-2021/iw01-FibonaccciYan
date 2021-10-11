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
        case ControlOp1((Double)->Double)
        case ControlOp2
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
        },
        
        //TODO: complete function
        "(":Operation.ControlOp1{
            op in
            return 0
        },
        
        ")":Operation.ControlOp1{
            op in
            return 0
        },
        
        "mc":Operation.ControlOp1{
            op in
            return 0
        },
        
        "m+":Operation.ControlOp1{
            op in
            return 0
        },
        
        "m-":Operation.ControlOp1{
            op in
            return 0
        },

        "mr":Operation.ControlOp1{
            op in
            return 0
        },
        
        "2ⁿᵈ":Operation.ControlOp2,
        
        "x²":Operation.UnaryOp{
            op in
            return op * op
        },
        
        "x³":Operation.UnaryOp{
            op in
            return op * op * op
        },
        
        "xʸ":Operation.BinaryOp{
            op1, op2 in
            return pow(op1, op2)
        },
        
        "eˣ":Operation.UnaryOp{
            op in
            return exp(op)
        },
        
        "10ˣ":Operation.UnaryOp{
            op in
            return pow(10, op)
        },
        
        "1/x":Operation.UnaryOp{
            op in
            return 1/op
        },
        
        "x^1/2":Operation.UnaryOp{
            op in
            return sqrt(op)
        },
        
        "x^1/3":Operation.UnaryOp{
            op in
            return pow(op, 1/3)
        },
        
        "x^1/y":Operation.BinaryOp{
            op1, op2 in
            return pow(op1, 1/op2)
        },
        
        "ln":Operation.UnaryOp{
            op in
            return log(op)
        },
        
        "log₁₀":Operation.UnaryOp{
            op in
            return log10(op)
        },
        
        "x!":Operation.UnaryOp{
            op in
            if op.truncatingRemainder(dividingBy: 1) == 0{
                var result = op
                for i in 2...(Int(op) - 1){
                    result *= Double(i)
                }
                return result
            }
        },
        
        "sin":Operation.UnaryOp{
            op in
            return sin(op)
        },
        
        "cos":Operation.UnaryOp{
            op in
            return cos(op)
        },
        
        "tan":Operation.UnaryOp{
            op in
            return tan(op)
        },
        
        "e":Operation.Constant,
        
        "EE":Operation.BinaryOp{
            op1, op2 in
            return op1 * pow(10, op2)
        },
        
        "Rad":Operation.ControlOp2,
        
        "sinh":Operation.UnaryOp{
            op in
            return sinh(op)
        },
        
        "cosh":Operation.UnaryOp{
            op in
            return cosh(op)
        },
        
        "tanh":Operation.UnaryOp{
            op in
            return tanh(op)
        },
        
        "π":Operation.Constant,
        
        "Rand":Operation.ControlOp2
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
            case .ControlOp1
                return
            case .ControlOp2
                return
            
            }
        }
        
        return nil
    }
}
