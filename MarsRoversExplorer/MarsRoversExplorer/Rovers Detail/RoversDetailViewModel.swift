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
	private var photosBySol = [Date: Manifest.ManifestPhoto]()
	private let repository: MarsRoversRepository
	private let manifest: Manifest
	
	//output
	let title: String
	let sections: Observable<[RoversDetailSectionViewModel]> = Observable([])
	
	init(manifest: Manifest, repository: MarsRoversRepository) {
		self.manifest = manifest
		self.repository = repository
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		title = "\(manifest.name.rawValue) \(dateFormatter.string(from: manifest.maxDate))"
		for photo in manifest.photos {
			photosBySol[photo.earthDate!] = photo
		}
	}
	
	func viewLoaded() {
		guard let photo = photosBySol[manifest.maxDate] else {
			return
		}
		
		repository.loadPhotos(forRover: manifest.name, camera: nil, sol: nil, date: photo.earthDate) { result in
			switch result {
			case .failure(let error):
				//TODO: handle error
				print(error.localizedDescription)
			case .success(let response):
				self.handleResponse(response.photos)
			}
		}
	}
	
	private func handleResponse(_ photos: [Photo]) {
		let items = Dictionary(grouping: photos, by: {$0.camera.fullName})
		let sections = items.map {RoversDetailSectionViewModel(title: $0.key, items: $0.value.map {RoverDetailItemViewModel(photoURL: $0.imgSrc)})}.sorted(by: { $0.title < $1.title })
		self.sections.value = sections;
	}
}
