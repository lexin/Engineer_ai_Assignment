//
//  ViewController.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 13.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        btnClick(self)
    }

    @IBAction func btnClick(_ sender: Any) {

        self.performSegue(withIdentifier: "pushList", sender: self)
    }
    
}

