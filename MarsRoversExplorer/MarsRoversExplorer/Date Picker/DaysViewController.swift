//
//  DaysViewController.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 06/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class DaysViewController: UIViewController {
	
	struct Day {
		var title: String?
		var date: Date?
	}
	
	class DayCell: UICollectionViewCell {
		
		let textLabel: UILabel = {
			let label = UILabel()
			label.textAlignment = .center
			label.textColor = .white
			label.backgroundColor = .clear
			label.font = .systemFont(ofSize: 20, weight: .medium)
			return label
		}()
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			self.contentView.addSubview(textLabel)
			textLabel.sizeToSuperView()
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
	
	let daysCollectionView: UICollectionView = {
		let flow = UICollectionViewFlowLayout()
		flow.minimumLineSpacing = 0
		flow.minimumInteritemSpacing = 0
		let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
		cv.register(DayCell.self, forCellWithReuseIdentifier: "dayCell")
		cv.backgroundColor = .clear
		return cv
	}()
	
	private var days: [Day] = []
	private let calendar: Calendar
	private let daysInAWeek: CGFloat = 7.0
	
	var onDateSelected: ((Date) -> Void)?
	var dateAvailable: ((Date) -> Bool)
	
	var date: Date {
		didSet {
			setupDays()
		}
	}
	
	init(calendar: Calendar, date: Date, dateAvailable: @escaping ((Date) -> Bool) ) {
		self.calendar = calendar
		self.date = date
		self.dateAvailable = dateAvailable
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupCollectionView()
		setupDays()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		coordinator.animate(alongsideTransition: {  context in
			self.daysCollectionView.collectionViewLayout.invalidateLayout()
		}, completion: nil)
	}
	
	private func setupCollectionView() {
		view.addSubview(daysCollectionView)
		daysCollectionView.sizeToSuperView()
		daysCollectionView.delegate = self
		daysCollectionView.dataSource = self
	}
	
	private func setupDays() {
		guard let range = calendar.range(of: .day, in: .month, for: date) else {
			return
		}
		
		guard let dateWithoutDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
			//invalid date, what to do?
			return
		}
		
		let startWeekDay = calendar.component(.weekday, from: dateWithoutDay) - 1 //1...7
		
		for _ in 0..<startWeekDay {
			days.append(Day())
		}
		
		days.append(contentsOf: Array(range).map {
			var dateComps = calendar.dateComponents([.month, .year], from: date)
			dateComps.day = $0
			let d = calendar.date(from: dateComps)!
			return Day(title: String($0), date: d)
		})
		
		daysCollectionView.reloadData()
	}
}

extension DaysViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return days.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
		let dayModel = days[indexPath.item]
		cell.textLabel.text = dayModel.title
		if let date = dayModel.date {
			if dateAvailable(date) {
				cell.textLabel.alpha = 1
			} else {
				cell.textLabel.alpha = 0.5
			}
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let date = days[indexPath.item].date {
			onDateSelected?(date)
		}
	}
}

extension DaysViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemWidth = collectionView.frame.width / daysInAWeek
		return CGSize(width: itemWidth, height: itemWidth)
	}
}
