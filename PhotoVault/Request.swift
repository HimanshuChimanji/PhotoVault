//
//  File.swift
//  ViperBaseProject
//
//  Created by HimanshuChimanji  on 14/02/25.
//

import Foundation


public protocol RequestProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }  // For GET requests
    var bodyParameters: [String: Any]? { get }      // For POST requests with form-data
    var jsonBody: Encodable? { get }               // For POST requests with JSON body
}


public struct Request: RequestProtocol {
    
    public var path: String
    public var method: HTTPMethod
    public var headers: [String: String]?
    public var queryParameters: [String: String]?
    public var bodyParameters: [String: Any]?
    public var jsonBody: Encodable?
    
    public init(path: String, method: HTTPMethod, headers: [String : String]? = nil, queryParameters: [String : String]? = nil, bodyParameters: [String : Any]? = nil, jsonBody: Encodable? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.jsonBody = jsonBody
    }
}
