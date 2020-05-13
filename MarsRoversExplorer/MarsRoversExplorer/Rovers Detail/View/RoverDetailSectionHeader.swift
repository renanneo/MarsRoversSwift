//
//  RoverDetailSectionHeader.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 23/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

final class RoversDetailSectionHeader: UICollectionReusableView {
	
	let textLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .systemFont(ofSize: 20.0, weight: .bold)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupTextLabel()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupTextLabel()
	}
	
	private func setupTextLabel() {
		addSubview(textLabel)
		textLabel.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
	}
	
}
