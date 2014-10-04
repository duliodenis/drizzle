//
//  AppDelegate.swift
//  drizzle
//
//  Created by Dulio Denis on 9/23/14.
//  Copyright (c) 2014 Dulio Denis. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        application.setStatusBarHidden(true, withAnimation:.None)
        return true
    }

}

