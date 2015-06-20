//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by 李正宁 on 6/19/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class DiagnosedHappinessViewController :
    HappinessViewController, UIPopoverPresentationControllerDelegate
{
    override var happiness: Int {
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory: [Int] {
        get {
            return defaults.objectForKey(History.DefaultKey) as? [Int] ?? []
        }
        set {
            defaults.setObject(newValue, forKey: History.DefaultKey)
        }
    }
    
    
    private struct History {
        static let SegueIdentifier = "history"
        static let DefaultKey = "DiagnosedHappniessViewController.History"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch identifier {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController{
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
   
}
