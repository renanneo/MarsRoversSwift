//
//  Data.swift
//  CodingStudies
//
//  Created by Renan Santos Soares on 11/01/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

struct JSONFileLoader {
  static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
      fatalError("Could not find \(filename) in main bundle")
    }
    
    do {
      try data = Data(contentsOf: file)
    } catch {
      fatalError("Could not load \(filename) from main bundle:\n\(error)")
    }
    
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(T.self, from: data)
    } catch {
      fatalError("Could not parse \(filename) as \(T.self):\n\(error)")
    }
  }
}


