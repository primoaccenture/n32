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
        
        sut.add(accountModel: makeAccountModelRequest()) { _ in }
        
        XCTAssertEqual(httpClientSpy.url, url)
        XCTAssertEqual(httpClientSpy.callsCount, 1)
    }
    
    func test_add_should_call_with_correct_data() throws {
        let (sut, httpClientSpy) = makeSUT()
        let accountModelRequest = makeAccountModelRequest()
        let data = try? JSONEncoder().encode(accountModelRequest)
        
        sut.add(accountModel: accountModelRequest) { _ in }
        
        XCTAssertEqual(httpClientSpy.data, data)
    }
    
    func test_add_should_complete_with_error() throws {
        let (sut, httpClientSpy) = makeSUT()
        let expec = expectation(description: "waiting async call")
        
        sut.add(accountModel: makeAccountModelRequest()) { result in
            switch result {
            case .success: 
                XCTFail("Expected error")
            case .failure(let error):
                XCTAssertEqual(error, .unExpected)
            }
            //complete async
            expec.fulfill()
        }
        
        //call error
        httpClientSpy.completeWithError(.noConectivity)
        
        wait(for: [expec], timeout: 1)
    }
    
    func test_add_should_complete_with_success() throws {
        let (sut, httpClientSpy) = makeSUT()
        let accountResponse = makeAccountModelResponse()
        
        expect(sut, completeWith: .success(accountResponse), when: {
            httpClientSpy.completeWithData(accountResponse.toData()!)
        })
    }
    
    func test_add_should_complete_with_error_invalid_data() throws {
        let (sut, httpClientSpy) = makeSUT()
        expect(sut, completeWith: .failure(.invalidData), when: {
            httpClientSpy.completeWithData(Data("invalid_json".utf8))
        })
    }
    
    func test_add_should_not_complete_if_sut_has_been_dealocated() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: URL(string: "localhost")!, httpClient: httpClientSpy)
        var result: Result<AccountModelResponse, DomainError>?
        
        sut?.add(accountModel: makeAccountModelRequest()) { 
            result = $0
            //Not have do this if sut is null
        }
        
        sut = nil
        httpClientSpy.completeWithError(.noConectivity)
        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {
    func makeSUT(url: URL = URL(string: "localhost")!) -> (RemoteAddAccount, HttpClientSpy) {
        let url = url
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        //check if there are memoryLeak
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }
        
        return (sut, httpClientSpy)
    }
    
    func makeAccountModelRequest() -> AccountModelRequest {
        let account = AccountModelRequest(
            name: "Jose",
            email: "jose@gmail.com",
            password: "123456",
            passwordConfirmation: "123456")
        return account
    }
    
    func makeAccountModelResponse() -> AccountModelResponse {
        let account = AccountModelResponse(
            id: 1,
            name: "Jose",
            token: "123456")
        return account
    }
    
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModelResponse, DomainError>, when action: () -> Void ) {
        
        let expec = expectation(description: "waiting async call")
        sut.add(accountModel: makeAccountModelRequest()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case ( .failure(let expectedError), .failure(let receivedError) ):
                XCTAssertEqual(expectedError, receivedError)
            case ( .success(let expectedData ), .success(let receivedData ) ):
                XCTAssertEqual(expectedData, receivedData)
            default:
                XCTFail("Error: Expected \(expectedResult) received \(receivedResult) instead.")
            }
            
            //complete async
            expec.fulfill()
        }
        action()
        wait(for: [expec], timeout: 1)
    }
    
    class HttpClientSpy: HttpClientPost {
        var url: URL? = nil
        var data: Data? = nil
        var callsCount: Int = 0
        var completion: (( Result<Data?, HttpError>) -> Void )?
        
        func post(to url: URL, with data: Data?, completion: @escaping ( Result<Data?, HttpError>) -> Void ) {
            self.url = url
            self.data = data
            self.callsCount += 1
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?( .failure(error) )
        }
        
        func completeWithData(_ data: Data) {
            completion?( .success(data) )
        }
    }

}
