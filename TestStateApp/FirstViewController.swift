//
//  FirstViewController.swift
//  TestStateApp
//
//  Created by Miroslav Danazhiev on 8/16/17.
//  Copyright © 2017 Miroslav Danazhiev. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var firstLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        guard let text = firstTextField.text else {
            return
        }
        coder.encode(text, forKey: "firstText")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        firstLabel.text = coder.decodeObject(forKey: "firstText") as? String
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        print("finished restoring")
    }
}

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

