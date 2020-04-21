//
//  UIViewController+Extensions.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 20/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

extension UIViewController {
	func add(childController: UIViewController) {
		addChild(childController)
		view.addSubview(childController.view)
		childController.didMove(toParent: self)
	}
	
	func remove(childController: UIViewController) {
		childController.willMove(toParent: nil)
		childController.view.removeFromSuperview()
		childController.removeFromParent()
	}
}
