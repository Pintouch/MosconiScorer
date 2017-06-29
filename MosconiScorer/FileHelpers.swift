//
//  FileHelpers.swift
//  MosconiScorer
//
//  Created by Pintouch on 22/06/2017.
//  Copyright © 2017 Dashpool. All rights reserved.
//

import Cocoa
import SSZipArchive

class FileHelpers {
    static let fileManager = FileManager.default
    
    static func chooseFolder(viewController: ViewController) {
        let dialog = NSOpenPanel()
        
        dialog.title                   = "Choose a Folder"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                if let url = Bundle.main.url(forResource: "Mosconi", withExtension: "zip") {
                    SSZipArchive.unzipFile(atPath: url.path, toDestination: path)
                    UserDefaults.standard.set(path+"/Mosconi", forKey: "rootPath")
                    do {
                        try fileManager.removeItem(atPath: path+"/__MACOSX")
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                    NSLog("\(path)/Mosconi")
                    viewController.initialisation()
                } else {
                    NSLog("FAIL \(path)")
                }
                
            }
        } else {
            // User clicked on "Cancel"
            return
        }

    }
    static func changeFileName(oldName: String, newName: String) {
//        if let dir = fileManager.urls(for: .root, in: .userDomainMask).first {
//            let oldPath = dir.appendingPathComponent("Mosconi/\(oldName)").path
//            let newPath = dir.appendingPathComponent("Mosconi/\(newName)").path
        let FOLDER_PATH = UserDefaults.standard.string(forKey: "rootPath")
        let oldPath = FOLDER_PATH!+"/\(oldName)"
        let newPath = FOLDER_PATH!+"/\(newName)"
            if (!fileManager.fileExists(atPath: oldPath)) {return}
            
            do {
                try fileManager.moveItem(atPath: oldPath, toPath: newPath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
//        }
    }
    
    static func writeTofile(value: String, fileName: String) {
       // if let dir = fileManager.urls(for: .sharedPublicDirectory, in: .userDomainMask).first {
            let FOLDER_PATH = UserDefaults.standard.string(forKey: "rootPath")
            // let path = dir.appendingPathComponent("Mosconi/\(fileName)")
            let path = FOLDER_PATH!+"/\(fileName)"
            //writing
            do {
                try value.write(to: URL(fileURLWithPath: path), atomically: false, encoding: String.Encoding.utf8)
            }
            catch let error as NSError {
                print("Failed writing to URL: \(path), Error: " + error.localizedDescription)
            }
        // }
    }
    
}
