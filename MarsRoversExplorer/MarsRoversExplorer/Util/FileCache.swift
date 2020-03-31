//
//  FIleManager.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 31/03/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

protocol CacheProtocol {
	func save<T: Codable>(object: T, identifier: String) throws
	func load<T>(identifier: String) throws -> T
}

//struct FileCache: CacheProtocol {
//	
//	func load<T>(identifier: String) throws -> T {
//		let fileURL = getDocumentsDirectory().appendingPathComponent(identifier)
//		let data = try Data(contentsOf: fileURL)
//		return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
//	}
//	
//	func save<T: Codable>(object: T, identifier: String) throws {
//		if let dict = try? object.toDictionary() {
//			let data = try? NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: false)
//			let fileURL = getDocumentsDirectory().appendingPathComponent(identifier)
//			try data?.write(to: fileURL, options: .atomic)
//		}
//	}
//	
//	func getDocumentsDirectory() -> URL {
//			let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
//			return paths[0]
//	}
//}
