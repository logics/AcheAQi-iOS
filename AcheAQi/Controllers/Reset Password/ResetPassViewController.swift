//
//  ResetPassViewController.swift
//  AcheAQi
//
//  Created by Romeu Godoi on 14/05/20.
//  Copyright © 2020 Logics Software. All rights reserved.
//

import UIKit
import Spring

class ResetPassViewController: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet var successView: UIView!
    @IBOutlet weak var emailTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func send(_ sender: UIButton) {
        
        showSuccess()
    }
    
    private func showSuccess() {
        
        successView.alpha = 0.0
        self.successView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.successView)
                        
        self.successView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.successView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.successView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -12).isActive = true

        UIView.animate(withDuration: 0.35, animations: {
            self.mainStackView.alpha = 0.0
        }) { finished in
            
            if finished {
                self.mainStackView.removeFromSuperview()
            }
            
            UIView.animate(withDuration: 0.35) {
                self.successView.alpha = 1.0
            }
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
