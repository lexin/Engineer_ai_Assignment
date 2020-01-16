//
//  API.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 14.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//
import UIKit

extension APIManager {
    
    func getUsers(offset:NSInteger, limit:NSInteger, completion: @escaping (Data?,_ error: Error?) -> Void) {
        let paramString = "?offset=\(offset)&limit=\(limit)"

        let url:NSURL = NSURL(string: URLServerRequest.users+paramString)!
        print (url)
        var request = URLRequest(url: url as URL)
        request.httpMethod = HTTP_METH.GET
        
        self.getDataFromServer(request: request) { data, error in
            completion(data,error)
        }
        
    }
    
}
