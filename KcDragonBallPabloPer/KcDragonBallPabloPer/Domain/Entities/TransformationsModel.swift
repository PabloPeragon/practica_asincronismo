//
//  TransformationsModel.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 2/4/24.
//

import Foundation

struct TransformationModel: Codable {
    let id: UUID
    let name: String
    let description: String
    let photo: String

}


struct TransformationModelRequest: Codable {
    let id: String
}
