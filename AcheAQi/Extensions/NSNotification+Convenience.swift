//
//  NSNotification+Convenience.swift
//  Testie
//
//  Created by Romeu Godoi on 05/07/18.
//  Copyright © 2018 Logics Tecnologia e Serviços. All rights reserved.
//

import UIKit

extension NSNotification {
    func wasOpened() -> Bool {
        if let action = userInfo?["action"] as? String, action == NotificationAction.open {
            return true
        }
        else {
            return false
        }
    }
}
