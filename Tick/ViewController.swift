//
//  ViewController.swift
//  Tick
//
//  Created by Nhan Cao on 9/27/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var clockView: ClockView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    var state: ClockView.State = .picking {
        didSet {
            clockView.state = self.state
            switch self.state {
            case .picking:
                cancelButton.isEnabled = false
            case .running:
                cancelButton.isEnabled = true
            case .paused:
                cancelButton.isEnabled = true
            }
            setStartButtonAppearance()
        }
    }
    
    var reminderSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        state = .picking
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.setBackgroundColor(color: UIColor.darkGray, forState: UIControl.State.normal)
        cancelButton.setBackgroundColor(color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), forState: UIControl.State.disabled)
        
        cancelButton.titleLabel?.textColor = UIColor.white
        
        startButton.layer.cornerRadius = startButton.frame.height/2
        
        
        let dir = "singing_bowl"
        if let path = Bundle.main.path(forResource: dir, ofType: "mp3") {
            print(path)
            let url = URL(fileURLWithPath: path)
            do {
                reminderSound = try AVAudioPlayer(contentsOf: url)
                reminderSound?.setVolume(800, fadeDuration: 100)
                
            } catch {
                print("Couldn't load file")
            }
        }
    }
    
    @IBAction func pressedCancel(_ sender: UIButton) {
        state = .picking
    }
    
    var timer = Timer()
    
    @IBAction func pressedStart(_ sender: UIButton) {
        switch state {
        case .picking:
            
            state = .running
            clockView.setCountDown()
            countDown()
            
        case .running:
            state = .paused
            timer.invalidate()
            
        case .paused:
            state = .running
            countDown()
        }
        
    }
    

    
    private func setStartButtonAppearance() {
        switch self.state {
        case .picking:
            startButton.setTitle("Start", for: .normal)
            startButton.setBackgroundColor(color: #colorLiteral(red: 0.3084011078, green: 0.4650763755, blue: 0, alpha: 1), forState: .normal)
            startButton.setTitleColor(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1), for: .normal)
        case .running:
            startButton.setTitle("Pause", for: .normal)
            startButton.setBackgroundColor(color: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), forState: .normal)
            startButton.setTitleColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), for: .normal)
        case .paused:
            startButton.setTitle("Resume", for: .normal)
            startButton.setBackgroundColor(color: #colorLiteral(red: 0.3084011078, green: 0.4650763755, blue: 0, alpha: 1), forState: .normal)
            startButton.setTitleColor(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1), for: .normal)
        }
    }
    
    func countDown() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            self.clockView.timeCount -= 1
            if self.clockView.timeCount == 0 {
                self.timeOut()
            }
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func timeOut() {
        timer.invalidate()
        state = .picking

        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        reminderSound?.play()
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

