//
//  HTTP.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import Foundation
import Combine

enum HTTP {
  protocol Endpoint {
    var domain: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var method: Method { get }
  }
  
  protocol Requestable {
    func request<T: Decodable>(request: Request) -> AnyPublisher<T, NetworkError>
  }
  
  enum Method: String {
    case get = "GET"
  }
  
  struct Request {
    let endpoint: Endpoint
    let body: Data?
    
    var urlRequest: URLRequest? {
      guard let url = endpoint.url else {
        return nil
      }
      var request = URLRequest(url: url)
      request.httpMethod = endpoint.method.rawValue
      for (key, value) in endpoint.headers {
        request.addValue(key, forHTTPHeaderField: value)
      }
      return request
    }
    
    var debugString: String {
      return "[\(endpoint.method.rawValue)] \(endpoint.url?.absoluteString ?? "bad url")"
    }
  }
  
  enum NetworkError: Error {
    case badRequest
    case invalidJSON(message: String)
    case api(code: Int, message: String)
    case unknownResponse
    
    var localizedDescription: String {
      switch self {
      case .badRequest:
        "Bad request"
      case .invalidJSON(let message):
        "Invalid JSON. The JSON data is malformed: \(message)"
      case .api(let code, let message):
        "API error [\(code): \(message)]"
      case .unknownResponse:
        "Unhandleable response"
      }
    }
  }
}

extension HTTP.Endpoint {
  var url: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = domain
    components.path = path
    components.queryItems = parameters
    return components.url
  }
}
