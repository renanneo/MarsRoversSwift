//
//  AlertPresentable.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

//??
import UIKit

protocol AlertPresentableViewModel {
    var alertModel: Observable<AlertViewModel?> { get set }
}

protocol AlertPresentableView {
    associatedtype VMType: AlertPresentableViewModel
	
    var viewmodel: VMType { get }
}

extension AlertPresentableView where Self: UIViewController {
    func bindToAlerts() {
			viewmodel.alertModel.observe(on: self) { [weak self] model in
				guard let model = model else {
					return
				}
				
				let alert = AlertBuilder.buildAlertController(for: model)
				self?.present(alert, animated: true, completion: nil)
			}
    }
}
