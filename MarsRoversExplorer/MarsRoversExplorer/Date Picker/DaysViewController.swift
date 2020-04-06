//
//  DaysViewController.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 06/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class DaysViewController: UIViewController {
	
	struct DayCellViewModel {
		var title: String?
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
		//flow.sectionInset = .init(top: 20, left: 0, bottom: 0, right: 0)
		flow.minimumLineSpacing = 0
		flow.minimumInteritemSpacing = 0
		let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
		cv.register(DayCell.self, forCellWithReuseIdentifier: "dayCell")
		cv.backgroundColor = .clear
		return cv
	}()
	
	private var days: [DayCellViewModel] = []
	private let calendar: Calendar
	
	let date: Date
	
	init(calendar: Calendar, date: Date) {
		self.calendar = calendar
		self.date = date
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(daysCollectionView)
		daysCollectionView.sizeToSuperView()
		daysCollectionView.delegate = self
		daysCollectionView.dataSource = self
		
		setupDays()
	}
	
	private func setupDays() {
		guard let range = calendar.range(of: .day, in: .month, for: date) else {
			return
		}
		
		let startWeekDay = date.firstDayOfTheMonth.weekday - 1 //1...7
		
		var tempDays = [DayCellViewModel]()
		for _ in 0..<startWeekDay {
			tempDays.append(DayCellViewModel())
		}
		
		tempDays = tempDays + Array(range).map {DayCellViewModel(title: String($0))}
		days = tempDays
		daysCollectionView.reloadData()
	}
}

extension DaysViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return days.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
		cell.textLabel.text = days[indexPath.item].title
		return cell
	}
}

extension DaysViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemWidth = collectionView.frame.width / 7.0
		return CGSize(width: itemWidth, height: itemWidth)
	}
}
