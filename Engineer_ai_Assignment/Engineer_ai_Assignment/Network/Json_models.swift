//
//  Json_models.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 14.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//

import Foundation

struct AnswerObject: Codable {
    var status: Bool
    var message: String?
    var data: AnswerData
}

struct AnswerData: Codable {
    var users: [User]
    var has_more: Bool
}

struct User: Codable {
    var name: String?
    var image: String?
    var items: [String]?
}
