//
//  ViewController.swift
//  AirIndiaHangar
//
//  Created by E5000848 on 28/06/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var welcomeTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeTextLabel.text = ""
        var charIndex = 0.0
        let titleText = "Welcome to Air India Hangar Management"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1*charIndex, repeats: false) { (timer) in
                self.welcomeTextLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "moveToSignUpScreen", sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "moveToLoginScreen", sender: self)
    }
    

}

