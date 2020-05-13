//
//  Manifest.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 21/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct ManifestResponse: Codable {
  let photoManifest: Manifest
}

struct Manifest: Codable {
  struct PhotoInfo: Codable {
    let sol: Int
    var earthDate: Date?
    let totalPhotos: Int
    let cameras: [CameraName]
  }
  
  let name: RoverName
  let landingDate: Date
  let launchDate: Date
  let status: String
  let maxSol: Int
  let maxDate: Date
  let totalPhotos: Int
  let photos: [PhotoInfo]
}
