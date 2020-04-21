//
//  MarsRoversPhotosAPI.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 08/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

#warning("DONT IMPORT UIKIT JUST BECAUSE YOU NEED UIApplication.willTerminateNotification FIGURE OUT A BETTER WAY")
//import UIKit

//The Repository can merge server and local data, decide from where to fetch, if should return cached, etc...

//ask someone how to return
//https://www.bignerdranch.com/blog/why-associated-type-requirements-become-generic-constraints/
protocol MarsRoversRepository {
  //associatedtype Task, was trying to return task, because a remote service would return URLSessionTask and a local service would return any other type of task, but it didn't work because of generic constraints
	@discardableResult
	func loadManifest(forRover rover: RoverName, completion: @escaping (Result<ManifestResponse, Error>) -> ()) -> URLSessionTask?
	
	@discardableResult
	func loadPhotos(forRover rover: RoverName, camera: CameraName?, sol: Int?, date: Date?, completion: @escaping (Result<PhotosResponse, Error>) -> ()) -> URLSessionTask?
}

final class DefaultMarsRoversRepository {
  let client: MarsRoversClient

  init(client: MarsRoversClient = MarsRoversRouterClient()) {
    self.client = client
  }
	
//	@objc func applicationWillTerminate() {
//
//	}
}

extension DefaultMarsRoversRepository: MarsRoversRepository {
	func loadPhotos(forRover rover: RoverName, camera: CameraName?, sol: Int?, date: Date?, completion: @escaping (Result<PhotosResponse, Error>) -> ()) -> URLSessionTask? {
		return client.loadPhotos(forRover: rover, camera: camera, sol: sol, date: date, completion: completion)
	}
  
  func loadManifest(forRover rover: RoverName, completion: @escaping (Result<ManifestResponse, Error>) -> ()) -> URLSessionTask? {
		return client.loadManifest(forRover: rover, completion: completion)
	}
	
}
