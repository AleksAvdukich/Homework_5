//
//  LoadProfileOperation.swift
//  Homework_5
//
//  Created by Aleksandr Avdukich on 10/03/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

class LoadProfileOperation: Operation {
    
    let file = "profile.txt"
    var profile: [String: String]?
    
    override func main() {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = directory.appendingPathComponent(self.file)
            
            do {
                let profile = try Data(contentsOf: fileURL)
                let savedJSON = try JSONSerialization.jsonObject(with: profile, options: .mutableLeaves)
                if let json = savedJSON as? Dictionary<String, String> {
                    self.profile = json
                }
            } catch {
                self.profile = nil
            }
        }
    }
}
