//
//  Extensions.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 07/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

extension Encodable {
	
	func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
		let data = try encoder.encode(self)
		let object = try JSONSerialization.jsonObject(with: data)
		guard let json = object as? [String: Any] else {
			let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
			throw DecodingError.typeMismatch(type(of: object), context)
		}
		return json
	}
}
