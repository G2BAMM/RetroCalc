//
//  ViewController.swift
//  RetroCalc
//
//  Created by Brian McAulay on 07/04/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController {
    //Map our outlets for use in code
    @IBOutlet var calcButtons: [UIButton]!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblDisplay: UILabel!
    @IBOutlet weak var btnMute: UIButton!
    
    //Set our inital variables ready to launch app
    var soundIsUnmuted = true
    var btnSound: AVAudioPlayer!
    var runningNumber = ""
    var currentOperation = Operation.Empty
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        initialiseCalculator()
        btnMute.setImage(#imageLiteral(resourceName: "sound"), for: .normal)
        soundIsUnmuted = true
        btnSound.setVolume(0.1, fadeDuration: 0)
        
        
    }
    enum Operation: String{
        case Add = "+"
        case Subtract = "-"
        case Multiply = "*"
        case Divide = "/"
        case Empty = ""
    }
    
    
    func initialiseCalculator(){
        //Carried out when first started and after the 'clear' button has been pressed
        lblDisplay.text = "0"
        currentOperation = .Empty
        leftValStr = ""
        rightValStr = ""
        runningNumber = ""
    }

    func playSound(){
        if btnSound.isPlaying{
            btnSound.stop()
        }
        btnSound.play()
    }
    
    @IBAction func Number_Clicked(_ sender: UIButton) {
        if lblDisplay.text == "0"{
            lblDisplay.text = ""
            runningNumber = ""
        }
        runningNumber += "\(sender.tag)"
        lblDisplay.text = runningNumber
        if soundIsUnmuted{
            playSound()
        }
        
    }
    
    @IBAction func btnClear_Clicked(_ sender: Any) {
        initialiseCalculator()
        if soundIsUnmuted{
            playSound()
        }
        
        
    }
    
    @IBAction func btnMute_Clicked(_ sender: Any) {
        if soundIsUnmuted{
            btnSound.setVolume(0.0, fadeDuration: 0)
            btnMute.setImage(#imageLiteral(resourceName: "no_sound"), for: .normal)
            soundIsUnmuted = false
        }
        else{
            btnSound.setVolume(0.1, fadeDuration: 0)
            btnMute.setImage(#imageLiteral(resourceName: "sound"), for: .normal)
            soundIsUnmuted = true
        }
    }
    
    func processOperation(operation: Operation){
        if currentOperation != Operation.Empty{
            if runningNumber != ""{
                rightValStr = runningNumber
                runningNumber = ""
                
                //Now determine what we have to do with our operation
                switch operation {
                case .Add:
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                case .Divide:
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                case .Multiply:
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                case .Subtract:
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                default:
                    break
                }
                
                leftValStr = result
                if fmod(Double(result)!, 1) == 0{
                    //Our answer is a whole number so don't show any decimal places on the calculator display
                    result = String(format: "%.f", Double(result)!)
                }
                
                lblDisplay.text = result
                
            }
            currentOperation = operation
            
        } else{
            //This is the first time the operator has been pressed
            if runningNumber == "" {
                //If we don't have a value then we need to set one or we get an error if the user clicks an operation before pressing a number
                runningNumber = lblDisplay.text!
            }
            
            
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
         
        }
        if soundIsUnmuted{
            playSound()
        }
    }
    
    @IBAction func onDividePressed(sender: Any){
        processOperation(operation: .Divide)
        if soundIsUnmuted{
            playSound()
        }
    }
    
    @IBAction func onAddPressed(sender: Any){
        processOperation(operation: .Add)
        if soundIsUnmuted{
            playSound()
        }
    }
    
    @IBAction func onMultiplyPressed(sender: Any){
        processOperation(operation: .Multiply)
        if soundIsUnmuted{
            playSound()
        }
    }
    
    @IBAction func onSubtractPressed(sender: Any){
        processOperation(operation: .Subtract)
        if soundIsUnmuted{
            playSound()
        }
    }
    
    @IBAction func onEqualPressed(sender: Any){
        processOperation(operation: currentOperation)
        if soundIsUnmuted{
            playSound()
        }
    }

}

