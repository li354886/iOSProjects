//
//  AppDelegate.swift
//  Bouncer
//
//  Created by 李正宁 on 6/28/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    struct Motion {
        static let Manager = CMMotionManager()
    }

}

