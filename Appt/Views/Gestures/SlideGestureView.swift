//
//  SlideGestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 17/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import AVFoundation

class SlideGestureView: LongPressGestureView {

    private var THRESHOLD:CGFloat = 50
    
    private var startLocation: CGPoint?
    private var completed = false
    
    convenience init(gesture: Gesture) {
        self.init(gesture: gesture, numberOfTaps: 1, numberOfFingers: 1, minimumDuration: 2.0)
    }
    
    override func onLongPress(_ sender: UILongPressGestureRecognizer) {
        guard !completed else { return }
        
        let location = sender.location(in: self)
        
        if sender.state == .began {
            // Step 2: store start location
            startLocation = location
            AudioServicesPlaySystemSound(SystemSoundID(1255))
        } else if sender.state == .changed {
            // Step 3: check if dragged horizontally
            if let startLocation = startLocation, abs(location.x - startLocation.x) > THRESHOLD {
                completed = true
                delegate?.correct(gesture)
            }
        } else if !completed {
            startLocation = nil
            delegate?.incorrect(gesture)
        }
    }
}