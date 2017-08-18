//
//  SecondViewController.swift
//  TestStateApp
//
//  Created by Miroslav Danazhiev on 8/16/17.
//  Copyright © 2017 Miroslav Danazhiev. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var timerText: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var secondLabel: UILabel!
    
    fileprivate var startTime = TimeInterval()
    fileprivate var timer = Timer()
    fileprivate var elapsedTime = TimeInterval()
    fileprivate var stillInCall:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate
        secondTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        elapsedTime = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        let strMinutes = String(format: "%02d", minutes)
        
        timerText.text = "\(strMinutes):\(seconds)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modalVCSegue" {
            let vc = segue.destination as! ModalViewController
            vc.delegate = self
            vc.shouldRestartTimer = !stillInCall
        }
    }
    
    fileprivate func restartTimeFrom(lastElapesedTime: TimeInterval) {

        elapsedTime = lastElapesedTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = Double(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = Double(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        let strMinutes = String(format: "%02d", minutes)
        
        timerText.text = "\(strMinutes):\(seconds)"
    }


    override func encodeRestorableState(with coder: NSCoder) {
        
        guard let text = secondTextField.text else {
            return
        }
        coder.encode(text, forKey: "secondText")
        coder.encode(elapsedTime, forKey: "timer")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        secondLabel.text = coder.decodeObject(forKey: "secondText") as? String
        
        let timer = coder.decodeDouble(forKey: "timer")
        restartTimeFrom(lastElapesedTime: timer)
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        print("finished restoring")
    }
}

extension SecondViewController: ModalViewControllerDelegate {
    
    func stillInCall(vc: ModalViewController) {
         stillInCall = true
    }
    func callEnded() {
        stillInCall = false
    }
}

