//
//  ViewController.swift
//  GDButton
//
//  Created by Saeid on 5/3/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonView: AnimButtonPanel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSampleButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createSampleButtons(){
        buttonView.addButton(with: "test number 1", icon: UIImage(named: "clock")!, handler: { _ in
            print("Hello! i am button 1")
        })
        buttonView.addButton(with: "test number 2", icon: UIImage(named: "exchange")!, handler: { _ in
            print("Hello! i am button 2")
        })
        buttonView.addButton(with: "test number 3", icon: UIImage(named: "clock")!, handler: { _ in
            print("Hello! i am button 3")
        })
        buttonView.addButton(with: "test number 4", icon: UIImage(named: "exchange")!, handler: { _ in
            print("Hello! i am button 4")
        })

    }
}

