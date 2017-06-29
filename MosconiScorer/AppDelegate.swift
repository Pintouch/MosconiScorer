//
//  AppDelegate.swift
//  MosconiScorer
//
//  Created by Pintouch on 21/06/2017.
//  Copyright © 2017 Dashpool. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    @IBAction func ChooseFolderClick(_ sender: Any) {
        if let vc = NSApplication.shared().mainWindow?.contentViewController as! ViewController? {
            FileHelpers.chooseFolder(viewController: vc)
        }
       // FileHelpers.chooseFolder(viewController: self.find)
            }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

