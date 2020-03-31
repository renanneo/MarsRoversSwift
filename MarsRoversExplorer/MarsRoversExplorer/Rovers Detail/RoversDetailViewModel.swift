//
//  RoversDetailViewModel.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct RoversDetailSectionViewModel {
	let title: String
	let items: [RoverDetailItemViewModel]
}

struct RoverDetailItemViewModel {
	let photoURL: String
}

struct RoversDetailViewModel {
	let manifest: Manifest
	let title: String
	let sections: Observable<[RoversDetailSectionViewModel]> = Observable([])
	let repository: MarsRoversRepository
	
	init(manifest: Manifest, repository: MarsRoversRepository) {
		self.manifest = manifest
		self.repository = repository
		title = manifest.name.rawValue
	}
	
	func viewLoaded() {
		#warning("CHANGE TO RECEIVE AS PARAMETER")
		let roverPhoto = manifest.photos[2]
		repository.loadPhotos(forRover: manifest.name, camera: nil, sol: roverPhoto.sol) { result in
			switch result {
			case .failure(let error):
				//TODO: handle error
				print(error.localizedDescription)
			case .success(let response):
				let items = Dictionary(grouping: response.photos, by: {$0.camera.fullName})
				let sections = items.map {RoversDetailSectionViewModel(title: $0.key, items: $0.value.map {RoverDetailItemViewModel(photoURL: $0.imgSrc)})}
				self.sections.value = sections;
			}
		}
	}
}
