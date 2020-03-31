//
//  RoversCoordinator.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 09/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

//Should each ViewController have its own Coordinator? because each can have its own flow

class RoversCoordinator: Coordinator {
  let repository: MarsRoversRepository
  private let navigationController = UINavigationController()
  
  init(repository: MarsRoversRepository) {
    self.repository = repository
  }
  
  var childCoordinators = [Coordinator]()
  
  var rootViewController: UIViewController {
    return navigationController
  }
  
  func start() {
    let roversListViewmodel = RoversListViewModel(repository: repository)
		roversListViewmodel.onRoverSelected = { manifest in
			self.showRoverDetailVC(manifest: manifest)
		}
    let startingVC = RoversListViewController(viewmodel: roversListViewmodel)
    navigationController.pushViewController(startingVC, animated: false)
  }
	
	func showRoverDetailVC(manifest: Manifest) {
		let roversDetailViewModel = RoversDetailViewModel(manifest: manifest, repository: repository)
		let roversDetailViewController = RoversDetailViewController(viewModel: roversDetailViewModel)
		navigationController.pushViewController(roversDetailViewController, animated: true)
	}
}
