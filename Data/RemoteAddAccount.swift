//
//  RemoteAddAccount.swift
//  Data
//
//  Created by primozalho.d.filho on 13/12/24.
//

import Foundation
import Domain

public final class RemoteAddAccount: AddAccount {
    private let url: URL
    private let httpClient: HttpClientPost
    
    init(url: URL, httpClient: HttpClientPost) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(accountModel: AddAccountModel) {
        httpClient.post(to: url, with: accountModel.toData())
    }
    
    public func add(accountModel: AddAccountModel, completion: @escaping (Result<String, any Error>) -> Void) {
        httpClient.post(to: url, with: accountModel.toData())
    }
    
}
