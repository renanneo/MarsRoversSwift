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
	let initialDate: Date
	let finalDate: Date
	var currentDate: Date
	let months = 12
	let years: [Int]
	
	private var vcs = [DaysViewController]()
	
	init(initialDate: Date, finalDate: Date, currentDate: Date?) {
		self.initialDate = initialDate
		self.finalDate = finalDate
		self.currentDate = currentDate ?? initialDate
		
		let initialYear = calendar.component(.year, from: initialDate)
		let finalYear = calendar.component(.year, from: finalDate)
		self.years = Array(initialYear...finalYear)
		//let currentYear = calendar.component(.year, from: currentDate)
		
		self.yearPicker = SimplePicker(items: self.years)
		self.monthPicker = SimplePicker(items: calendar.shortMonthSymbols)
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
		updateDays()
		
		yearPicker.onItemSelected = { [weak self] year in
			self?.yearPicked(year)
		}
		
		monthPicker.onScroll = { [weak self] scrollView in
			self?.pageView.setContentOffset(CGPoint(x: scrollView.contentOffset.x * 3.0, y: 0), animated: false)
		}
	}
	
	private func updateDays() {
		vcs.removeAll()
		for i in 0..<months {
			let d = date(forMonth: i + 1, inDate: currentDate)
			vcs.append(DaysViewController(calendar: calendar, date: d))
		}
		pageView.reloadData()
	}
	
	private func yearPicked(_ year: Int) {
		var dateComponents = calendar.dateComponents([.day, .month, .year], from: currentDate)
		dateComponents.year = year
		currentDate = calendar.date(from: dateComponents)!
		updateDays()
	}
	
	private func date(forMonth month: Int, inDate date: Date) -> Date {
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
		view.addSubview(yearPicker)
		yearPicker.translatesAutoresizingMaskIntoConstraints = false
		yearPicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
		yearPicker.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
		
		view.addSubview(monthPicker)
		monthPicker.translatesAutoresizingMaskIntoConstraints = false
		monthPicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
		monthPicker.anchor(top: yearPicker.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
		
		view.addSubview(weekDaysStack)
		weekDaysStack.translatesAutoresizingMaskIntoConstraints = false
		weekDaysStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
		weekDaysStack.anchor(top: monthPicker.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
		
		setupWeekdayStack()
		
		view.addSubview(pageView)
		pageView.anchor(top: weekDaysStack.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
		pageView.delegate = self
		pageView.dataSource = self
	}
}

extension DatePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	//https://stackoverflow.com/questions/9418311/setting-contentoffset-programmatically-triggers-scrollviewdidscroll
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		monthPicker.bounds.origin = CGPoint(x:scrollView.bounds.origin.x / 3, y: 0);
		monthPicker.scaleCells()
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if !onceOnly {
			let dateComponents = calendar.dateComponents([.day, .month, .year], from: currentDate)
			if let month = dateComponents.month, let year = dateComponents.year {
				pageView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(month - 1), y: 0), animated: false)
				yearPicker.scrollToItem(at: IndexPath(item: years.firstIndex(of: year)!, section: 0), at: .centeredHorizontally, animated: false)
			}
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
