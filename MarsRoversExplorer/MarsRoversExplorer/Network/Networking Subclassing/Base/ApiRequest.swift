//
//  APIRequest.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 09/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

protocol ApiRequest {
	associatedtype Response: Decodable
  
  var path: String { get }
  var parameters: RequestParameters? {get}
  var method: HTTPMethod { get }
}
