//
//  HTTPClient.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 09/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

class HTTPClient {
	private let session: URLSession
	private let baseURL: URL
	
	init(baseURL: String, session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
		self.session = session
		self.baseURL = URL(string: baseURL)!
	}
	
	open func requestUrl<T: ApiRequest>(for request: T) -> URL {
		return URL(string: request.path, relativeTo: baseURL)!
	}
	
	@discardableResult
	open func request<T: ApiRequest>(request: T, completion: @escaping (Result<T.Response, Error>) -> ()) -> URLSessionTask {
		
		let url = requestUrl(for: request)
		var urlRequest = URLRequest(url: url)
		if let parameters = request.parameters {
			urlRequest = parameters.apply(urlRequest: urlRequest)
		}
		
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
			
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			decoder.dateDecodingStrategy = .iso8601
			let responseObject = try! decoder.decode(T.Response.self, from: data)
			
			DispatchQueue.main.async {
				completion(.success(responseObject))
			}
		}
		dataTask.resume()
		return dataTask
	}
	
	
	
	
	
}
