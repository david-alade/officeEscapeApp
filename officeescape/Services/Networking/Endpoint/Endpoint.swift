//
//  Endpoint.swift
//
//
//  Created by David Alade on 6/12/24.
//

import Foundation

public struct Endpoint<Response: DecodableResponse> {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case head = "HEAD"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    enum ContentType: String {
        case JSON = "application/json"
    }
    
    typealias Header = [String: String]
    
    var baseUrl: String
    var path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem] = []
    var headers: Header = [:]
    var body: Data?
    var decoder: ResponseDecoder

    init(
        baseUrl: String = EndpointUrl.backendApiUrl.rawValue,
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        headers: Header = [:],
        body: Data? = nil,
        decoder: ResponseDecoder = Response.defaultDecoder
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.decoder = decoder
        self.baseUrl = baseUrl
    }
    
    init<Body: Encodable>(
        baseUrl: String = EndpointUrl.backendApiUrl.rawValue,
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        headers: Header = [:],
        body: Body,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: ResponseDecoder = Response.defaultDecoder
    ) throws {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = try encoder.encode(body)
        self.headers["Content-Type"] = ContentType.JSON.rawValue
        self.decoder = decoder
        self.baseUrl = baseUrl
    }

    func url() -> URL? {
        var components = URLComponents(string: self.baseUrl + path)
        components?.queryItems = self.queryItems
        return components?.url
    }
    
    func request() -> URLRequest? {
        if let url = self.url() {
            var request = URLRequest(url: url)
            request.httpMethod = self.method.rawValue
            request.httpBody = self.body
            self.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            return request
        }
        
        return nil
    }
    
    mutating func addAuthToken(token: String) {
        self.headers["x-my-app-test-auth"] = token
    }
    
    mutating func addContentType(type: String) {
        self.headers["Content-Type"] = type
    }
}
