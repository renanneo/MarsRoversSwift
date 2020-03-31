//
//  RoverTableViewCell.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 07/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class GradientView: UIView {
  override open class var layerClass: AnyClass {
    return CAGradientLayer.classForCoder()
  }
}

class RoverTableViewCell: UITableViewCell {
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title3)
    label.textColor = .white
    return label
  }()
  
  let gradientView: GradientView = {
    let view = GradientView()
    let layer = view.layer as! CAGradientLayer
    layer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
    return view
  }()
  
  let backgroundImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(backgroundImageView)
    addSubview(gradientView)
    addSubview(titleLabel)
    
    setupConstraints()
    
    layer.cornerRadius = 20.0
    clipsToBounds = true
  }
  
  func setupConstraints() {
    titleLabel.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, padding: .init(top: 0, left: 20, bottom: 20, right: 0))
    backgroundImageView.sizeToSuperView()
    gradientView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    gradientView.heightAnchor.constraint(equalToConstant: 60).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
