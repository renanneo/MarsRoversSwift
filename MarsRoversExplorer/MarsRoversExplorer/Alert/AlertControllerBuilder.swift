//
//  AlertBuilder.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class AlertBuilder {
    static func buildAlertController(for model: AlertViewModel) -> UIAlertController {
			let controller = UIAlertController(title: model.title, message: model.message, preferredStyle: model.prefferedStyle == .actionSheet ? .actionSheet : .alert)
        
			model.actions.forEach {
				controller.addAction($0.uiAlertAction())
			}
        
			return controller
    }
}

extension ActionViewModel {
	func uiAlertAction() -> UIAlertAction {
		var uiAlertActionStyle: UIAlertAction.Style = .default
		
		if style == .cancel {
			uiAlertActionStyle = .cancel
		} else if style == .destructive {
			uiAlertActionStyle = .destructive
		}
		
		return UIAlertAction(title: title, style: uiAlertActionStyle) { action in
			if let handler = self.handler {
				handler(self)
			}
		}
	}
}
