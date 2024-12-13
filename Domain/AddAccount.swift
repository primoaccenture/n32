//
//  AddAccount.swift
//  Domain
//
//  Created by primozalho.d.filho on 13/12/24.
//

import Foundation

public protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<String, Error>) -> Void )
}

public struct AddAccountModel {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}
