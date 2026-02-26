//
//  File.swift
//  ViperBaseProject
//
//  Created by HimanshuChimanji  on 14/02/25.
//

import Foundation

extension Encodable {

    /// Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) -> String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            return "Failed to encode JSON: \(error)"
        }
        return ""
    }
}


open class NetworkService<T: Decodable>: NetworkServiceProtocol {
    public var request: RequestProtocol!
    
    private let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func execute(completion: @escaping @Sendable (Result<T?, NetworkError>) -> ()) {
        // Construct full URL
        
        guard baseURL != "" else {
            completion(.failure(.invalidURL))
            return
        }
        var urlString = baseURL + request.path
        logToFile("BASE:: URL: \(urlString)\tMethod: \(request.method)")
        if let headers = request.headers {
            logToFile("BASE:: headers: \(headers)")
        }
        if let jsonBody = request.jsonBody?.toJSON() {
            logToFile("BASE:: jsonBody: \(jsonBody)")
        }
        if let bodyData = request.bodyParameters {
            logToFile("BASE:: bodyData: \(bodyData)")
        }
        if let queryParameters = request.queryParameters {
            logToFile("BASE:: queryParameters: \(queryParameters)")
        }
        // Append query parameters for GET requests
        if request.method == .GET, let queryParams = request.queryParameters {
            let queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryItems
            urlString = urlComponents?.url?.absoluteString ?? urlString
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        // Handle JSON body
        if let jsonBody = request.jsonBody {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(jsonBody)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                
                completion(.failure(.decodingError(error)))
            }
        }
        
        // Handle form parameters for POST requests
        else if let bodyParams = request.bodyParameters {
            let bodyString = bodyParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            urlRequest.httpBody = bodyString.data(using: .utf8)
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.unknown(error!)))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse
            else{
                completion(.failure(.noStatusCodeFound))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                   let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    logToFile("\n********Response*********\n DataOperation")
                    logToFile(jsonString)
                } else {
                    logToFile("Failed to parse JSON")
                }

                let objectModel = try JSONDecoder().decode(T.self, from: data)
                completion(.success(objectModel))
            }catch(let error) {
                logToFile("****TypeCasting Error*****\n\n\(error)")
                completion(.failure(.unknown( error)))
            }
        }
        
        task.resume()
    }
    
    func debugPrint() {
        let requestMethod = request.method
        let url = request.path
        let requestBody = request.jsonBody?.toJSON()
        
        logToFile("URL: \(url) \nMethod: \(requestMethod)\nbody:\(requestBody ?? "")\nHeaders:\(String(describing: request.headers))")
    }

}
