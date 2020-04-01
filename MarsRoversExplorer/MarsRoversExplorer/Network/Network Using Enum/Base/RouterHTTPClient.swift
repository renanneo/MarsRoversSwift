//
//  Service.swift
//  CodingStudies
//
//  Created by Renan Santos Soares on 12/01/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

class RouterHTTPClient {
  private let session: URLSession
  
  init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
    self.session = session
  }
  
  @discardableResult
  func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) -> URLSessionTask {
    
    var components = URLComponents()
    components.scheme = router.scheme
    components.host = router.host
    components.path = router.path
    components.queryItems = router.parameters
    
    guard let url = components.url else {
      fatalError("invalid url")
    }
    var urlRequest = URLRequest(url: url)
		
		urlRequest.cachePolicy = router.cachePolicy
    urlRequest.httpMethod = router.method.rawValue
    
    let dataTask = session.dataTask(with: urlRequest) { data, response, error in
      
      guard error == nil else {
        completion(.failure(error!))
        print(error!.localizedDescription)
        return
      }
      guard response != nil else {
        return
      }
      guard let data = data else {
        return
      }
      
      //it shouldn't be created here, should get from router
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
			decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
      let responseObject = try! decoder.decode(T.self, from: data)
      
      DispatchQueue.main.async {
        completion(.success(responseObject))
      }
    }
    dataTask.resume()
    return dataTask
  }
}
