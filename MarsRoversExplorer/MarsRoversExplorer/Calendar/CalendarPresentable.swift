//
//  File.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 18/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarPresentableViewModel {
	var calendarModel: Observable<CalendarViewModel?> { get set }
}

protocol CalendarPresentableView {
	associatedtype VMType: CalendarPresentableViewModel
	var viewmodel: VMType { get }
}

extension CalendarPresentableView where Self: UIViewController {
	func bindToCalendar() {
		viewmodel.calendarModel.observe(on: self) { [weak self] model in
			guard let model = model else {
				self?.dismiss(animated: true, completion: nil)
				return
			}
			
			let calendar = CalendarBuilder.buildCalendar(for: model)
			self?.present(calendar, animated: true, completion: nil)
		}
	}
}
