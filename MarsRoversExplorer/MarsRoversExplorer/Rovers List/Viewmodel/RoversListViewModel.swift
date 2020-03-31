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

protocol RoverListViewModelType {
  var title: String { get }
  var items: Observable<[RoverItemViewModel]> { get }
}

class RoversListViewModel: RoverListViewModelType {
	var onRoverSelected: ((Manifest) -> Void)?
	private let rovers: [RoverName] = [.curiosity, .opportunity, .spirit]
  var items: Observable<[RoverItemViewModel]> = Observable([])
	let repository: MarsRoversRepository
  let title = "Mars Rovers"
  
  private func roverSelected(rover: RoverName) {
		repository.loadManifest(forRover: rover) { result in
			switch result {
			case .failure(let error):
				print(error)
			case .success(let response):
				self.onRoverSelected?(response.photoManifest)
			}
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
