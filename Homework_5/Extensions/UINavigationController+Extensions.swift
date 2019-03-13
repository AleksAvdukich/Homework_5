//
//  UINavigationController+Extensions.swift
//  Homework_5
//
//  Created by Aleksandr Avdukich on 10/03/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
