//
//  GetPhotos.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 09/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct GetPhotos: ApiRequest {
  typealias Response = PhotosResponse
  
  let roverName: RoverName
  let camera: CameraName?
  let sol: Int
  let page: Int
  let method = HTTPMethod.get
  
  var path: String {
     return "/rovers/\(roverName)/photos"
  }
  
  var parameters: RequestParameters? {
		var query =  ["sol" : String(sol),
									"page" : String(page)]
		
		if let camera = camera {
			query["camera"] = camera.rawValue
		}
    return QueryParameters(query)
  }
}

struct GetManifest: ApiRequest {
  typealias Response = ManifestResponse
  
  var path: String {
    return "/manifests/\(roverName)"
  }
  
  let parameters: RequestParameters? = nil
  let roverName: RoverName
  let method = HTTPMethod.get
}
