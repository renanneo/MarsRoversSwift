//
//  RoversDetailViewModel.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation
import Combine

fileprivate struct PhotoInterval {
	let startPhoto: Manifest.PhotoInfo
	let endPhoto: Manifest.PhotoInfo
	
	var dateInterval: DateInterval? {
		guard let start = startPhoto.earthDate, let end = endPhoto.earthDate else {
			return nil
		}
		return DateInterval(start: start, end: end)
	}
}

enum State {
	case error(Error)
	case loading
	case success([RoversDetailSectionViewModel])
}

struct RoversDetailHeaderViewModel {
	let title: String
	var tapped: (() -> Void)?
}

struct RoversDetailSectionViewModel {
	let title: String
	let items: [RoverDetailItemViewModel]
}

struct RoverDetailItemViewModel {
	let photoURL: String
}

protocol RoversDetailViewModelOutput {
	@Published var title: String { get }
	var state: Observable<State> { get }
	var headerViewModel: Observable<RoversDetailHeaderViewModel> { get }
	var calendarModel: Observable<CalendarViewModel?> { get }
}

protocol RoversDetailViewModelInput {
	func headerTapped()
	func viewLoaded()
}

protocol RoversDetailViewModelType: ObservableObject {
	var output: RoversDetailViewModelOutput { get }
	var input: RoversDetailViewModelInput { get }
}

final class RoversDetailViewModel: RoversDetailViewModelType, RoversDetailViewModelInput, RoversDetailViewModelOutput {
	var output: RoversDetailViewModelOutput { return self }
	var input: RoversDetailViewModelInput { return self }

	private var photosByDate = [Date: Manifest.PhotoInfo]()
	private let repository: MarsRoversRepository
	private let manifest: Manifest
	private var currentPhoto: Manifest.PhotoInfo
	private let photoInterval: PhotoInterval
	
	#warning("Remove force unwraps")
	init(manifest: Manifest, repository: MarsRoversRepository) {
		self.manifest = manifest
		self.repository = repository
		title = manifest.name.rawValue
		for photo in manifest.photos {
			photosByDate[photo.earthDate!] = photo
		}
		currentPhoto = photosByDate[manifest.maxDate]!
		
		let minDate = photosByDate.keys.min()!
		let startPhoto = photosByDate[minDate]!
		
		photoInterval = .init(startPhoto: startPhoto, endPhoto: currentPhoto)
	}
	
	private func setupDatePicker() {
		guard let interval = photoInterval.dateInterval else {
			return
		}
		let availableDates = Set(photosByDate.keys)
		let calendarVM = CalendarViewModel(dateInterval: interval, currentDate: currentPhoto.earthDate, availableDates: availableDates) { [weak self] date in
			self?.datePicked(date)
		}
		calendarModel.value = calendarVM
	}
	
	private func datePicked(_ date: Date) {
		guard let photo = photosByDate[date] else {
			return
		}
		calendarModel.value = nil
		currentPhoto = photo
		loadPhotos()
	}
	
	private func handleResponse(_ photos: [Photo]) {
		let items = Dictionary(grouping: photos, by: {$0.camera.fullName})
		let sections = items.map {RoversDetailSectionViewModel(title: $0.key, items: $0.value.map {RoverDetailItemViewModel(photoURL: $0.imgSrc)})}.sorted(by: { $0.title < $1.title })
		state.value = .success(sections)
		updateHeader()
	}
	
	private func updateHeader() {
		headerViewModel.value = RoversDetailHeaderViewModel(title: currentPhoto.description, tapped: headerTapped)
	}
	
	private func loadPhotos() {
		state.value = .loading
		repository.loadPhotos(forRover: manifest.name, camera: nil, sol: currentPhoto.sol, date: currentPhoto.earthDate) { result in
			switch result {
			case .failure(let error):
				//TODO: handle error
				self.state.value = .error(error)
			case .success(let response):
				self.handleResponse(response.photos)
			}
		}
	}
	
	//output
	let title: String
	let state = Observable(State.loading)
	let headerViewModel = Observable(RoversDetailHeaderViewModel(title: "loading...", tapped: nil))
	var calendarModel: Observable<CalendarViewModel?> = Observable(nil)
	
	//inputs
	func headerTapped() {
		setupDatePicker()
	}
	
	func viewLoaded() {
		loadPhotos()
	}
}

//Convenience
extension Manifest.PhotoInfo: CustomStringConvertible {
	var description: String {
		if let date = earthDate {
			let dateFormatter = DateFormatter()
				dateFormatter.dateStyle = .short
				return "Earth Date: \(dateFormatter.string(from: date)), Sol: \(sol)"
		} else {
			return "Sol: \(sol)"
		}
	}
}
