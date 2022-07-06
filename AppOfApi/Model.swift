//
//  Model.swift
//  AppOfApi
//
//  Created by Akshara Vangala on 14/06/22.
//

import Foundation

struct Model: Codable{
    var page: Int
    var data: [DataDetails]
}

struct DataDetails: Codable{
    var id: Int
    var email: String
    var first_name: String
    var last_name: String
    var avatar: String
}
