//
//  AccountModelRequest.swift
//  Domain
//
//  Created by primozalho.d.filho on 14/12/24.
//

import Foundation

public struct AccountModelRequest: Model {
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
    
    public init(name: String, email: String, password: String, passwordConfirmation: String) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
