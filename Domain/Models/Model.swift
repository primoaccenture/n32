//
//  Model.swift
//  Domain
//
//  Created by primozalho.d.filho on 14/12/24.
//
import Foundation

public protocol Model: Codable, Equatable {
    
}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
