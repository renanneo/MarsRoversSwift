//
//  MarsRoversPhotosAPI.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 08/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

#warning("DONT IMPORT UIKIT JUST BECAUSE YOU NEED UIApplication.willTerminateNotification FIGURE OUT A BETTER WAY")
import UIKit

//The Repository can merge server and local data, decide from where to fetch, if should return cached, etc...

//ask someone how to return
//https://www.bignerdranch.com/blog/why-associated-type-requirements-become-generic-constraints/
protocol MarsRoversRepository {
  //associatedtype Task, was trying to return task, because a remote service would return URLSessionTask and a local service would return any other type of task, but it didn't work because of generic constraints
  func loadManifest(forRover rover: RoverName, completion: @escaping (Result<ManifestResponse, Error>) -> ())
	func loadPhotos(forRover rover: RoverName, camera: CameraName?, sol: Int, completion: @escaping (Result<Photos, Error>) -> ())
}

class DefaultMarsRoversRepository {
  let client: MarsRoversClient
	//dumb cache
	var manifest = [RoverName: ManifestResponse]()
	var photos = [String: Photos]()
  
  init(client: MarsRoversClient = MarsRoversRouterClient()) {
    self.client = client
		NotificationCenter.default.addObserver(
    self,
    selector: #selector(self.applicationWillTerminate),
		name: UIApplication.willTerminateNotification,
    object: nil)
  }
	
	@objc func applicationWillTerminate() {

	}
}

extension DefaultMarsRoversRepository: MarsRoversRepository {
  
  func loadManifest(forRover rover: RoverName, completion: @escaping (Result<ManifestResponse, Error>) -> ()) {
		if let manifest = manifest[rover] {
			completion(.success(manifest))
		} else {
			client.loadManifest(forRover: rover) { result in
				switch result {
				case .failure(_):
					completion(result)
				case .success(let response):
					self.manifest[rover] = response
					completion(result)
				}
			}
		}
	}
	
	func loadPhotos(forRover rover: RoverName, camera: CameraName?, sol: Int, completion: @escaping (Result<Photos, Error>) -> ()) {
		let key = "\(rover)\(camera?.rawValue ?? "")\(sol)"
		if let photos = photos[key] {
			completion(.success(photos))
		} else {
			client.loadPhotos(forRover: rover, camera: camera, sol: sol) { result in
				switch result {
				case .failure(_):
					completion(result)
				case .success(let response):
					self.photos[key] = response
					completion(result)
				}
			}
		}
	}
}
