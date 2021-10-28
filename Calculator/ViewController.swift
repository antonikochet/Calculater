//
//  ViewController.swift
//  Calculator
//
//  Created by Антон Кочетков on 26.10.2021.
//

import UIKit

class ViewController: UIViewController {

    private var firstNumber: Double = 0
    private var secondNumber: Double = 0
    private var operation: Operation?
    private var flagFirstNumber: Bool = false
    private var flagEqually: Bool = false
    private var flagContinuationComputation: Bool = false
    private var operationButton: UIButton?
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var clearingButton: UIButton!
    
    @IBAction func digitButton(_ sender: UIButton) {
        var resultText = resultLabel.text
        let digit = sender.currentTitle!
        if flagFirstNumber{
            resultLabel.text = ""
            resultText = ""
            flagFirstNumber = false
            setColorButtonOperation(touchButton: false)
        }
        if (resultText == "Error" || flagEqually) && !flagContinuationComputation {
            clearView()
            resultLabel.text = ""
            flagEqually = false
        if flagContinuationComputation {
            flagContinuationComputation = false
        }
        } else if (resultText == "0" || resultText == "") && digit == "," {
            resultLabel.text = "0,"
            return
        } else if resultText == "0" {
            resultLabel.text = ""
        }
        resultLabel.text = resultLabel.text! + digit
        clearingButton.setTitle("C", for: .normal)
    }
    
    @IBAction func operationButton(_ sender: UIButton) {
        if flagEqually {
            flagContinuationComputation = true
        }
        operation = Operation(rawValue: sender.currentTitle!)
        firstNumber = resultLabel.text?.toDouble() ?? 0
        flagFirstNumber = true
        if operationButton != nil {
            setColorButtonOperation(touchButton: false)
        }
        operationButton = sender
        setColorButtonOperation(touchButton: true)
    }
    
    @IBAction func equallyButton(_ sender: UIButton) {
        if !flagEqually || flagContinuationComputation {
            secondNumber = resultLabel.text!.toDouble()
        }
        if secondNumber == 0 && operation == Operation.division {
            resultLabel.text = "Error"
            return
        }
        let result: Double = operation?.getResult(left: firstNumber, right: secondNumber) ?? firstNumber
        resultLabel.text = result.toString()
        firstNumber = result
        flagEqually = true
        flagContinuationComputation = false
    }
    
    @IBAction func unaryOperatorButton(_ sender: UIButton) {
        let number = resultLabel.text!.toDouble()
        let unaryOperator = UnaryOperator(rawValue: sender.currentTitle!)
        resultLabel.text = unaryOperator?.getResult(right: number).toString()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        if resultLabel.text! != "0" {
            resultLabel.text = "0"
            clearingButton.setTitle("AC", for: .normal)
        } else {
            clearView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.numberOfLines = 1
        resultLabel.minimumScaleFactor = 0.5
        resultLabel.text = "0"
        resultLabel.isUserInteractionEnabled = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        resultLabel.addGestureRecognizer(swipeLeft)
    }
    
    private func clearView() {
        firstNumber = 0
        secondNumber = 0
        operation = nil
        resultLabel.text = "0"
        clearingButton.setTitle("AC", for: .normal)
        setColorButtonOperation(touchButton: false)
        operationButton = nil
    }
    
    private func setColorButtonOperation(touchButton: Bool) {
        if let button = operationButton {
            if touchButton {
                button.tintColor = .white
                button.setTitleColor(UIColor(named: "operationColorButton"), for: .normal)
            } else {
                button.setTitleColor(.white, for: .normal)
                button.tintColor = UIColor(named:"operationColorButton")
            }
        }
    }
    
    @objc
    func swipedLeft() {
        if resultLabel.text != "0" || resultLabel.text != "" {
            resultLabel.text = String(resultLabel.text!.dropLast())
        }
        if resultLabel.text == "" {
            resultLabel.text = "0"
            clearingButton.setTitle("AC", for: .normal)
        }
    }
}

extension String {
    func toDouble() -> Double {
        if let number = Double(self.replacingOccurrences(of: ",", with: ".")) {
            return number
        } else {
            return 0
        }
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%g", self).replacingOccurrences(of: ".", with: ",")
    }
}
