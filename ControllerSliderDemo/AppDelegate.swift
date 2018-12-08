//
//  AppDelegate.swift
//  ControllerSliderDemo
//
//  Created by CoDancer on 2018/12/8.
//  Copyright © 2018年 IOS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow.init(frame: MAINSCREEN)
        appDelegate.window?.backgroundColor = UIColor.white
        let navi = UINavigationController.init(rootViewController: ViewController())
        
        appDelegate.window?.rootViewController = navi
        appDelegate.window?.makeKeyAndVisible()
        return true
    }

}

