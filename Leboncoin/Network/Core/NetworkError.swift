//
//  NetworkError.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation

enum NetworkError: Error {
    case noData
    case hasError
    case responseIsWrongType
    case wrongStatusCode
    case canNotDecode
    case invalidURL

    var message: String {
        switch self {
        case .noData:
            return "Empty data."
        case .hasError:
            return "Contains an error."
        case .responseIsWrongType:
            return "Response format is other than HTTP."
        case .wrongStatusCode:
            return "Response's status code is not 200."
        case .canNotDecode:
            return "Error when decoding .json."
        case .invalidURL:
            return "Invalid data URL."
        }
    }
}
