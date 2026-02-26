//
//  File.swift
//  ViperBaseProject
//
//  Created by HimanshuChimanji  on 14/02/25.
//

import Foundation

public protocol NetworkServiceProtocol {
    associatedtype T
    var request: RequestProtocol! { get set }
    func execute(completion: @escaping @Sendable (Result<T?, NetworkError>) -> ())
}

