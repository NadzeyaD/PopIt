//
//  GameOverViewController.swift
//  CatchMe
//
//  Created by Nadia on 3/24/20.
//  Copyright © 2020 Nadzeya. All rights reserved.
//

import UIKit

final class GameOverViewController: UIViewController {
    
    var onDismiss: (() -> Void)?
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(score)
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        dismiss(animated: true) {
            guard let onDismiss = self.onDismiss else { return }
            
            onDismiss()
        }
    }
}

