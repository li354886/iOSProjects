//
//  ViewController.swift
//  ColorSwitches
//
//  Created by 李正宁 on 6/7/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    
    
    @IBOutlet weak var redControl: UISwitch!
    @IBOutlet weak var greenControl: UISwitch!
    @IBOutlet weak var blueControl: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeColor(sender: UISwitch) {
        
        let r: CGFloat = self.redControl.on ? 1 : 0
        let g: CGFloat = self.greenControl.on ? 1 : 0
        let b: CGFloat = self.blueControl.on ? 1 : 0
        
        colorView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
    }

}

