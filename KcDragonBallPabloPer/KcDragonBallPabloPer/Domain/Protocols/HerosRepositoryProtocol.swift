//
//  HerosRepositoryProtocol.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 1/4/24.
//

import Foundation

protocol HerosRepositoryProtocol {
    func getHeros(filter: String) async -> [HerosModel]
    func getHeroTransformations(idHero: String) async -> [TransformationModel]
}
