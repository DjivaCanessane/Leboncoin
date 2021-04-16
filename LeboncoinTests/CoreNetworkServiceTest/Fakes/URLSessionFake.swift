//
//  URLSessionFake.swift
//  LeboncoinTests
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation

class URLSessionFake: URLSession {

    // MARK: - INTERNAL

    // MARK: Properties

    var data: Data?
    var response: URLResponse?
    var error: Error?

    // MARK: Methods

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    override func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {

    // MARK: - INTERNAL

    // MARK: Properties

    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?

    // MARK: Methods

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }

    override func cancel() {}

    override init() {}
}
