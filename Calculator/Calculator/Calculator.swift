//
//  Calculator.swift
//  Calculator
//
//  Created by 严思远 on 2021/10/4.
//

import Foundation

var memory: Double = 0.0
var rad: Bool = false
var leftBracket: Bool = false

class Calculator: NSObject{
    enum Operation{
        case UnaryOp((Double)->Double)
        case BinaryOp((Double,Double)->Double)
        case Constant(Double)
        case ControlOp
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
        
        "=":Operation.ControlOp,
        
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
        
        "(":Operation.ControlOp,
        
        ")":Operation.ControlOp,
        
        "mc":Operation.ControlOp,
        
        "m+":Operation.UnaryOp{
            op in
            memory += op
            return op
        },
        
        "m-":Operation.UnaryOp{
            op in
            memory -= op
            return op
        },

        "mr":Operation.ControlOp,
        
        "2ⁿᵈ":Operation.ControlOp,
        
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
            if op == 0{
                return 1
            }
            if op.truncatingRemainder(dividingBy: 1) == 0{
                var result = 1.0
                for i in 1...Int(op){
                    result *= Double(i)
                }
                return result
            }
            return 0
        },
        
        "sin":Operation.UnaryOp{
            op in
            if rad {
                return sin(op)
            }else{
                return sin(op * Double.pi / 180)
            }
        },
        
        "cos":Operation.UnaryOp{
            op in
            if rad {
                return cos(op)
            }else{
                return cos(op * Double.pi / 180)
            }
        },
        
        "tan":Operation.UnaryOp{
            op in
            if rad {
                return tan(op)
            }else{
                return tan(op * Double.pi / 180)
            }
        },
        
        "e":Operation.Constant(M_E),
        
        "EE":Operation.BinaryOp{
            op1, op2 in
            return op1 * pow(10, op2)
        },
        
        "Rad":Operation.ControlOp,
        
        "Deg":Operation.ControlOp,
        
        "sinh":Operation.UnaryOp{
            op in
            if rad {
                return sinh(op)
            }else{
                return sinh(op * Double.pi / 180)
            }
        },
        
        "cosh":Operation.UnaryOp{
            op in
            if rad {
                return cosh(op)
            }else{
                return cosh(op * Double.pi / 180)
            }
        },
        
        "tanh":Operation.UnaryOp{
            op in
            if rad {
                return tanh(op)
            }else{
                return tanh(op * Double.pi / 180)
            }
        },
        
        "π":Operation.Constant(Double.pi),
        
        "Rand":Operation.ControlOp,
        
        "yˣ":Operation.BinaryOp{
            op1, op2 in
            return pow(op2, op1)
        },
        
        "2ˣ":Operation.UnaryOp{
            op in
            return pow(2, op)
        },
        
        "logᵧ":Operation.BinaryOp{
            op1, op2 in
            return log(op1) / log(op2)
        },
        
        "log₂":Operation.UnaryOp{
            op in
            return log2(op)
        },
        
        "sin⁻¹":Operation.UnaryOp{
            op in
            if rad {
                return asin(op)
            }else{
                return asin(op)  * 180 / Double.pi
            }
        },
        
        "cos⁻¹":Operation.UnaryOp{
            op in
            if rad {
                return acos(op)
            }else{
                return acos(op) * 180 / Double.pi
            }
        },
        
        "tan⁻¹":Operation.UnaryOp{
            op in
            if rad {
                return atan(op)
            }else{
                return atan(op) * 180 / Double.pi
            }
        },
        
        "sinh⁻¹":Operation.UnaryOp{
            op in
            if rad {
                return asinh(op)
            }else{
                return asinh(op) * 180 / Double.pi
            }
        },
        
        "cosh⁻¹":Operation.UnaryOp{
            op in
            if rad {
                return acosh(op)
            }else{
                return acosh(op) * 180 / Double.pi
            }
        },
        
        "tanh⁻¹":Operation.UnaryOp{
            op in
            if rad {
                return atanh(op)
            }else{
                return atanh(op) * 180 / Double.pi
            }
        }
        
    ] as [String : Any]
    
    struct InterMediate{
        var firstOp: Double
        var waitingOperation: (Double, Double) -> Double
    }
    var pendingOp: InterMediate? = nil
    
    func performOperation(operation: String, operand: Double) -> Double? {
        
        if let op = operations[operation] as? Operation{
            switch op {
            case .BinaryOp(let function):
                pendingOp = InterMediate(firstOp: operand, waitingOperation: function)
                return nil
            case .UnaryOp(let function):
                return function(operand)
            case .Constant(let value):
                return value
            case .ControlOp:
                if(operation == "="){
                    if operand == 0{
                        return nil
                    }
                    return pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
                }else if(operation == "Rand"){
                    return drand48()
                }else if(operation == "Rad" || operation == "Deg"){
                    rad = !rad
                }else if(operation == "2ⁿᵈ"){
                    return nil
                }else if(operation == "mc"){
                    memory = 0
                    return nil
                }else if(operation == "mr"){
                    return memory
                }else if(operation == "("){
                    leftBracket = true
                    return nil
                }else if(operation == ")"){
                    if leftBracket {
                        leftBracket = false
                        return pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
                    }else{
                        return nil
                    }
                }else{
                    return nil
                }
            }
        }
        
        return nil
    }
}
