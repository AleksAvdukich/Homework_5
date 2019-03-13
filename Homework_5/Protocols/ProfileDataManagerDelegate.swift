//
//  ProfileDataManagerDelegate.swift
//  Homework_5
//
//  Created by Aleksandr Avdukich on 10/03/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

protocol ProfileDataManagerDelegate {
    func saveProfileInfo(name: String, description: String?, photo: String, isDone: @escaping (_ error: Bool) -> ())
    func loadProfileInfo(isDone: @escaping (_ profile: [String: String]?) -> ())
}
