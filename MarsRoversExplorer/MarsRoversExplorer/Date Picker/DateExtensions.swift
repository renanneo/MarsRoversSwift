//
//  DateExtensions.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 06/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

extension Date {
	
	var month: Int {
		return Calendar.current.component(.month, from: self)
	}
	
	var year: Int {
		return Calendar.current.component(.year, from: self)
	}
	
	var weekday: Int {
		return Calendar.current.component(.weekday, from: self)
	}
	
	var firstDayOfTheMonth: Date {
		return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
	}
}
