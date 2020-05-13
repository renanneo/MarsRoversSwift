//
//  RoversDetailViewController.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit
import Lottie

class RoversDetailViewController: UIViewController {
	let viewmodel: RoversDetailViewModelType
	fileprivate var sections = [RoversDetailSectionViewModel]()
	let headerButton = UIButton()
	let loadingView = AnimationView(name: "1712-bms-rocket")
	
	let flowLayout: UICollectionViewFlowLayout = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.minimumLineSpacing = 1
		flowLayout.minimumInteritemSpacing = 1
		let itemCount: CGFloat = 4.0
		let width = ceil((UIScreen.main.bounds.size.width / itemCount) - ((itemCount - 1) * flowLayout.minimumInteritemSpacing))
		flowLayout.itemSize = CGSize(width: width, height:width)
		return flowLayout
	}()
	
	lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.alwaysBounceVertical = true
		collectionView.register(RoversDetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.register(RoversDetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")
		return collectionView
	}()
	
	init(viewModel: RoversDetailViewModelType) {
		self.viewmodel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initialSetup()
		title = viewmodel.output.title
		
		setupBindings()
		
		viewmodel.input.viewLoaded()
	}
	
	private func setupBindings() {
		viewmodel.output.calendarModel.observe(on: self) { [weak self] model in
			guard let model = model else {
				self?.dismiss(animated: true, completion: nil)
				return
			}
			
			let calendar = CalendarBuilder.buildCalendar(for: model)
			self?.present(calendar, animated: true, completion: nil)
		}
		
		viewmodel.output.state.observe(on: self) { [weak self] state in
				guard let self = self else {
					return
				}
				switch state {
				case .success(let sections):
					self.handleSuccess(sections)
				case .error(let error):
					print(error.localizedDescription)
				case .loading:
					self.handleLoading()
				}
			}
		
		viewmodel.output.headerViewModel.observe(on: self) { [weak self] headerVM in
			self?.headerButton.setTitle(headerVM.title, for: .normal)
		}
	}
	
	@objc private func headerTapped() {
		viewmodel.input.headerTapped()
	}
}

//State Handling
private extension RoversDetailViewController {
	func handleLoading() {
		headerButton.setTitle(nil, for: .normal)
		collectionView.alpha = 0
		loadingView.stop()
		loadingView.alpha = 1
		loadingView.play(fromProgress: 0.6, toProgress: 0.8, loopMode: .autoReverse, completion: nil)
	}
	
	func handleSuccess(_ sections: [RoversDetailSectionViewModel]) {
		self.sections = sections
		collectionView.reloadData()
		UIView.animate(withDuration: 0.2, animations: {
			self.loadingView.transform = .init(translationX: 50, y: -50)
			self.loadingView.alpha = 0
			self.collectionView.alpha = 1
		}) { finished in
			self.loadingView.transform = .identity
			self.loadingView.stop()
		}
	}
}

//Setup
private extension RoversDetailViewController {
	func initialSetup() {
		view.backgroundColor = .black
		setupHeader()
		setupCollectionView()
		setupLoadingView()
	}
	
	func setupCollectionView() {
		view.addSubview(collectionView)
		collectionView.anchor(top: headerButton.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
		collectionView.delegate = self
		collectionView.dataSource = self
	}
	
	func setupHeader() {
		headerButton.setTitleColor(.white, for: .normal)
		headerButton.contentHorizontalAlignment = .left
		view.addSubview(headerButton)
		headerButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0), height: 44)
		headerButton.addTarget(self, action: #selector(self.headerTapped), for: .touchUpInside)
	}
	
	func setupLoadingView() {
		loadingView.backgroundBehavior = .pauseAndRestore
		loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		loadingView.center = view.center
		view.addSubview(loadingView)
		loadingView.contentMode = .scaleAspectFill
	}
}

extension RoversDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard sections.count > 0 else {
			return 0
		}
		
		let section = sections[section]
		return section.items.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let view =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! RoversDetailSectionHeader
		view.textLabel.text = sections[indexPath.section].title
		
		return view
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RoversDetailCollectionViewCell
		
		let section = sections[indexPath.section]
		let item = section.items[indexPath.item]
		
		if let url = URL(string: item.photoURL) {
			cell.imageView.load(with: url)
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.bounds.size.width, height: 40)
	}
}
