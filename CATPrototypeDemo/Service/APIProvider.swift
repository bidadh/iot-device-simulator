/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 13:58
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Foundation
import Alamofire
import Combine

protocol APIProvider {
  func get<T: Decodable>(
      uri: String,
      authenticated: Bool,
      validate: Bool,
      debug: Bool
  ) -> AnyPublisher<T, ServiceError>

  func post<T:Encodable>(
      uri: String,
      parameters: T?,
      authenticated: Bool,
      validate: Bool,
      debug: Bool
  ) -> AnyPublisher<String, ServiceError>
}

class APIService: APIProvider {
  private let username = "cat"
  private let password = "password"

  func post<T:Encodable>(
      uri: String,
      parameters: T? = nil,
      authenticated: Bool = true,
      validate: Bool = true,
      debug: Bool = false
  ) -> AnyPublisher<String, ServiceError> {

    let url = "\(env.providerBaseUrl)\(uri)"
    let accept = "text/plain"
    let headers = HTTPHeaders([
      "Accept": accept,
      "Content-Type": "application/json"
    ])
    var request = AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
    if(authenticated) {
      request = request
          .authenticate(username: username, password: password)
    }

    if(validate) {
      request = request
          .validate(statusCode: 200..<300)
          .validate(contentType: [accept])
    }

    if(debug) {
      request = request
          .cURLDescription { description in
        print(description)
      }
    }

    if(debug) {
      //TODO: find a better way using .publishDecodable
      return Future<String, ServiceError> { promise in
        request
            .responseString { response in
          if (debug) {
            debugPrint(response)
            debugPrint(response.metrics as Any)
          }
          promise(response.result.mapError { error in
            .network(description: error.localizedDescription)
          })
        }
      }
          .eraseToAnyPublisher()
    }

    return request
        .publishString()
        .value()
        .mapError { ServiceError.network(description: $0.localizedDescription) }
        .eraseToAnyPublisher()

  }

  func get<T: Decodable>(
      uri: String,
      authenticated: Bool = true,
      validate: Bool = true,
      debug: Bool = false
  ) -> AnyPublisher<T, ServiceError> {
    let url = "\(env.resourceBaseUrl)\(uri)"
    let req = URLRequest(url: URL(string: url)!)

    var request = AF.request(req)

    if(authenticated) {
      request = request
          .authenticate(username: username, password: password)
    }

    if(validate) {
      request = request
          .validate(statusCode: 200..<300)
          .validate(contentType: ["application/json"])
    }

    if(debug) {
      request = request
          .cURLDescription { description in
        print(description)
      }
    }

    if(debug) {
      //TODO: find a better way using .publishDecodable
      return Future<T, ServiceError> { promise in
        request
            .responseDecodable(of: T.self) { response in
          if (debug) {
            debugPrint(response)
            debugPrint(response.metrics as Any)
          }
          promise(response.result.mapError { error in
            .network(description: error.localizedDescription)
          })
        }
      }
          .eraseToAnyPublisher()
    }

    return request
        .publishDecodable(type: T.self)
        .value()
        .mapError { ServiceError.network(description: $0.localizedDescription) }
        .eraseToAnyPublisher()
  }
}
