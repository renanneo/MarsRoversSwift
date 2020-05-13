//
//  CalendarViewModel.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 18/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct CalendarViewModel {
	let dateInterval: DateInterval
	let currentDate: Date?
	let availableDates: Set<Date>
	
	var onDatePicked: ((Date) -> ())?
}


