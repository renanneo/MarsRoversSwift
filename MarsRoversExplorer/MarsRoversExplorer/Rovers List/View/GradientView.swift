//
//  GradientView.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 20/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class GradientView: UIView {
  override open class var layerClass: AnyClass {
    return CAGradientLayer.classForCoder()
  }
}
