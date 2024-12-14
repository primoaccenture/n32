//
//  RemoteAddAccount.swift
//  Data
//
//  Created by primozalho.d.filho on 13/12/24.
//

import Foundation
import Domain

public final class RemoteAddAccount {
    private let url: URL
    private let httpClient: HttpClientPost
    
    init(url: URL, httpClient: HttpClientPost) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(accountModel: AccountModelRequest,
                    completion: @escaping ( Result<AccountModelResponse, DomainError> ) -> Void) {
        httpClient.post(to: url, with: accountModel.toData()) { result in
            switch result {
            case .success(let data):
                if let model: AccountModelResponse = data?.toModel() {
                    completion(.success(model))
                }
            case .failure: 
                completion(.failure(.unExpected))
            }
        }
    }
    
}
