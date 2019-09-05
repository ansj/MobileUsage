//
//  Model.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 5/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import Foundation

public struct dataStore: Codable {
    public let help: String
    public let success: Bool
    public let result: result
}

public struct result: Codable {
    public let resource_id: String
    public let _links: link
    public let limit: Int
    public let total: Int
    public let records: [record]
}

public struct record: Codable {
    public let _id: Int
    public let quarter: String
    public let volume_of_mobile_data: String
}

public struct link: Codable {
    public let start: String
    public let next: String
}
