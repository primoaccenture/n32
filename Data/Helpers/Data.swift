//
//  Data.swift
//  Data
//
//  Created by primozalho.d.filho on 14/12/24.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
