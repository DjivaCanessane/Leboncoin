//
//  FakeResponseData.swift
//  LeboncoinTests
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation
@testable import Leboncoin

class FakeResponseData {

    // MARK: - DATA

    static let imageData = "image".data(using: .utf8)!

    static func generateData(for ressource: String) -> Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: ressource, withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    // MARK: - RESPONSE

    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://www.leboncoin.fr")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://www.leboncoin.fr")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - ERROR

    class FakeError: Error {}
    static let error = FakeError()
}
