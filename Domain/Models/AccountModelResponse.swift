//
//  AccountModelResponse.swift
//  Domain
//
//  Created by primozalho.d.filho on 14/12/24.
//

import Foundation

public struct AccountModelResponse: Model {
    public var id: Int
    public var name: String
    public var token: String
    
    public init(id: Int, name: String, token: String) {
        self.id = id
        self.name = name
        self.token = token
    }
}
