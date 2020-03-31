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
  }
  
  fileprivate func showRovers() {
    let roversCoordinator = RoversCoordinator(repository: defaultRepository)
    self.childCoordinators.append(roversCoordinator)
    self.rootViewController.add(childController: roversCoordinator.rootViewController)
    roversCoordinator.start()
  }
  
}
