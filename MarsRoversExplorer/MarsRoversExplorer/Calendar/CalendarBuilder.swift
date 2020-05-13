//
//  CalendarBuilder.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 18/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

class CalendarBuilder {
	static func buildCalendar(for model: CalendarViewModel) -> DatePickerViewController {
		let picker = DatePickerViewController(dateInterval: model.dateInterval, availableDates: model.availableDates, currentDate: model.currentDate)
		picker.onDateSelected = model.onDatePicked
		
		return picker
	}
}
