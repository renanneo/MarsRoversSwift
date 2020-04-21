//
//  SimplePicker.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 06/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class SimplePicker<T: CustomStringConvertible>: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	class SimplePickerCell: UICollectionViewCell {
		//public var mainView = UIView()
		let minAlpha: CGFloat = 0.75
		let minScale: CGFloat = 0.75
		
		let textLabel: UILabel = {
			let label = UILabel()
			label.textAlignment = .center
			label.textColor = .white
			label.backgroundColor = .purple
			label.font = .systemFont(ofSize: 20, weight: .medium)
			label.clipsToBounds = true
			return label
		}()
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			self.contentView.addSubview(textLabel)
			//self.addSubview(mainView)
			self.textLabel.sizeToSuperView()
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func layoutSubviews() {
			super.layoutSubviews()
			scale()
		}
		
		override func prepareForReuse() {
			super.prepareForReuse()
			textLabel.transform = .identity
			textLabel.alpha = 1
		}
		
		open func scale(withCarouselInset carouselInset: CGFloat = 0) {
			// Ensure we have a superView, and mainView
			guard let superview = superview else { return }
			
			// Get our absolute origin value
			let originX = superview.convert(frame, to: superview.superview).origin.x
			
			let width = frame.size.width
			let maxDistance = superview.frame.width/2 - width/2
			let distance = abs(originX - maxDistance)
			
			let alphaValue = 1.0 - ((distance * (1.0 - minAlpha)) / maxDistance)
			let scaleValue = 1.0 - ((distance * (1.0 - minScale)) / maxDistance)
			//let perspectiveAngle = 0 + ((distance * (180.0 - minScale)) / maxDistance)
			textLabel.transform = CGAffineTransform.identity.scaledBy(x: scaleValue, y: scaleValue)
			
			//			var perspectiveTransform = CATransform3DIdentity
			//			perspectiveTransform.m34 = 1.0 / -500;
			//			perspectiveTransform = CATransform3DRotate(perspectiveTransform, CGFloat(-45 * .pi / 180.0), 0.0, 1.0, 0.0);
			//			textLabel.layer.transform = perspectiveTransform
			//textLabel.transform3D = CATransform3DMakeRotation(.pi/3, 0, 1, 0)
			textLabel.alpha = alphaValue
			textLabel.layer.cornerRadius = 15
		}
	}
	
	var onItemSelected: ((T) -> Void)?
	var onScroll: ((SimplePicker<T>) -> Void)?
	
	private let flowLayout: UICollectionViewFlowLayout = {
		let flow = UICollectionViewFlowLayout()
		flow.scrollDirection = .horizontal
		flow.minimumInteritemSpacing = 0
		flow.minimumLineSpacing = 0
		return flow
	}()
	
	private let items: [T]
	private let impactGenerator: UIImpactFeedbackGenerator
	let visibleItems: CGFloat = 3.0
	var observer: NSKeyValueObservation?
	
	init(items: [T] = []) {
		self.items = items
		self.impactGenerator = .init(style: .medium)
		
		super.init(frame: .zero, collectionViewLayout: self.flowLayout)
		
		self.register(SimplePickerCell.self, forCellWithReuseIdentifier: "cell")
		self.showsHorizontalScrollIndicator = false
		self.delegate = self
		self.dataSource = self
	
		
//		self.observer = observe(\Self.bounds, options: .new) { [weak self] object, change in
//			guard let self = self else {
//				return
//			}
//
//			if let newBounds = change.newValue {
//				if newBounds.origin.x.truncatingRemainder(dividingBy:newBounds.width / self.visibleItems) == .zero {
//					self.impactGenerator.impactOccurred()
//				}
//			}
//		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width / visibleItems, height: collectionView.frame.height * 0.8)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimplePickerCell
		cell.textLabel.text = self.items[indexPath.item].description.uppercased()
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		let itemWidth = collectionView.frame.width / visibleItems
		let inset = itemWidth
		return .init(top: 0, left: inset, bottom: 0, right: inset)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
		centerItem(atIndexPath: indexPath)
	}
	
	private func centerItem(atIndexPath indexPath: IndexPath) {
		scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		onItemSelected?(items[indexPath.item])
	}
	
	func snapToCenter() {
		guard let superview = superview else {
			return
		}
		
		let centerPoint = superview.convert(center, to: self)
		if let centerIndexPath = indexPathForItem(at: centerPoint) {
			print("snapping to center")
			centerItem(atIndexPath: centerIndexPath)
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate {
			snapToCenter()
		}
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		snapToCenter()
	}
	
	func scaleCells() {
		for cell in visibleCells {
			if let infoCardCell = cell as? SimplePickerCell {
				infoCardCell.scale()
			}
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		scaleCells()
		onScroll?(self)
	}
}
