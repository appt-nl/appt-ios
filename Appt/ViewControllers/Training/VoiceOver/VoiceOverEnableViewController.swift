//
//  VoiceOverEnableViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 18/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import Accessibility

class VoiceOverEnableViewController: ViewController {
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.font = .sourceSansPro(weight: .regular, size: 18, style: .body)
        Accessibility.layoutChanged(textView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false) // Avoids auto scroll to bottom
    }
}
