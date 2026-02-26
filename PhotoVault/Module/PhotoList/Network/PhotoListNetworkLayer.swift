//
//  PhotoListNetworkLayer.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import Foundation
import Combine

class PhotoListNetworkLayer {
    static let shared = PhotoListNetworkLayer()

    func callExampleAPI() -> AnyPublisher<[PhotoListOutputResponse], Error> {
        let request = PhotoListInputRequest()
        return Future { promise in
            request.execute { result in
                switch result {
                case .success(let response): promise(.success(response!))
                case .failure(let error): promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
