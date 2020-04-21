//
//  CalendarViewModel.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 18/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct CalendarViewModel {
	let startDate: Date
	let endDate: Date
	let availableDates: Set<Date>
	
	var onDatePicked: ((Date) -> ())?
}


