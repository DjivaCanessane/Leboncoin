//
//  NetworkServiceTestCase.swift
//  LeboncoinTests
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import XCTest
@testable import Leboncoin

class NetworkServiceTestCase: XCTestCase {
    var networkServiceFake: NetworkService!

    // MARK: - getNetworkResponse() tests

    func testGetNetworkResponse_ShouldPostFailedCallback_WithHasError_WhenSessionErrorIsNotNil() {
        setUpFakes(data: nil, response: nil, error: FakeResponseData.error)
        shouldGet(expectedError: .hasError)
    }

    func testGetNetworkResponse_ShouldPostFailedCallback_WithResponseHasWrongType_WhenSessionResponseIsNotNil() {
        setUpFakes(data: nil, response: nil, error: nil)
        shouldGet(expectedError: .responseIsWrongType)
    }

    func testGetNetworkResponse_ShouldPostFailedCallback_WithWrongStatusCode_WhenSessionResponseStatusCodeIsNot200() {
        setUpFakes(data: nil, response: FakeResponseData.responseKO, error: nil)
        shouldGet(expectedError: .wrongStatusCode)
    }

    func testGetNetworkResponse_ShouldPostFailedCallback_WithNoData_WhenSessionDataIsNil() {
        setUpFakes(data: nil, response: FakeResponseData.responseOK, error: nil)
        shouldGet(expectedError: .noData)
    }

    func testGetNetworkResponse_ShouldPostSuccessCallback_WithData_WhenSessionDataIsNotNilAndResponseOK() {
        setUpFakes(data: FakeResponseData.dummyData, response: FakeResponseData.responseOK, error: nil)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        networkServiceFake.getNetworkResponse(with: URL(string: "https://www.leboncoin.fr")!) { result in
            switch result {
            case .success(let data): XCTAssertEqual(data, FakeResponseData.dummyData)
            case .failure(let error): XCTFail("Has error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    // MARK: - PRIVATE

    // MARK: Methods

    private func setUpFakes(data: Data?, response: HTTPURLResponse?, error: Error?) {
        // Given
        let urlSessionFake: URLSessionFake = URLSessionFake(data: data, response: response, error: error)
        networkServiceFake = NetworkService(networkSession: urlSessionFake)

    }
    private func shouldGet(expectedError: NetworkError) {
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        networkServiceFake.getNetworkResponse(with: URL(string: "https://www.leboncoin.fr")!) { result in
            switch result {
            case .success(let data): XCTFail("No error, get: \(data)")
            case .failure(let error): XCTAssertEqual(error, expectedError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
