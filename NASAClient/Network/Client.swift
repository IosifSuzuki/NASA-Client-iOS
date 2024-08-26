//
//  Client.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import Foundation
import Combine

class APIClient: HTTP.Requestable {
  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()
  
  func request<T>(request: HTTP.Request) -> AnyPublisher<T, HTTP.NetworkError> where T : Decodable {
    guard let urlRequest = request.urlRequest else {
      return Fail<T, HTTP.NetworkError>(error: .badRequest).eraseToAnyPublisher()
    }
    print("preparing request: \(request.debugString)")
    return URLSession
      .shared
      .dataTaskPublisher(for: urlRequest)
      .tryMap { (data, response) in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw HTTP.NetworkError.unknownResponse
        }
        if let limitRequest = httpResponse.allHeaderFields["x-ratelimit-remaining"] as? String {
          print("X-RateLimit-Remaining: \(limitRequest)")
        }
        guard 200..<300 ~= httpResponse.statusCode else {
          throw HTTP.NetworkError.api(code: httpResponse.statusCode, message: "Server error")
        }
        return data
      }
      .decode(type: T.self, decoder: decoder)
      .mapError { error in
        HTTP.NetworkError.invalidJSON(message: error.localizedDescription)
      }
      .eraseToAnyPublisher()
  }
}
