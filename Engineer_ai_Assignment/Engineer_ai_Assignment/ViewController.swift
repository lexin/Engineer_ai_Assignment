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
        // Do any additional setup after loading the view.
    }

    @IBAction func btnClick(_ sender: Any) {
        DataService.sh.getTest(test: "test", completion: { (object) in
			//--
        }) { (errorText) in
			//--
        }
        self.performSegue(withIdentifier: "pushList", sender: self)
    }
    
}

