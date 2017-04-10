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

    @IBOutlet var calcButtons: [UIButton]!
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblDisplay: UILabel!
    
    @IBOutlet weak var btnMute: UIButton!
    var soundIsUnmuted = true
    var btnSound: AVAudioPlayer!
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
        
    }
    enum operation{
        case addition
        case subtraction
        case multiplication
        case division
        case empty
    }

    func initialiseCalculator(){
        lblDisplay.text = "0"
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
        }
        let newValue = lblDisplay.text! + String(sender.tag)
        lblDisplay.text = newValue
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
            btnSound.volume = 0
            btnMute.setImage(#imageLiteral(resourceName: "no_sound"), for: .normal)
            soundIsUnmuted = false
        }
        else{
            btnSound.volume = 3
            btnMute.setImage(#imageLiteral(resourceName: "sound"), for: .normal)
            soundIsUnmuted = true
        }
    }

}

