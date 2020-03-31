//
//  routerCase.swift
//  CodingStudies
//
//  Created by Renan Santos Soares on 12/01/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

//https://stackoverflow.com/questions/40654823/can-i-define-an-enum-as-a-subset-of-another-enums-cases
//https://stackoverflow.com/questions/40636469/can-i-restrict-an-enum-to-certain-cases-of-another-enum

//API Routes
enum MarsAPIRouter: Router {
  typealias Sol = Int
  
  case getPhotos(RoverName, CameraName?, Sol)
  case getManifest(RoverName)
  
  var scheme: String {
    switch self {
    case .getPhotos, .getManifest:
      return "https"
    }
  }
  
  // 3.
  var host: String {
    switch self {
    case .getPhotos, .getManifest:
      return "api.nasa.gov"
    }
  }
  
  // 4.
  
  var path: String {
    switch self {
    case .getPhotos(let rover, _, _):
      return "/mars-photos/api/v1/rovers/\(rover)/photos"
    case .getManifest(let rover):
      return "/mars-photos/api/v1/manifests/\(rover)"
    }
  }
  
  // 5.
  //improve to insert apikey on service layer
  var parameters: [URLQueryItem]? {
    let accessToken = "wdHxpd69QCGjbmlWPvqUcaPc8tRo1Wi89xMENuCT"
    switch self {
    //extract this to Service, and pass just a dictionary..
    case .getPhotos(_ , let camera, let sol):
			var queryItems = [URLQueryItem(name: "sol", value: String(sol)),
			URLQueryItem(name: "page", value: "1"),
			URLQueryItem(name: "api_key", value: accessToken)]
			
			if let camera = camera {
				queryItems.append(URLQueryItem(name: "camera", value: camera.rawValue))
			}
			
      return queryItems
    case .getManifest:
      return  [URLQueryItem(name: "api_key", value: accessToken)]
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .getPhotos, .getManifest:
      return .get
    }
  }
  
}

