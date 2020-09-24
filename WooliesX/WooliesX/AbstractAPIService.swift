//
//  AbstractAPIService.swift
//  WooliesX
//
//  Created by Siavash on 24/9/20.
//  Copyright © 2020 Siavash. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

enum ModelResult<T> {
    case result(T)
    case error(Error)
}

enum OtherError: Error {
    case jsonEncodingError(Error)
    case dataProcessError(String)
    case httpError(Int, Any)
    case emtptyFieldError
}

class AbstractAPIService {
    
    private let decoder = JSONDecoder()
    
    private let dispatchQueue = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .userInitiated))
    
    /// Generic method for decoding API data
    ///
    /// - parameter data: The data
    func decode<T: Codable>(data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw OtherError.jsonEncodingError(error)
        }
    }
    
    /// Generic method for encoding models
    ///
    /// - parameter data: The data
    func decodeArray<T: Codable>(data: Data) throws -> [T] {
        do {
            return try decoder.decode([T].self, from: data)
        } catch {
            throw OtherError.jsonEncodingError(error)
        }
    }
    
    /// Generic method to do the HTTP GET request and convert the response data into corresponding models
    ///
    /// - parameter url:        The request URL
    /// - parameter parameters: The parameters. `nil` by default
    /// - parameter headers:    The extra header information. `nil` by default
    /// - parameter encoding:   The parameters encoding. `nil` by default
    func get<T: Codable>(url: URLConvertible, parameters: [String: Any]? = nil, headers: [String: String]? = nil, encoding: ParameterEncoding = URLEncoding.default) -> Observable<T> {
        
        let observable = APIClient.shared.get(url: url, parameters: parameters, headers: headers, encoding: encoding)
            .subscribeOn(dispatchQueue)
            .map({ [unowned self] data -> T in return try self.decode(data: data) })
            .catchError { error -> Observable<T> in
                throw error
        }
        
        return observable
    }
}
