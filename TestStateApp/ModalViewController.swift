//
//  ModalViewController.swift
//  TestStateApp
//
//  Created by Miroslav Danazhiev on 8/17/17.
//  Copyright © 2017 Miroslav Danazhiev. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    fileprivate var startTime = TimeInterval()
    fileprivate var timer = Timer()
    fileprivate var continueCurrentTime = TimeInterval()
    fileprivate var continueStartTime = TimeInterval()
    fileprivate var currentDate: Date = Date()
    
    var shouldRestartTimer: Bool = true
    weak var delegate: ModalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if shouldRestartTimer {
            startTime = NSDate.timeIntervalSinceReferenceDate
            UserDefaults.standard.set(Date(), forKey: "startTime")
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
        } else {
            
            decodeRestorableState()
        }
    }
    
    
    @objc fileprivate func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        currentDate = Date()
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        let strMinutes = String(format: "%02d", minutes)
        let strSecond = String(format: "%02d", seconds)
        
        timerLabel.text = "\(strMinutes):\(strSecond)"
        
    }
    
    @objc fileprivate func restartTimeFromLastTime() {
        
        var elapsedTime: TimeInterval = continueCurrentTime - continueStartTime
        continueCurrentTime = NSDate.timeIntervalSinceReferenceDate
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        let strMinutes = String(format: "%02d", minutes)
        let strSecond = String(format: "%02d", seconds)
        print(continueCurrentTime)
        print(continueStartTime)
        print(elapsedTime)
        timerLabel.text = "\(strMinutes):\(strSecond)"
    }
    
    fileprivate func encodeRestorableState() {

        UserDefaults.standard.set(currentDate, forKey: "currentTime")
   }
    
    fileprivate func decodeRestorableState() {
        
        let cDate = UserDefaults.standard.object(forKey: "currentTime") as! Date
        let sDate = UserDefaults.standard.object(forKey: "startTime") as! Date
        continueCurrentTime = cDate.timeIntervalSinceReferenceDate
        continueStartTime = sDate.timeIntervalSinceReferenceDate
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(restartTimeFromLastTime), userInfo: nil, repeats: true)
   }

    @IBAction func goBackToApp(_ sender: UIButton) {
        shouldRestartTimer = false
        timer.invalidate()
        encodeRestorableState()
        delegate?.stillInCall(vc: self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endModalPresentation(_ sender: UIButton) {
        shouldRestartTimer = true
        UserDefaults.standard.removeObject(forKey: "currentTime")
        UserDefaults.standard.removeObject(forKey: "startTime")
        timer.invalidate()
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

protocol ModalViewControllerDelegate: class {
    func stillInCall(vc: ModalViewController)
    func callEnded()
}
