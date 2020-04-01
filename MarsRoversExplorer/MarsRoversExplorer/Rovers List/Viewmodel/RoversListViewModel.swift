//
//  RoversListViewmodel.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 03/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct RoverItemViewModel {
	let title: String
	let imageFileName: String
	let tapped: (() -> Void)
}

protocol RoverListViewModelType: AlertPresentableViewModel {
	var title: String { get }
	var items: Observable<[RoverItemViewModel]> { get }
}

class RoversListViewModel: RoverListViewModelType {
	private var manifest: Manifest?
	private var photosBySol = [Int: [Manifest.ManifestPhoto]]()
	private let rovers: [RoverName] = [.curiosity, .opportunity, .spirit]
	private let repository: MarsRoversRepository
	
	var alertModel: Observable<AlertViewModel?> = Observable(nil)
	var items: Observable<[RoverItemViewModel]> = Observable([])
	
	var onRoverSelected: ((Manifest) -> Void)?
	let title = "Mars Rovers"
	
	private func roverSelected(rover: RoverName) {
		repository.loadManifest(forRover: rover) { result in
			switch result {
			case .failure(let error):
				print(error)
			case .success(let response):
				self.setupWithManifest(manifest: response.photoManifest)
			}
		}
	}
	
	func setupWithManifest(manifest: Manifest) {
		self.manifest = manifest
		self.photosBySol = Dictionary(grouping: manifest.photos, by: { $0.sol })
	}
	
	private func cameraSelected(camera: CameraName) {
		
	}
	
	private func solSelected(sol: Int) {
		let cancelAction = ActionViewModel(title: "Cancel", style: .cancel, handler: nil)
		var actions = [cancelAction]
		
		if let photo = self.photosBySol[sol]?.first {
			photo.cameras.forEach { camera in
				actions.append(ActionViewModel(title: camera.rawValue, style: .default, handler: { [weak self] vm in
					self?.cameraSelected(camera: camera)
				}))
			}
			let alert = AlertViewModel(actions: actions, title: "Select a Camera", message: nil, prefferedStyle: .actionSheet)
			self.alertModel.value = alert
		}
	}
	
	init(repository: MarsRoversRepository) {
		self.repository = repository
		self.items.value = rovers.map {
			rover in RoverItemViewModel(title: rover.rawValue, imageFileName: rover.rawValue.lowercased(), tapped: { [weak self] in
				self?.roverSelected(rover: rover)
			})
		}
	}
}
