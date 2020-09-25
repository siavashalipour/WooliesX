//
//  APIClient.swift
//  WooliesX
//
//  Created by Siavash on 24/9/20.
//  Copyright © 2020 Siavash. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class APIClient {
    
    static let shared = APIClient()
    
    private let session: Session
    
    init() {
        self.session = APIClient.createSession()
    }
    
    private static func createSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        return Alamofire.Session(configuration: configuration, serverTrustManager: nil)
    }
    
    func get(url: URLConvertible, parameters: [String: Any]? = nil, headers: [String: String]? = nil, encoding: ParameterEncoding = URLEncoding.default) -> Observable<Data> {
        
        return session.rx.data(.get, url, parameters: parameters, encoding: encoding, headers: HTTPHeaders(headers ?? [:]), interceptor: nil)
    }
}
