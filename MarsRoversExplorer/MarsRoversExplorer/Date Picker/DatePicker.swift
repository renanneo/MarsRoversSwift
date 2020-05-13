//
//  DatePicker.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 01/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
	
	class VCContainerCell<T: UIViewController>: UICollectionViewCell {
		var vc: T?
	}
	
	let pageView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .horizontal
		let pageView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		pageView.isPagingEnabled = true
		pageView.showsHorizontalScrollIndicator = false
		pageView.register(VCContainerCell<DaysViewController>.self, forCellWithReuseIdentifier: "pageCell")
		return pageView
	}()
	
	let weekDaysStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.alignment = .center
		stack.distribution = .fillEqually
		
		return stack
	}()
	
	private let yearPicker: SimplePicker<Int>
	private let monthPicker: SimplePicker<String>
	
	private var onceOnly = false
	private let calendar = Calendar.current
	private(set) var currentDate: Date {
		didSet {
			updateDays()
		}
	}
	var availableDates: [String: Date] = [:]
	let dateInterval: DateInterval
	let months = 12
	let years: [Int]
	var onDateSelected: ((Date) -> Void)?
	
	private var vcs = [DaysViewController]()
	
	init(dateInterval: DateInterval, availableDates: Set<Date>, currentDate: Date?) {
		self.dateInterval = dateInterval
		let initialDate = dateInterval.start
		self.currentDate = currentDate ?? initialDate
		
		let initialYear = calendar.component(.year, from: initialDate)
		let finalYear = calendar.component(.year, from: dateInterval.end)
		years = Array(initialYear...finalYear)
		//let currentYear = calendar.component(.year, from: currentDate)
		
		yearPicker = SimplePicker(items: years)
		monthPicker = SimplePicker(items: calendar.shortMonthSymbols)
		
		super.init(nibName: nil, bundle: nil)
		
		for date in availableDates {
			if let key = key(for: date) {
				self.availableDates[key] = date
			}
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		setupSubviews()
		pageView.delegate = self
		pageView.dataSource = self
		updateDays()
		
		yearPicker.onItemSelected = { [weak self] year in
			self?.yearPicked(year)
		}
		
		monthPicker.onScroll = { [weak self] picker in
			self?.pageView.setContentOffset(CGPoint(x: picker.contentOffset.x * picker.visibleItems, y: 0), animated: false)
		}
	}
	
	private func updateDays() {
		vcs.removeAll()
		for i in 0..<months {
			let d = date(bySettingMonth: i + 1, of: currentDate)
			let vc = DaysViewController(calendar: calendar, date: d, dateAvailable: { [weak self] date in
				guard let self = self, let key = self.key(for: date) else {
					return false
				}
				
				return self.availableDates[key] != nil
			})
			vc.onDateSelected = { [weak self] date in
				guard let self = self, let key = self.key(for: date) else {
					return
				}
				if let d = self.availableDates[key] {
					self.onDateSelected?(d)
				}
			}
			vcs.append(vc)
		}
		pageView.reloadData()
	}
	
	private func key(for date: Date) -> String? {
		let dateComps = calendar.dateComponents([.year, .month, .day], from: date)
		if let y = dateComps.year, let m = dateComps.month, let d = dateComps.day {
			return "\(y)-\(m)-\(d)"
		}
		
		return nil
	}
	
	private func yearPicked(_ year: Int) {
		var dateComponents = calendar.dateComponents([.day, .month, .year], from: currentDate)
		dateComponents.year = year
		currentDate = calendar.date(from: dateComponents)!
	}
	
	private func date(bySettingMonth month: Int, of date: Date) -> Date {
		var dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
		dateComponents.month = month
		return calendar.date(from: dateComponents)!
	}
	
	private func setupWeekdayStack() {
		for weekday in calendar.shortWeekdaySymbols {
			let label = UILabel()
			label.text = weekday
			label.textColor = .white
			label.textAlignment = .center
			weekDaysStack.addArrangedSubview(label)
		}
	}
	
	private func setupSubviews() {
		let componenetsHeight: CGFloat = 40.0
		view.addSubview(yearPicker)
		yearPicker.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), height: componenetsHeight)
		
		view.addSubview(monthPicker)
		monthPicker.anchor(top: yearPicker.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: componenetsHeight)
		
		view.addSubview(weekDaysStack)
		weekDaysStack.anchor(top: monthPicker.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: componenetsHeight)
		
		view.addSubview(pageView)
		pageView.anchor(top: weekDaysStack.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
		
		setupWeekdayStack()
	}
	
//	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//		super .viewWillTransition(to: size, with: coordinator)
//		adjustOffset(collectionView: pageView, coordinator: coordinator, size: size)
//		adjustOffset(collectionView: monthPicker, coordinator: coordinator, size: size)
//		adjustOffset(collectionView: yearPicker, coordinator: coordinator, size: size)
//	}
//	
//	func adjustOffset(collectionView: UICollectionView, coordinator: UIViewControllerTransitionCoordinator, size: CGSize) {
//		let offset = collectionView.contentOffset
//		let width = collectionView.bounds.size.width
//		
//		let index = offset.x / width
//		let newOffset = CGPoint(x: index * size.width, y: offset.y)
//		
//		coordinator.animate(alongsideTransition: { (context) in
//			collectionView.collectionViewLayout.invalidateLayout()
//			collectionView.setContentOffset(newOffset, animated: false)
//		}, completion: nil)
//	}
}

extension DatePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func adjustCollectionViewsOffset(relativeTo collectionView: UICollectionView) {
		let dateComponents = calendar.dateComponents([.day, .month, .year], from: currentDate)
		if let month = dateComponents.month, let year = dateComponents.year {
			pageView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(month - 1), y: 0), animated: false)
			yearPicker.scrollToItem(at: IndexPath(item: years.firstIndex(of: year)!, section: 0), at: .centeredHorizontally, animated: false)
		}
	}
	
	//https://stackoverflow.com/questions/9418311/setting-contentoffset-programmatically-triggers-scrollviewdidscroll
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		monthPicker.bounds.origin = CGPoint(x:scrollView.bounds.origin.x / monthPicker.visibleItems, y: 0);
		monthPicker.scaleCells()
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if !onceOnly {
			adjustCollectionViewsOffset(relativeTo: collectionView)
			onceOnly = true
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return vcs.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as! VCContainerCell<DaysViewController>
		
		if let vc = cell.vc {
			vc.view.removeFromSuperview()
			vc.removeFromParent()
		}
		
		let daysVC = self.vcs[indexPath.item]
		cell.vc = daysVC
		addChild(daysVC)
		cell.addSubview(daysVC.view)
		daysVC.didMove(toParent: self)
		return cell
	}
}

extension DatePickerViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return collectionView.frame.size
	}
}
