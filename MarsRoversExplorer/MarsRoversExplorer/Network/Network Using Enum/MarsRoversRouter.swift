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
  
  case getPhotos(RoverName, CameraName?, Sol?, Date?)
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
    case .getPhotos(let rover, _, _, _):
      return "/mars-photos/api/v1/rovers/\(rover)/photos"
    case .getManifest(let rover):
      return "/mars-photos/api/v1/manifests/\(rover)"
    }
  }
  
  // 5.
  //improve to insert apikey on service layer
  var parameters: [URLQueryItem]? {
    let accessToken = "wdHxpd69QCGjbmlWPvqUcaPc8tRo1Wi89xMENuCT"
		var queryItems = [URLQueryItem(name: "api_key", value: accessToken)]
    switch self {
    //extract this to Service, and pass just a dictionary..
    case .getPhotos(_ , let camera, let sol, let date):

			if let date = date {
				let dateFormatter = DateFormatter.yyyyMMdd
				let dateStr = dateFormatter.string(from: date)
				queryItems.append(URLQueryItem(name: "earth_date", value: dateStr))
			} else if let sol = sol {
				queryItems.append(URLQueryItem(name: "sol", value: String(sol)))
			}
		
			//URLQueryItem(name: "page", value: "1"),
			
			if let camera = camera {
				queryItems.append(URLQueryItem(name: "camera", value: camera.rawValue))
			}
		
		case .getManifest: break
      
    }
		
		return queryItems
  }
  
  var method: HTTPMethod {
    switch self {
    case .getPhotos, .getManifest:
      return .get
    }
  }
	
	var cachePolicy: URLRequest.CachePolicy {
		return .returnCacheDataElseLoad
	}
  
}

