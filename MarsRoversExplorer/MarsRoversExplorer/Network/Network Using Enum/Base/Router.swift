//
//  Router.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 09/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

//enum HTTPMethod: String {
//  case get = "GET"
//  case post = "POST"
//  //...
//}

protocol Router {
  var scheme: String {get}
  var host: String {get}
  var path: String {get}
  var parameters: [URLQueryItem]? {get}
  var method: HTTPMethod {get}
}
