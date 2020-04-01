//
//  Alert.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct ActionViewModel {
	enum ActionStyle: Equatable {
		case `default`
		case cancel
		case destructive
	}
	
	var title: String?
	var style: ActionStyle
	var handler: ((ActionViewModel) -> ())?
}

struct AlertViewModel {
	enum AlertStyle: Equatable {
		case actionSheet
		case alert
	}
	
	var actions = [ActionViewModel]()
	var title: String?
	var message: String?
	var prefferedStyle: AlertStyle
}
