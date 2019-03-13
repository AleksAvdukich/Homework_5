//
//  OperationDataManager.swift
//  Homework_5
//
//  Created by Aleksandr Avdukich on 10/03/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

class OperationDataManager: ProfileDataManagerDelegate {
    
    var profile: [String: String]?
    
    func saveProfileInfo(name: String, description: String?, photo: String, isDone: @escaping (Bool) -> ()) {
        self.profile = ["name": name, "description": description ?? "", "photo": photo]
        let saveProfileOperation = SaveProfileOperation()
        saveProfileOperation.queuePriority = .normal
        saveProfileOperation.profile = self.profile
        saveProfileOperation.completionBlock = {
            OperationQueue.main.addOperation {
                isDone(saveProfileOperation.error)
            }
        }
        OperationQueue().addOperation(saveProfileOperation)
    }
    
    func loadProfileInfo(isDone: @escaping ([String: String]?) -> ()) {
        let loadProfileOperation = LoadProfileOperation()
        loadProfileOperation.queuePriority = .normal
        loadProfileOperation.completionBlock = {
            OperationQueue.main.addOperation {
                isDone(loadProfileOperation.profile)
            }
        }
        OperationQueue().addOperation(loadProfileOperation)
    }
}
