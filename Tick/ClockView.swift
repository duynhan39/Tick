//
//  ClockViewView.swift
//  Tick
//
//  Created by Nhan Cao on 9/27/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class ClockView: UIView {

    let timePicker = UIDatePicker()
    let timeLabel = UILabel()
    
    var timeCount = 0 {
        didSet {
            timeCount = max(0, timeCount)
            timeLabel.text = self.timeCount.toTimer()
        }
    }
    
    var state: ClockView.State = .picking {
        didSet {
            switch self.state {
            case .picking:
                timePicker.isHidden = false
                timeLabel.isHidden = true
            case .running, .paused:
                timePicker.isHidden = true
                timeLabel.isHidden = false
            }
        }
    }
    
    func setupUI() {
        self.addSubview(timePicker)
        timePicker.frame = self.bounds
        timePicker.datePickerMode = .countDownTimer
        timePicker.setValue(UIColor.white, forKey: "textColor")
        
        self.addSubview(timeLabel)
        timeLabel.frame = self.bounds
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: self.bounds.height*0.23)
        
        timeCount = 0

    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        clearsContextBeforeDrawing = true
        setupUI()
    }
    
    func setCountDown() {
        timeCount = Int(timePicker.countDownDuration)
    }
    
    

}

extension ClockView {
    enum State: Int {
        case picking, running, paused
    }
}

extension Int {
    func toTimer() -> String {
        
        var secString = String(self % 60)
        if secString.count == 1 {
            secString = "0"+secString
        }
        
        var minString = String((self / 60) % 60)
        if minString.count == 1 {
            minString = "0"+minString
        }
        
        var hourString = String(self / 3600)
        if hourString.count == 1 {
            hourString = "0"+hourString
        }
        
        return "\(hourString):\(minString):\(secString)"
    }
}
