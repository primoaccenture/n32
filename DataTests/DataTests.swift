//
//  DataTests.swift
//  DataTests
//
//  Created by primozalho.d.filho on 13/12/24.
//

import XCTest
@testable import Data
@testable import Domain

final class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_with_correct_url() throws {
        let url = URL(string: "localhost")!
        let (sut, httpClientSpy) = makeSUT(url: url)
        
        sut.add(accountModel: makeAddAccountModel()) { _ in }
        
        XCTAssertEqual(httpClientSpy.url, url)
        XCTAssertEqual(httpClientSpy.callsCount, 1)
    }
    
    func test_add_should_call_with_correct_data() throws {
        let (sut, httpClientSpy) = makeSUT()
        let accountModel = makeAddAccountModel()
        let data = try? JSONEncoder().encode(accountModel)
        
        sut.add(accountModel: accountModel) { _ in }
        
        XCTAssertEqual(httpClientSpy.data, data)
    }
    
    func test_add_should_complete_with_error() throws {
        let (sut, httpClientSpy) = makeSUT()
        let expec = expectation(description: "waiting async call")
        
        sut.add(accountModel: makeAddAccountModel()) { error in
            XCTAssertEqual(error, .unExpected)
            
            //complete async
            expec.fulfill()
        }
        
        //call error
        httpClientSpy.completeWithError(.noConectivity)
        
        wait(for: [expec], timeout: 1)
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
        var url: URL? = nil
        var data: Data? = nil
        var callsCount: Int = 0
        var completion: ((HttpError) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void ) {
            self.url = url
            self.data = data
            self.callsCount += 1
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(error)
        }
    }

}
