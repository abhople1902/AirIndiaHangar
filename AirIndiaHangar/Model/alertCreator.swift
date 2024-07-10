//
//  alertFunction.swift
//  AirIndiaHangar
//
//  Created by E5000848 on 02/07/24.
//

import Foundation
import UIKit

class alertCreator {
    
    static func initializeAlert(_ title: String, _ message: String, actionTitle: String, actionStyle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var action = UIAlertAction()
        switch actionStyle {
        case "cancel":
            action = UIAlertAction(title: actionTitle, style: .cancel)
        case "destructive":
            action = UIAlertAction(title: actionTitle, style: .destructive)
        case "default":
            action = UIAlertAction(title: actionTitle, style: .default)
        default:
            return UIAlertController()
        }
        
        alert.addAction(action)
        return alert
    }
}
