//
//  SaveProfileOperation.swift
//  Homework_5
//
//  Created by Aleksandr Avdukich on 10/03/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

class SaveProfileOperation: Operation {
    
    let file = "profile.txt"
    var profile: [String : String]?
    var error: Bool = true
    
    override func main() {
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = directory.appendingPathComponent(self.file)
            
            do {
                if let profile = profile {
                    let savedJSON = try JSONSerialization.data(withJSONObject: profile, options: .init(rawValue: 0))
                    try savedJSON.write(to: fileURL)
                    self.error = false
                }
            } catch {
                print(error)
            }
        }
    }
}
