//
//  MarsRoversClient.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 09/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

protocol MarsRoversClient {
	func loadManifest(forRover rover: RoverName, completion: @escaping (Result<ManifestResponse, Error>) -> ()) -> URLSessionTask
	
	func loadPhotos(forRover rover: RoverName, camera: CameraName?, sol: Int?, date: Date?, completion: @escaping (Result<PhotosResponse, Error>) -> ()) -> URLSessionTask
}
