//
//  ViewController.swift
//  MosconiScorer
//
//  Created by Pintouch on 21/06/2017.
//  Copyright © 2017 Dashpool. All rights reserved.
//

import Cocoa
import AVFoundation
enum PlayingStatus {
    case home
    case away
    case none
}

let nameUpdateNotification = Notification.Name("NAME_UPDATE")
let counterUpdateNotification = Notification.Name("COUNTER_UPDATE")
let extUpdateNotification = Notification.Name("EXT_UPDATE")
let refreshNotification = Notification.Name("REFRESH")

extension NSView {
    
    var backgroundColor: NSColor? {
        
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}

class ViewController: NSViewController {

    var audioPlayer : AVAudioPlayer!
    let BREAK_TIME = 60
    let NORMAL_TIME = 30
    let EXT_TIME = 30
    
    var currentPlayer : PlayingStatus = .none
    var playerRace = 5
    var teamRace = 11
    var homeTeamName = "Home"
    var awayTeamName = "Away"
    dynamic var homePlayerName = "Player 1"
    var awayPlayerName = "Player 2"
    var homeTeamScore = 0
    var awayTeamScore = 0
    var homePlayerScore = 0
    var awayPlayerScore = 0
    var homeExtCounter = 1
    var awayExtCounter = 1
    dynamic var homeCounter = 0
    var awayCounter = 0
    var isExtensionCalled = false
    var is60Active = false
    weak var timer : Timer?
    
    @IBOutlet weak var segmentPlayingControl: NSSegmentedControl!
    @IBOutlet weak var homeZoneView: NSView!
    @IBOutlet weak var awayZoneView: NSView!
    @IBOutlet weak var cleanAwayBtn: NSButton!
    @IBOutlet weak var cleanHomeBtn: NSButton!
    @IBOutlet weak var awayPlayerNameTf: NSTextField!
    @IBOutlet weak var awayTeamNameTf: NSTextField!
    @IBOutlet weak var homePlayerNameTf: NSTextField!
    @IBOutlet weak var homeTeamNameTf: NSTextField!
    @IBOutlet weak var playerRaceTextField: NSTextField!
    @IBOutlet weak var teamRaceTextField: NSTextField!
    @IBOutlet weak var awayAddPlayerScoreBtn: NSButton!
    @IBOutlet weak var awayMinusPlayerScoreBtn: NSButton!
    @IBOutlet weak var homeAddPlayerScoreBtn: NSButton!
    @IBOutlet weak var homeMinusPlayerScoreBtn: NSButton!
    @IBOutlet weak var awayMinusTeamScoreBtn: NSButton!
    @IBOutlet weak var awayAddTeamScoreBtn: NSButton!
    @IBOutlet weak var homeMinusTeamScoreBtn: NSButton!
    @IBOutlet weak var homeAddTeamScoreBtn: NSButton!
    @IBOutlet weak var homeTeamScoreLabel: NSTextField!
    @IBOutlet weak var awayTeamScoreLabel: NSTextField!
    @IBOutlet weak var homePlayerScoreLabel: NSTextField!
    @IBOutlet weak var awayPlayerScoreLabel: NSTextField!
    @IBOutlet weak var homeExtCheck: NSButton!
    @IBOutlet weak var awayExtCheck: NSButton!
    @IBOutlet weak var homeCounterLabel: NSTextField!
    @IBOutlet weak var awayCounterLabel: NSTextField!
    @IBOutlet weak var startCounterBtn: NSButton!
    @IBOutlet weak var startBkCounterBtn: NSButton!
    
