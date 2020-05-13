//
//  RoverDetailCollectionVIewCell.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 23/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

final class RoversDetailCollectionViewCell: UICollectionViewCell {
	
	let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupImageView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupImageView()
	}
	
	private func setupImageView() {
		addSubview(imageView)
		imageView.sizeToSuperView()
	}
	
}
