//
//  VisualizerController.swift
//  MosconiScorer
//
//  Created by Pintouch on 25/06/2017.
//  Copyright © 2017 Dashpool. All rights reserved.
//
import Cocoa

class VisualizerController : NSViewController {

    @IBOutlet weak var ext: NSTextField!
    @IBOutlet weak var counter: NSTextField!
    @IBOutlet weak var playerName: NSTextField!
    
    override func viewDidLoad () {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateName), name: nameUpdateNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateCounter), name: counterUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateExtension), name: extUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: refreshNotification, object: nil)
    }
    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self, name: nameUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: counterUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: extUpdateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: refreshNotification, object: nil)
        
    }

    func updateName (notif: NSNotification) {
        playerName.stringValue = (notif.userInfo?["name"] as? String)!
    }
    
    func updateCounter (notif: NSNotification) {
         counter.stringValue = String((notif.userInfo?["counter"] as? Int)!)
    }
    
    func updateExtension (notif: NSNotification) {
        ext.textColor = ((notif.userInfo?["ext"] as? Int)! < 1) ? .red : .green
    }
    
    func refresh () {
        playerName.stringValue = "Choose Player"
        counter.stringValue = String(0)
        ext.textColor = .black
    }
}
