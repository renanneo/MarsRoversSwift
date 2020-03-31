//
//  MarsRoversHTTPClient.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 30/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

class DefaultMarsRoversClient: HTTPClient, MarsRoversClient {
	
	func loadPhotos(forRover rover: RoverName, camera: CameraName?, sol: Int, completion: @escaping (Result<Photos, Error>) -> ()) {
		request(request: GetPhotos(roverName: rover, camera: camera, sol: sol, page: 1), completion: completion)
	}
	
  func loadManifest(forRover rover: RoverName, completion: @escaping (Result<ManifestResponse, Error>) -> ()) {
		request(request: GetManifest(roverName: rover), completion: completion)
  }
}
