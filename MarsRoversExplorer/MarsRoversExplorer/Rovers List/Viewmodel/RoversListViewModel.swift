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

protocol RoverListViewModelType: AlertPresentableViewModel, CalendarPresentableViewModel {
	var title: String { get }
	var items: Observable<[RoverItemViewModel]> { get }
}

class RoversListViewModel: RoverListViewModelType {

	private var manifest: Manifest?
	private var photosBySol = [Date: [Manifest.ManifestPhoto]]()
	private let rovers: [RoverName] = [.curiosity, .opportunity, .spirit]
	private let repository: MarsRoversRepository
	
	//outputs
	var alertModel: Observable<AlertViewModel?> = Observable(nil)
	var calendarModel: Observable<CalendarViewModel?> = Observable(nil)
	let title = "Mars Rovers"
	var items: Observable<[RoverItemViewModel]> = Observable([])
	
	//input
	var onRoverSelected: ((Manifest) -> Void)?
	
	//var observer: NSKeyValueObservation? = nil
	
	private func roverSelected(rover: RoverName) {
		repository.loadManifest(forRover: rover) { result in
			switch result {
			case .failure(let error):
				print(error.localizedDescription)
			case .success(let response):
				self.setupWithManifest(manifest: response.photoManifest)
			}
		}

//		if observer != nil {
//			observer!.invalidate()
//			observer = nil
//		}
//
//		observer = task.progress.observe(\.fractionCompleted, options: .new, changeHandler: { [weak self] object, change in
//			guard let progress = change.newValue else {
//				return
//			}
//			print(progress)
//			DispatchQueue.main.async {
//				if progress != 1.0 {
//					self?.itemsLoadProgress.value = progress
//				} else {
//					self?.itemsLoadProgress.value = nil
//				}
//			}
//		})
	}
	
	func setupWithManifest(manifest: Manifest) {
		self.manifest = manifest
		let date = Date()
		self.photosBySol = Dictionary(grouping: manifest.photos, by: { $0.earthDate ?? date })
		let dates = Set(self.photosBySol.keys)
		if let startDate = dates.min(), let endDate = dates.max() {
//			let calendarModel = CalendarViewModel(startDate: startDate, endDate: endDate, availableDates: dates, onDatePicked: { [weak self] date in
//				self?.dateSelected(date: date)
//			})
//			self.calendarModel.value = calendarModel;
			//dateSelected(date: endDate)
			onRoverSelected?(manifest)
		}

		//solSelected(sol: 0)
	}
	
	private func cameraSelected(camera: CameraName) {
		print(camera)
	}
	
	private func dateSelected(date: Date) {
		let cancelAction = ActionViewModel(title: "Cancel", style: .cancel, handler: nil)
		var actions = [cancelAction]

		if let photo = self.photosBySol[date]?.first {
			photo.cameras.forEach { camera in
				actions.append(ActionViewModel(title: camera.rawValue, style: .default, handler: { [weak self] action in
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
