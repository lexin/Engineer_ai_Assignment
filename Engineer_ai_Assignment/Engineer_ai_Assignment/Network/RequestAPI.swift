//
//  API.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 14.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//
import UIKit

extension APIManager {
    
    func getSmth(test:String,completion: @escaping (Data?,_ error: Error?) -> Void) {
        let paramString = ["test": test]
        let paramData = try? JSONSerialization.data(withJSONObject: paramString)
        
        let url:NSURL = NSURL(string: URLServerRequest.test)!
        var request = URLRequest(url: url as URL)
        request.httpMethod = HTTP_METH.POST
        request.httpBody = paramData
        
        self.getDataFromServer(request: request) { data, error in
            completion(data,error)
        }
        
    }
    
}
