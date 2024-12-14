//
//  DataTests.swift
//  DataTests
//
//  Created by primozalho.d.filho on 13/12/24.
//

import XCTest
import Data
import Domain

final class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_with_correct_url() throws {
        let url = URL(string: "localhost")!
        let (sut, httpClientSpy) = makeSUT(url: url)
        
        sut.add(accountModel: makeAddAccountModel())
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_with_correct_data() throws {
        let (sut, httpClientSpy) = makeSUT()
        let accountModel = makeAddAccountModel()
        let data = try? JSONEncoder().encode(accountModel)
        
        sut.add(accountModel: accountModel)
        
        XCTAssertEqual(httpClientSpy.data, data)
    }
    
}

extension RemoteAddAccountTests {
    func makeSUT(url: URL = URL(string: "localhost")!) -> (RemoteAddAccount, HttpClientSpy) {
        let url = url
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        return (sut, httpClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        let account = AddAccountModel(
            name: "Jose",
            email: "jose@gmail.com",
            password: "123456",
            passwordConfirmation: "123456")
        return account
    }
    
    class HttpClientSpy: HttpClientPost {
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }

}
