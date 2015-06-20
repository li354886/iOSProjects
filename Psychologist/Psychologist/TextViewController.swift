//
//  TextViewController.swift
//  Psychologist
//
//  Created by 李正宁 on 6/19/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class TextViewController: UIViewController
{
    
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            textView?.text = text;
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set {
            super.preferredContentSize = newValue
        }
    }
}
