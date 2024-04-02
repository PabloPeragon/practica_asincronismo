//
//  HerosModel.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 1/4/24.
//

import Foundation

struct HerosModel: Codable {
    let id: UUID
    let favorite: Bool
    let description: String
    let photo: String
    let name: String
    
    func getFullName() -> String {
        return "\(name) $"
    }
}


struct HerosModelRequest: Codable {
    let name: String
}
