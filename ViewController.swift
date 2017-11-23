//
//  ViewController.swift
//  RetroCalc
//  Copyright © 2017 Mikko Rouru. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //Setup
    @IBOutlet weak var outputLabel: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValueString = ""
    var rightValueString = ""
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "buttonsound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLabel.text = "0"
    }
    
    //Actions
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        runningNumber.removeAll()
        leftValueString.removeAll()
        rightValueString.removeAll()
        result = ""
        currentOperation = Operation.Empty
        outputLabel.text = "0"
        playSound()
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    //Logic
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            
            // One round of calculations, second one
            if runningNumber != "" {
             rightValueString = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValueString)! * Double(rightValueString)!)"
                } else if currentOperation == Operation.Divide {
                    if (rightValueString == "0") {
                        dividedByZero()
                    } else {
                    result = "\(Double(leftValueString)! / Double(rightValueString)!)"
                }
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValueString)! - Double(rightValueString)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValueString)! + Double(rightValueString)!)"
                }
                
                if (outputLabel.text != "Syntax error") {
                leftValueString = result
                if (result.hasSuffix(".0")) {
                    let range = result.index(result.endIndex, offsetBy: -2)..<result.endIndex
                    result.removeSubrange(range)
                }
                outputLabel.text = result
                }
            }
            currentOperation = operation
        } else {
            // This is the first time when operator has been pressed
            if (runningNumber != "") {
            leftValueString = runningNumber
            runningNumber = ""
            currentOperation = operation
            } else {
                leftValueString = "0"
                currentOperation = operation
            }
        }
    }
    
    //Error check if divided by zero
    func dividedByZero() {
        runningNumber.removeAll()
        leftValueString = "0"
        rightValueString.removeAll()
        result = ""
        outputLabel.text = "Syntax error"
    }
}

