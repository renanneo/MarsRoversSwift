//
//  APIRequest.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 09/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

protocol ApiRequest {
	associatedtype Response: Decodable
  
  var path: String { get }
  var parameters: RequestParameters? {get}
  var method: HTTPMethod { get }
}
