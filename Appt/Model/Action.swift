//
//  Action.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 02/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

enum Action: String {

    // Navigation
    case headings
    case links
    
    // Modify
    case selection
    case copy
    case paste
    
    /** Title */
    var title: String {
        return NSLocalizedString("action_"+rawValue+"_title", comment: "")
    }
    
    /* View */
    var view: VoiceOverView {
    switch self {
        case .headings:
            return VoiceOverHeadingsView.create(self)
        case .links:
            return VoiceOverLinksView.create(self)
        
        case .selection:
            return VoiceOverSelectionView.create(self)
        case .copy:
            return VoiceOverCopyView.create(self)
        case .paste:
            return VoiceOverPasteView.create(self)
        }
    }
    
    /** Completed? */
    var completed: Bool {
       set {
           UserDefaults.standard.set(newValue, forKey: rawValue)
       }
       get {
           return UserDefaults.standard.bool(forKey: rawValue)
       }
    }
}
