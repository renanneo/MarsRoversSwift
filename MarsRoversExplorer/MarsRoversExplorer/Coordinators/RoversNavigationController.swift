//
//  RoversNavigationController.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 20/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class RoversNavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
	}
	
	func setupNavigationBar() {
    let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
		navigationBar.titleTextAttributes = textAttributes
		navigationBar.largeTitleTextAttributes = textAttributes
		//navigationBar.prefersLargeTitles = true
		navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationBar.shadowImage = UIImage()
		navigationBar.tintColor = .white
		navigationBar.isTranslucent = true
  }
}
