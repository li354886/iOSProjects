//
//  ViewController.swift
//  TextFieldDemo
//
//  Created by 李正宁 on 6/7/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

   
    
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var cashField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var editingSwitch: UISwitch!
    
    let zipCodeDelegate =  ZipCodeTextFieldDelegate()
    let cashDelegate = CashTextFieldDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.zipField.delegate = self.zipCodeDelegate
        self.cashField.delegate = self.cashDelegate
        self.numberField.delegate = self
        
        self.editingSwitch.setOn(false, animated: false)
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return self.editingSwitch.on
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    @IBAction func toggleTheTextEditor(sender: AnyObject) {
        
        if !(sender as! UISwitch).on {
            self.numberField.resignFirstResponder()
        }
    }


}

