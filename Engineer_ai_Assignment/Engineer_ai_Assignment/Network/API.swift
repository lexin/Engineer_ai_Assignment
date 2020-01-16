//
//  API.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 14.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//

import UIKit


enum API{
       enum Content_Type{
           static let headerFieldValue = "application/json"
           static let headerFieldKey = "Content-Type"
       }
   }

enum URLServerRequest {
    private static let HTTP_DOMEN_API = "http://sd2-hiring.herokuapp.com/api/" //dev
    static let users = HTTP_DOMEN_API + "users"
}
 
enum HTTP_METH {
    static let POST = "POST"
    static let GET = "GET"
}

class APIManager {
    
    static let sh : APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    func getDataFromServer(request:URLRequest, completion: @escaping (Data?,_ error: Error?) -> Void) {
        
        var request = request
        request.setValue(API.Content_Type.headerFieldValue, forHTTPHeaderField: API.Content_Type.headerFieldKey)

        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            DispatchQueue.main.async {
                if let data = data, err == nil {
                    completion(data, nil)
                } else {
                    completion(nil, err)
                }
            }
        }
        task.resume()
    }


}


