//
//  ImageLoading.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func load(with url: URL) {
			kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }
}
