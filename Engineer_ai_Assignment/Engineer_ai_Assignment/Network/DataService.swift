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


    func getUsers(offset:NSInteger, limit:NSInteger, completion: @escaping (AnswerObject?) -> Void, errorMessage: @escaping (String) -> Void) {
        APIManager.sh.getUsers(offset: offset, limit: limit) { (data, err) in
            guard let data = data else {
				return errorMessage("data is absent")
            }

            let strData = String(decoding: data, as: UTF8.self)
            print(strData)
            guard let object = try? JSONDecoder().decode(AnswerObject.self, from: data) else {
                return errorMessage("err Text")
            }
            completion(object)
        }
    }
}
