//
//  MenuViewController.swift
//  CatchMe
//
//  Created by Nadia on 3/24/20.
//  Copyright © 2020 Nadzeya. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    
    var onDismiss: (() -> Void)?
    var onNewGame: (() -> Void)?
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = String(CurrentRunEnvironment.recordScore)
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        closeMenu(completion: onNewGame)
    }
    
    @IBAction func showRecord(_ sender: UIButton) {
        
    }
    
    @IBAction func exitMenu(_ sender: UIButton) {
        closeMenu(completion: onDismiss)
    }
    
    func closeMenu(completion: (() -> Void)?) {
        dismiss(animated: true) {
           guard let completion = completion else { return }
           
           completion()
       }
    }
}
