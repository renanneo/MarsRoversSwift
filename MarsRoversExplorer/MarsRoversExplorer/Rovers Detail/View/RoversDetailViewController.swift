//
//  RoversDetailViewController.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class RoversDetailSectionHeader: UICollectionReusableView {
	let textLabel = UILabel()
	override init(frame: CGRect) {
		super.init(frame: frame)
		textLabel.textColor = .white
		textLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
		addSubview(textLabel)
		textLabel.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class RoversDetailCollectionViewCell: UICollectionViewCell {
	
	let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(imageView)
		imageView.sizeToSuperView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

class RoversDetailViewController: UIViewController {
	let viewModel: RoversDetailViewModel
	var sections = [RoversDetailSectionViewModel]()
	
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
	
	init(viewModel: RoversDetailViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .red
		title = viewModel.title
		
		setupCollectionView()
		
		viewModel.sections.observe(on: self) { [weak self] sections in
			self?.sections = sections
			self?.collectionView.reloadData()
		}
		viewModel.viewLoaded()
	}
	
	func setupCollectionView() {
		view.addSubview(collectionView)
		collectionView.sizeToSuperView()
		collectionView.delegate = self
		collectionView.dataSource = self
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
