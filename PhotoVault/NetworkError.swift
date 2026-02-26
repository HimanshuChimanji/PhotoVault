//
//  File.swift
//  ViperBaseProject
//
//  Created by HimanshuChimanji  on 14/02/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case unknown(Error)
    case noStatusCodeFound
    
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "No data received."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        case .noStatusCodeFound:
            return "No status code found."
        }
    }
}

