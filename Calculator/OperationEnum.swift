//
//  OperationEnum.swift
//  Calculator
//
//  Created by Антон Кочетков on 27.10.2021.
//

import Foundation


enum Operation: String {
    case addition = "+"
    case subtraction = "-"
    case division = "÷"
    case multiplication = "×"
    
    func getResult(left: Double, right: Double) -> Double {
        switch self {
            case .addition:
                return left + right
            case .subtraction:
                return left - right
            case .division:
                return left / right
            case .multiplication:
                return left * right
        }
    }
}

enum UnaryOperator: String {
    case percent = "%"
    case singChange = "+/-"
    
    func getResult(right: Double) -> Double {
        switch self {
            case .percent:
                return right / 100
            case .singChange:
                return -right
        }
    }
}