    override func viewDidLoad () {
        super.viewDidLoad()
        if let asset = NSDataAsset(name:"Buzzer"){
            do {
                try self.audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint:"wav")
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        self.view.wantsLayer = true
        // self.audioPlayer = AVAudioPlayer(contentsOf:  URL(fileURLWithPath: Bundle.main.path(forResource: "Buzzer", ofType: "wav")!))
        if (UserDefaults.standard.string(forKey: "rootPath") != nil) {
            self.initialisation()
        } else {
            FileHelpers.chooseFolder(viewController : self)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func enablingPlayButtons(isEnabled: Bool) {
        startCounterBtn.isEnabled = isEnabled
        startBkCounterBtn.isEnabled = isEnabled
    }
    func initialisation() -> Void {
        resetBalls()
        homeTeamNameTf.stringValue = homeTeamName
        homePlayerNameTf.stringValue = homePlayerName
        awayTeamNameTf.stringValue = awayTeamName
        awayPlayerNameTf.stringValue = awayPlayerName
        teamRaceTextField.stringValue = String(teamRace)
        playerRaceTextField.stringValue = String(playerRace)
        ActionsHelpers.hideHome()
        ActionsHelpers.hideAway()
        refreshScore()
        enablingPlayButtons(isEnabled: false)
    }
    func refreshPlaying() {
        if(currentPlayer == .home) {
            ActionsHelpers.showHomePlaying()
        }else if(currentPlayer == .away) {
            ActionsHelpers.showAwayPlaying()
        }else {
            ActionsHelpers.hideHomePlaying()
            ActionsHelpers.hideAwayPlaying()
            homeZoneView.backgroundColor = .clear
            awayZoneView.backgroundColor = .clear
            segmentPlayingControl.setEnabled(true, forSegment: 1)
            segmentPlayingControl.selectedSegment = 1
        }
    }
    
    func buttonDisablerForTimer () {
        if (currentPlayer == .home) {
            awayExtCheck.isEnabled = false
            homeExtCheck.isEnabled = !(homeExtCounter == 0)
            segmentPlayingControl.setEnabled(timer == nil, forSegment: 2)
        }else if(currentPlayer == .away) {
            homeExtCheck.isEnabled = false
            awayExtCheck.isEnabled = !(awayExtCounter == 0)
            segmentPlayingControl.setEnabled(timer == nil, forSegment: 0)
        } else {
            awayExtCheck.isEnabled = true
            homeExtCheck.isEnabled = true
        }
    }

    func refreshPlayerInfos() {
        FileHelpers.writeTofile(value: homePlayerName,
                                fileName: "homePlayerName.txt")
        FileHelpers.writeTofile(value: awayPlayerName,
                                fileName: "awayPlayerName.txt")
        FileHelpers.writeTofile(value: String(playerRace),
                                fileName: "playerRace.txt")
    }
    func refreshTeamInfos() {
        FileHelpers.writeTofile(value: String(teamRace),
                                fileName: "teamRace.txt")
        FileHelpers.writeTofile(value: homeTeamName,
                                fileName: "homeTeamName.txt")
        FileHelpers.writeTofile(value: awayTeamName,
                                fileName: "awayTeamName.txt")
    }
    func refreshScore () {
        if(homePlayerScore == playerRace) {
            homeTeamScore += 1
        }
        if ( awayPlayerScore == playerRace) {
            awayTeamScore += 1
        }
        if (homeTeamScore == 0) {
            homeMinusTeamScoreBtn.isEnabled = false
            homeAddTeamScoreBtn.isEnabled = true
        } else if (homeTeamScore == teamRace) {
            homeMinusTeamScoreBtn.isEnabled = true
            homeAddTeamScoreBtn.isEnabled = false
        } else {
            homeMinusTeamScoreBtn.isEnabled = true
            homeAddTeamScoreBtn.isEnabled = true
        }
        if (awayTeamScore == 0) {
            awayMinusTeamScoreBtn.isEnabled = false
            awayAddTeamScoreBtn.isEnabled = true
        } else if (awayTeamScore == teamRace) {
            awayMinusTeamScoreBtn.isEnabled = true
            awayAddTeamScoreBtn.isEnabled = false
        } else {
            awayMinusTeamScoreBtn.isEnabled = true
            awayAddTeamScoreBtn.isEnabled = true
        }
        if (homePlayerScore == 0) {
            homeMinusPlayerScoreBtn.isEnabled = false
            homeAddPlayerScoreBtn.isEnabled = true
        } else if (homePlayerScore == playerRace) {
            homeMinusPlayerScoreBtn.isEnabled = true
            homeAddPlayerScoreBtn.isEnabled = false
        } else {
            homeMinusPlayerScoreBtn.isEnabled = true
            homeAddPlayerScoreBtn.isEnabled = true
        }
        if (awayPlayerScore == 0) {
            awayMinusPlayerScoreBtn.isEnabled = false
            awayAddPlayerScoreBtn.isEnabled = true
        } else if (awayPlayerScore == playerRace) {
            awayMinusPlayerScoreBtn.isEnabled = true
            awayAddPlayerScoreBtn.isEnabled = false
        } else {
            awayMinusPlayerScoreBtn.isEnabled = true
            awayAddPlayerScoreBtn.isEnabled = true
        }


        homePlayerScoreLabel.stringValue = String(homePlayerScore)
        awayPlayerScoreLabel.stringValue = String(awayPlayerScore)
        homeTeamScoreLabel.stringValue = String(homeTeamScore)
        awayTeamScoreLabel.stringValue = String(awayTeamScore)
        
        FileHelpers.writeTofile(value: String(homePlayerScore),
                                fileName: "homePlayerScore.txt")
        FileHelpers.writeTofile(value: String(awayPlayerScore),
                                fileName: "awayPlayerScore.txt")
        FileHelpers.writeTofile(value: String(homeTeamScore),
                                fileName: "homeTeamScore.txt")
        FileHelpers.writeTofile(value: String(awayTeamScore),
                                fileName: "awayTeamScore.txt")
        
    }

    func resetGame() {
        
        currentPlayer = .none
        homeCounter = 0
        awayCounter = 0
        homeExtCounter = 1
        awayExtCounter = 1
        is60Active = false
        isExtensionCalled = false
        homeCounterLabel.stringValue = String(homeCounter)
        awayCounterLabel.stringValue = String(awayCounter)
        homeExtCheck.state = NSOffState
        awayExtCheck.state = NSOffState
        refreshScore()
        refreshPlaying()
        resetBalls()
        enablingPlayButtons(isEnabled: false)
        NotificationCenter.default.post(name: refreshNotification, object: nil)
    }
    func resetBalls() {
        for i in 1...9 {
            let button = self.view.viewWithTag(i) as? NSButton
            
            let oldName = "\(button?.tag ?? 0) Ball Disabled.png"
            let ballName = "\(button?.tag ?? 0) Ball.png"
            FileHelpers.changeFileName(oldName: oldName, newName: ballName)
            button?.image = NSImage(named: ballName)
            button?.state = NSOffState
        }
    }
    func initCounters(time: Int) {
        is60Active = false
        isExtensionCalled = false
        if (currentPlayer == .home){
            homeCounter = time
            awayCounter = 0
            ActionsHelpers.showHomeSideExt(isGreen: (homeExtCounter>0))
            if (homeCounter == 60) {
                ActionsHelpers.showHome60()
            } else if (homeCounter == 30) {
                ActionsHelpers.showHome30()
            }
        } else if( currentPlayer == .away) {
            awayCounter = time
            homeCounter = 0
            ActionsHelpers.showAwaySideExt(isGreen: (awayExtCounter>0))
            if (awayCounter == 60) {
                ActionsHelpers.showAway60()
            } else if (awayCounter == 30) {
                ActionsHelpers.showAway30()
            }

        }
        homeCounterLabel.textColor = .black
        homeCounterLabel.stringValue = String(homeCounter)
        awayCounterLabel.textColor = .black
        awayCounterLabel.stringValue = String(awayCounter)
    }

    func updateCounterHome() {

        if (homeCounter>0) {
            homeCounter -= 1
            if (homeCounter < 6){
                homeCounterLabel.textColor = .red
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            NotificationCenter.default.post(name: counterUpdateNotification, object: nil, userInfo:["counter": homeCounter])
            homeCounterLabel.stringValue = String(homeCounter)
            FileHelpers.writeTofile(value: String(homeCounter),
                                    fileName: "homeCounter.txt")
            if(isExtensionCalled && homeCounter == 29 && !is60Active){
                ActionsHelpers.hideHomeExt()
                ActionsHelpers.showHomeSideExt(isGreen: homeExtCounter > 0)
                ActionsHelpers.showHome30()
                
            }else if(isExtensionCalled && homeCounter == 59) {
                ActionsHelpers.hideHomeExt()
                ActionsHelpers.showHomeSideExt(isGreen: homeExtCounter > 0)
                ActionsHelpers.showHome60()
                is60Active = true
            }
            
        } else {
            startCounterBtn.title = "Start Timer"
            self.timer?.invalidate()
            self.timer = nil
            ActionsHelpers.hideHomeCounter()
            buttonDisablerForTimer()
        }
    }
    func updateCounterAway() {
        if(isExtensionCalled && awayCounter == 30 && !is60Active){
            ActionsHelpers.hideAwayExt()
            ActionsHelpers.showAwaySideExt(isGreen: awayExtCounter > 0)
            ActionsHelpers.showAway30()
            awayCounterLabel.textColor = .black
        }else if(isExtensionCalled && awayCounter == 60) {
            ActionsHelpers.hideAwayExt()
            ActionsHelpers.showAwaySideExt(isGreen: awayExtCounter > 0)
            ActionsHelpers.showAway60()
            awayCounterLabel.textColor = .black
            is60Active = true
        }

        if ( awayCounter>0 ) {
            awayCounter -= 1
           
            if (awayCounter < 6){
                awayCounterLabel.textColor = .red
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            NotificationCenter.default.post(name: counterUpdateNotification, object: nil, userInfo:["counter": awayCounter])
            awayCounterLabel.stringValue = String(awayCounter)
            FileHelpers.writeTofile(value: String(awayCounter),
                                    fileName: "awayCounter.txt")
        } else {
            startCounterBtn.title = "Start Timer"
            self.timer?.invalidate()
            self.timer = nil
            ActionsHelpers.hideAwayCounter()
            buttonDisablerForTimer()
        }
    }
       @IBAction func ballClicked (_ sender: Any) {
        let button = (sender as! NSButton)
        let ballName = (button.state == NSOnState) ? "\(button.tag) Ball Disabled.png" : "\(button.tag) Ball.png"
        let oldBallName = (button.state != NSOnState) ? "\(button.tag) Ball Disabled.png" : "\(button.tag) Ball.png"
        FileHelpers.changeFileName(oldName: oldBallName, newName: ballName)
        button.image = NSImage(named: ballName.components(separatedBy: ".").first!)
        if (button.tag == 9) {
            if(currentPlayer == .home) {
                homePlayerScore += 1
            }else if (currentPlayer == .away) {
                awayPlayerScore += 1
            }
            resetGame()
        }
    }
    
    @IBAction func startBreakCounter (_ sender: Any) {
        if (self.timer != nil) {
            self.timer?.invalidate()
            self.timer = nil

            if (currentPlayer == .home){
                ActionsHelpers.hideHomeCounter()
                
            }else if (currentPlayer == .away) {
                ActionsHelpers.hideAwayCounter()
            } else {
                ActionsHelpers.hideHomeCounter()
                ActionsHelpers.hideAwayCounter()
            }
            startCounterBtn.isEnabled = true
            startBkCounterBtn.title = "Start Break/Push Timer"
            buttonDisablerForTimer()
            return
        }

        initCounters(time: self.BREAK_TIME)
        if (currentPlayer == .home){
            homeCounterLabel.stringValue = String(homeCounter)
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterHome), userInfo: nil, repeats: true)
            startCounterBtn.isEnabled = false
            startBkCounterBtn.title = "Stop Timer"
        }else if (currentPlayer == .away) {
            awayCounterLabel.stringValue = String(awayCounter)
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterAway), userInfo: nil, repeats: true)

            startCounterBtn.isEnabled = false
            startBkCounterBtn.title = "Stop Timer"
        }
        buttonDisablerForTimer()
    }
    
    @IBAction func segmentPlayingClick(_ sender: Any) {
        switch segmentPlayingControl.selectedSegment
        {
        case 0:
            currentPlayer = .home
            awayCounter = 0
            awayCounterLabel.stringValue = String(awayCounter)
            NotificationCenter.default.post(name: nameUpdateNotification, object: nil, userInfo:["name": homePlayerName])
            NotificationCenter.default.post(name: extUpdateNotification, object: nil, userInfo:["ext" : homeExtCounter])
            NotificationCenter.default.post(name: counterUpdateNotification, object: nil, userInfo:["counter": homeCounter])
            homeExtCheck.isEnabled = (homeExtCounter>0)
            awayExtCheck.isEnabled = false
            refreshPlaying()
            enablingPlayButtons(isEnabled: true)
            segmentPlayingControl.setEnabled(false, forSegment: 1)
            awayZoneView.backgroundColor = .clear
            homeZoneView.backgroundColor = .green
            break
        case 1:
            currentPlayer = .none
            ActionsHelpers.hideHomePlaying()
            ActionsHelpers.hideAwayPlaying()
            homeZoneView.backgroundColor = .clear
            awayZoneView.backgroundColor = .clear
            break
        case 2:
            currentPlayer = .away
            homeCounter = 0
            homeCounterLabel.stringValue = String(homeCounter)
            NotificationCenter.default.post(name: nameUpdateNotification, object: nil, userInfo:["name": awayPlayerName])
            NotificationCenter.default.post(name: extUpdateNotification, object: nil, userInfo:["ext" : awayExtCounter])
            NotificationCenter.default.post(name: counterUpdateNotification, object: nil, userInfo:["counter": awayCounter])
            homeExtCheck.isEnabled = false
            awayExtCheck.isEnabled = (awayExtCounter>0)
            refreshPlaying()
            enablingPlayButtons(isEnabled: true)
            segmentPlayingControl.setEnabled(false, forSegment: 1)
            homeZoneView.backgroundColor = .clear
            awayZoneView.backgroundColor = .green

            break
        default:
            break
        }

    }
    @IBAction func homeExtClicked(_ sender: Any) {
        if (homeExtCounter > 0 && timer != nil && currentPlayer == .home) {
            
            self.homeCounter += self.EXT_TIME
            isExtensionCalled = true
            ActionsHelpers.showHomeExt()
            homeExtCheck.isEnabled = false
            homeCounterLabel.textColor = .black
            homeExtCounter = 0
            NotificationCenter.default.post(name: extUpdateNotification, object: nil, userInfo:["ext" : homeExtCounter])
        }else {
            homeExtCheck.state = NSOffState
        }
    }
    @IBAction func awayExtClicked(_ sender: Any) {
        if (awayExtCounter > 0 && timer != nil && currentPlayer == .away) {
            self.awayCounter += self.EXT_TIME
            isExtensionCalled = true
            ActionsHelpers.showAwayExt()
            awayExtCheck.isEnabled = false
            awayCounterLabel.textColor = .black
            awayExtCounter = 0
            NotificationCenter.default.post(name: extUpdateNotification, object: nil, userInfo: ["ext" : awayExtCounter])
        }
        else {
            awayExtCheck.state = NSOffState
        }
    }

    @IBAction func startCounter (_ sender: Any) {
        
        if (self.timer != nil) {
            self.timer?.invalidate()
            self.timer = nil
            startBkCounterBtn.isEnabled = true
            startCounterBtn.title = "Start Timer"
            buttonDisablerForTimer()
            if (currentPlayer == .home) {
                ActionsHelpers.hideHomeCounter()
            }else if (currentPlayer == .away){
                ActionsHelpers.hideAwayCounter()
            }else {
                ActionsHelpers.hideHomeCounter()
                ActionsHelpers.hideAwayCounter()
            }
            return
        }
        initCounters(time: self.NORMAL_TIME)
        
        if (currentPlayer == .home){
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterHome), userInfo: nil, repeats: true)
            startBkCounterBtn.isEnabled = false
            startCounterBtn.title = "Stop Timer"
            
        }else if (currentPlayer == .away) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterAway), userInfo: nil, repeats: true)
            startBkCounterBtn.isEnabled = false
            startCounterBtn.title = "Stop Timer"
        }
        buttonDisablerForTimer()

    }
    @IBAction func resetClicked(_ sender: Any) {
        self.resetGame()
    }
    
    @IBAction func resetPlayerScoreClick(_ sender: Any) {
        self.homePlayerScore = 0
        self.awayPlayerScore = 0
        refreshScore()
    }
    @IBAction func homeTeamMinusClick(_ sender: Any) {
        self.homeTeamScore -= 1
        refreshScore()
    }
    @IBAction func awayTeamMinusClick(_ sender: Any) {
        self.awayTeamScore -= 1
        refreshScore()
    }
    @IBAction func homeTeamAddClick(_ sender: Any) {
        self.homeTeamScore += 1
        refreshScore()
    }
    @IBAction func awayTeamAddClick(_ sender: Any) {
        self.awayTeamScore += 1
        refreshScore()
    }
    @IBAction func homePlayerMinusClick(_ sender: Any) {
        self.homePlayerScore -= 1
        refreshScore()
    }
    @IBAction func awayPlayerMinusClick(_ sender: Any) {
        self.awayPlayerScore -= 1
        refreshScore()
    }
    @IBAction func homePlayerAddClick(_ sender: Any) {
        self.homePlayerScore += 1
        refreshScore()
    }
    @IBAction func awayPlayerAddClick(_ sender: Any) {
        self.awayPlayerScore += 1
        refreshScore()
    }
    @IBAction func updateTeamClick(_ sender: Any) {
        self.homeTeamName = self.homeTeamNameTf.stringValue
        self.awayTeamName = self.awayTeamNameTf.stringValue
        self.teamRace = (self.teamRaceTextField.stringValue == "") ? 1 : Int(self.teamRaceTextField.stringValue)!
        refreshTeamInfos()
    }
    @IBAction func updatePlayerClick(_ sender: Any) {
        self.homePlayerName = self.homePlayerNameTf.stringValue
        self.awayPlayerName = self.awayPlayerNameTf.stringValue
        self.playerRace = (self.playerRaceTextField.stringValue == "") ? 1 : Int(self.playerRaceTextField.stringValue)!
        refreshPlayerInfos()
    }

    @IBAction func cleanHomeClick(_ sender: Any) {
        if (timer == nil) {homeCounter = 0}
        FileHelpers.writeTofile(value: " ",
                                fileName: "homeCounter.txt")
    }
    @IBAction func cleanAwayClick(_ sender: Any) {
        if (timer == nil) {awayCounter = 0}
        FileHelpers.writeTofile(value: " ",
                                fileName: "awayCounter.txt")
    }
    @IBAction func showVisualizerClick(_ sender: Any) {
        
    }
    
}



