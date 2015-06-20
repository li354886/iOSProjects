//
//  ViewController.swift
//  Psychologist
//
//  Created by 李正宁 on 6/19/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController
{
    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destionation = segue.destinationViewController as? UIViewController
        if let navCon = destionation as? UINavigationController {
            destionation = navCon.visibleViewController
        }
        if let hvc = destionation as? HappinessViewController {
            if let identifier = segue.identifier
            {
                switch identifier {
                    case "sad": hvc.happiness = 0
                    case "happy": hvc.happiness = 100
                    case "nothing": hvc.happiness = 25
                    default: hvc.happiness = 50
                }
            }
        }
    }
    
    
}

