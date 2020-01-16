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
        DataService.sh.getUsers(offset: 0, limit: 20, completion: { (object) in
            print (object?.data.users.count)
            guard let answerData = object?.data else {
                print("Something wrong")
                return                
            }

            for user in answerData.users {
                print(user.name)
            }
			//--
        }) { (errorText) in
			//--
        }
       /// self.performSegue(withIdentifier: "pushList", sender: self)
    }
    
}

