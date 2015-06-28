//
//  BezierPathsView.swift
//  Dropit
//
//  Created by 李正宁 on 6/27/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit

class BezierPathsView: UIView
{
    private var bezierPath = [String:UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPath[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPath {
            path.stroke()
        }
    }
}
