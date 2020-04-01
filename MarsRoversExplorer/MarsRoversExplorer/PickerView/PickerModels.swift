//
//  PickerModels.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 01/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct PickerItem {
	let title: String
}

struct PickerSection {
	let items: [PickerItem]
}

struct PickerViewModel {
	let sections: [PickerSection]
	var onRowSelected: ((Int) -> Void)
}
