//
//  GCDDataManager.swift
//  Homework_5
//
//  Created by Aleksandr Avdukich on 10/03/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

class GCDDataManager: ProfileDataManagerDelegate {
    
    private let file = "profile.txt"
    
    func saveProfileInfo(name: String, description: String?, photo: String, isDone: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: .default).async {
            let error = self.saveProfile(with: name, with: description ?? "", with: photo)
            DispatchQueue.main.async {
                isDone(error)
            }
        }
    }
    
    func loadProfileInfo(isDone: @escaping ([String: String]?) -> ()) {
        DispatchQueue.global(qos: .default).async {
            let profile = self.getProfile()
            DispatchQueue.main.async {
                isDone(profile)
            }
        }
    }
    
    private func saveProfile(with name: String, with description: String, with photo: String) -> Bool {
        let profileDictionary = ["name": name, "description": description, "photo": photo]
        
        do {
            if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = directory.appendingPathComponent(self.file)
                
                do {
                    let savedJSON = try JSONSerialization.data(withJSONObject: profileDictionary, options: .init(rawValue: 0))
                    try savedJSON.write(to: fileURL)
                }
            }
            
            return false
        } catch {
            return true
        }
    }
    
    private func getProfile() -> [String: String]? {
        var profileDictionary: [String: String]?
        
        do {
            if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = directory.appendingPathComponent(self.file)
                
                do {
                    let profileData = try Data(contentsOf: fileURL)
                    let loadedJSON = try JSONSerialization.jsonObject(with: profileData, options: .mutableContainers)
                    if let json = loadedJSON as? Dictionary<String, String> {
                        profileDictionary = json
                    }
                }
            }
            
            return profileDictionary
        } catch {
            return nil
        }
    }
}
