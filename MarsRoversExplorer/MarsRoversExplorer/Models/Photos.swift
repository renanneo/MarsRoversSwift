//
//  MarsRover.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 03/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct PhotosResponse: Codable {
  let photos: [Photo]
}

struct Photo: Codable {
  let id: Int
  let sol: Int
  let camera: Camera
  let imgSrc: String
  let earthDate: String?
  let rover: Rover
}

enum RoverName: String, Codable {
  case curiosity = "Curiosity"
  case opportunity = "Opportunity"
  case spirit = "Spirit"
}

struct Rover: Codable {
  let id: Int
  let name: RoverName
  let landingDate: String
  let launchDate: String
  let status: String
  let maxSol: Int
  let maxDate: String
  let totalPhotos: Int
  let cameras: [Dictionary<String, String>]
}

enum CameraName: String, Codable {
	case ENTRY
  case FHAZ
  case RHAZ
  case MAST
  case CHEMCAM
  case MAHLI
  case MARDI
  case NAVCAM
  case PANCAM
  case MINITES
}

struct Camera: Codable {
  let id: Int
  let name: CameraName
  let roverId: Int
  let fullName: String
}



