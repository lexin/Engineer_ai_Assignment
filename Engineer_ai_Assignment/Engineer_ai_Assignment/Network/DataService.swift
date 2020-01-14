//
//  DataService.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 14.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//

import Foundation

class DataService{

    static let sh : DataService = {
        let instance = DataService()
        return instance
    }()


    func getTest(test:String, completion: @escaping (TestObject?) -> Void, errorMessage: @escaping (String) -> Void) {
        APIManager.sh.getSmth(test: test) { (data, err) in
            guard let data = data else {
				return errorMessage("data is absent")
            }
            guard let object = try? JSONDecoder().decode(TestObject.self, from: data) else {
                return errorMessage("err Text")
            }
            completion(object)
        }
    }
}
