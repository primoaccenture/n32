//
//  AddAccount.swift
//  Domain
//
//  Created by primozalho.d.filho on 13/12/24.
//

import Foundation

public protocol AddAccount {
    func add(accountModel: AccountModelRequest, completion: @escaping (Result<AccountModelResponse, Error>) -> Void )
}

