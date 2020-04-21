//
//  AppCoordinator.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 09/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

class AppCoordinator: Coordinator {
  
  //Coortinator Protocol conformance
  let rootViewController: UIViewController = RootViewController()
  var childCoordinators = [Coordinator]()
  
  private let defaultRepository = DefaultMarsRoversRepository()
  
  //maybe have an DIContainer, or something to instantiate app dependencies
  func start() {
		showRovers()
	//showTest()
  }
  
  fileprivate func showRovers() {
    let roversCoordinator = RoversCoordinator(repository: defaultRepository)
    self.childCoordinators.append(roversCoordinator)
    self.rootViewController.add(childController: roversCoordinator.rootViewController)
    roversCoordinator.start()
  }
	
	fileprivate func showTest() {
		
//		let datePicker = DatePickerViewController(initialDate: date(forYear: 2015, month: 11), endDate: date(forYear: 2020, month: 5), currentDate: Date())
//		datePicker.onDateSelected = { date in
//			let dateFormatter = DateFormatter()
//			dateFormatter.dateStyle = .full
//			print(dateFormatter.string(from: date))
//		}
//		self.rootViewController.add(childController: datePicker)
	}
	
	func date(forYear year: Int, month: Int) -> Date {
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		return Calendar.current.date(from: dateComponents)!
	}
  
}
