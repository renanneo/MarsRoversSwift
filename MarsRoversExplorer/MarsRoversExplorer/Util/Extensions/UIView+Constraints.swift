//
//  UIView+Extensions.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 20/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

extension UIView {
	
	func sizeToSuperView() {
		guard let superview = superview else {
			return
		}
		
		anchor(top: superview.topAnchor, bottom: superview.bottomAnchor, leading: superview.leadingAnchor, trailing: superview.trailingAnchor)
	}
	
	func constraintSize(width: CGFloat? = nil, height: CGFloat? = nil) {
		translatesAutoresizingMaskIntoConstraints = false
		
		if let width = width {
			widthAnchor.constraint(equalToConstant: width).isActive = true
		}
		
		if let height = height {
			heightAnchor.constraint(equalToConstant: height).isActive = true
		}
	}
	
	func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, width: CGFloat? = nil, height: CGFloat? = nil) {
		
		translatesAutoresizingMaskIntoConstraints = false
		
		constraintSize(width: width, height: height)
		
		if let top = top {
			topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
		}
		
		if let bottom = bottom {
			bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
		}
		
		if let leading = leading {
			leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
		}
		
		if let trailing = trailing {
			trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
		}
	}
	
}
