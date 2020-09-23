//
//  GestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

protocol GestureViewDelegate {
    func correct(_ gesture: Gesture)
    func incorrect(_ gesture: Gesture, feedback: String?)
}

class GestureView: UIView {
    
    var delegate: GestureViewDelegate?
    var gesture: Gesture!
    
    convenience init(gesture: Gesture) {
        self.init()
        self.gesture = gesture
        
        isAccessibilityElement = true
        accessibilityLabel = gesture.description
    }
    
    func correct() {
        delegate?.correct(gesture)
    }
    
    func incorrect(_ feedback: String?) {
        delegate?.incorrect(gesture, feedback: feedback)
    }
}
