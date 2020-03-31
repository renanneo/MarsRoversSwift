//
//  MarsRoversRouterClient.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 30/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

class MarsRoversRouterClient: RouterHTTPClient, MarsRoversClient {
	
	func loadManifest(forRover rover: RoverName, completion: @escaping (Result<ManifestResponse, Error>) -> ()) {
		request(router: MarsAPIRouter.getManifest(rover), completion: completion)
	}
	
	func loadPhotos(forRover rover: RoverName, camera: CameraName?, sol: Int, completion: @escaping (Result<Photos, Error>) -> ()) {
		request(router: MarsAPIRouter.getPhotos(rover, camera, sol), completion: completion)
	}
}
