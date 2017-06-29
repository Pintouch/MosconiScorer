//
//  ActionsHelpers.swift
//  MosconiScorer
//
//  Created by Pintouch on 23/06/2017.
//  Copyright © 2017 Dashpool. All rights reserved.
//

import Foundation

class ActionsHelpers {

    static func hideHome () {
        FileHelpers.writeTofile(value: " ",
                                fileName: "homeCounter.txt")
        self.hideHome60()
        self.hideHome30()
        self.hideHomeExt()
        self.hideHomeSideExt()
        self.hideHomePlaying()
        FileHelpers.writeTofile(value: "",
                                fileName: "homeCounter.txt")

        
    }
    static func hideHomeCounter () {
        FileHelpers.writeTofile(value: " ",
                                fileName: "homeCounter.txt")
        self.hideHome60()
        self.hideHome30()
        self.hideHomeExt()
        self.hideHomeSideExt()
        FileHelpers.writeTofile(value: "",
                                fileName: "homeCounter.txt")
    }
    static func showHome60 (){
        FileHelpers.changeFileName(oldName: "HomeProgress60_No.gif", newName: "HomeProgress60.gif")
        self.hideHome30()
        self.hideHomeExt()
    }
    
    static func hideHome60 (){
        FileHelpers.changeFileName(oldName: "HomeProgress60.gif", newName: "HomeProgress60_No.gif")
        
    }
    
    static func showHome30 () {
        FileHelpers.changeFileName(oldName: "HomeProgress30_No.gif", newName: "HomeProgress30.gif")
        self.hideHome60()
        self.hideHomeExt()
    }
    
    static func hideHome30 () {
        FileHelpers.changeFileName(oldName: "HomeProgress30.gif", newName: "HomeProgress30_No.gif")
    }
    
    static func showHomeExt () {
        FileHelpers.changeFileName(oldName: "HomeExt_No.png", newName: "HomeExt.png")
        self.hideHome60()
        self.hideHome30()
        self.hideHomeSideExt()
    }
    
    static func hideHomeExt () {
        FileHelpers.changeFileName(oldName: "HomeExt.png", newName: "HomeExt_No.png")
    }

    static func showHomeSideExt (isGreen: Bool) {
        if ( isGreen) {
            FileHelpers.changeFileName(oldName: "HomeSideExt_No.png", newName: "HomeSideExt.png")
            FileHelpers.changeFileName(oldName: "HomeSideExt0.png", newName: "HomeSideExt0_No.png")
        }else {
            FileHelpers.changeFileName(oldName: "HomeSideExt.png", newName: "HomeSideExt_No.png")
            FileHelpers.changeFileName(oldName: "HomeSideExt0_No.png", newName: "HomeSideExt0.png")
        }
    }
    
    static func hideHomeSideExt () {
        FileHelpers.changeFileName(oldName: "HomeSideExt.png", newName: "HomeSideExt_No.png")
        FileHelpers.changeFileName(oldName: "HomeSideExt0.png", newName: "HomeSideExt0_No.png")
    }
    
    static func showHomePlaying() {
        FileHelpers.changeFileName(oldName: "isPlayingHome_No.png", newName: "isPlayingHome.png")
        self.hideAwayPlaying()
    }
    static func hideHomePlaying() {
        FileHelpers.changeFileName(oldName: "isPlayingHome.png", newName: "isPlayingHome_No.png")
    }
    
    static func hideAway () {
        FileHelpers.writeTofile(value: " ",
                                fileName: "awayCounter.txt")
        self.hideAway60()
        self.hideAway30()
        self.hideAwayExt()
        self.hideAwaySideExt()
        self.hideAwayPlaying()
        FileHelpers.writeTofile(value: "",
                                fileName: "awayCounter.txt")
    }
    
    static func hideAwayCounter () {
        FileHelpers.writeTofile(value: " ",
                                fileName: "awayCounter.txt")
        self.hideAway60()
        self.hideAway30()
        self.hideAwayExt()
        self.hideAwaySideExt()
        FileHelpers.writeTofile(value: "",
                                fileName: "awayCounter.txt")
    }
    
    static func showAway60 (){
        FileHelpers.changeFileName(oldName: "AwayProgress60_No.gif", newName: "AwayProgress60.gif")
        self.hideAway30()
        self.hideAwayExt()
    }
    
    static func hideAway60 (){
        FileHelpers.changeFileName(oldName: "AwayProgress60.gif", newName: "AwayProgress60_No.gif")
        
    }
    
    static func showAway30 () {
        FileHelpers.changeFileName(oldName: "AwayProgress30_No.gif", newName: "AwayProgress30.gif")
        self.hideAway60()
        self.hideAwayExt()
    }
    
    static func hideAway30 () {
        FileHelpers.changeFileName(oldName: "AwayProgress30.gif", newName: "AwayProgress30_No.gif")
    }
    
    static func showAwayExt () {
        FileHelpers.changeFileName(oldName: "AwayExt_No.png", newName: "AwayExt.png")
        self.hideAway60()
        self.hideAway30()
        self.hideAwaySideExt()
    }
    
    static func hideAwayExt () {
        FileHelpers.changeFileName(oldName: "AwayExt.png", newName: "AwayExt_No.png")
    }
    
    static func showAwaySideExt (isGreen: Bool) {
        if ( isGreen) {
            FileHelpers.changeFileName(oldName: "AwaySideExt_No.png", newName: "AwaySideExt.png")
            FileHelpers.changeFileName(oldName: "AwaySideExt0.png", newName: "AwaySideExt0_No.png")
        }else {
            FileHelpers.changeFileName(oldName: "AwaySideExt.png", newName: "AwaySideExt_No.png")
            FileHelpers.changeFileName(oldName: "AwaySideExt0_No.png", newName: "AwaySideExt0.png")
        }
    }
    
    static func hideAwaySideExt () {
        FileHelpers.changeFileName(oldName: "AwaySideExt.png", newName: "AwaySideExt_No.png")
        FileHelpers.changeFileName(oldName: "AwaySideExt0.png", newName: "AwaySideExt0_No.png")
    }
    
    static func showAwayPlaying() {
        FileHelpers.changeFileName(oldName: "isPlayingAway_No.png", newName: "isPlayingAway.png")
        self.hideHomePlaying()
    }
    static func hideAwayPlaying() {
        FileHelpers.changeFileName(oldName: "isPlayingAway.png", newName: "isPlayingAway_No.png")
    }
    
}
