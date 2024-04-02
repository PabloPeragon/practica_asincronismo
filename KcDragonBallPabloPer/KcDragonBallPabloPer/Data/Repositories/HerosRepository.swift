//
//  HerosRepository.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 1/4/24.
//

import Foundation

//Real
final class HerosRepository: HerosRepositoryProtocol {
    private var Network: NetworkHerosProtocol
    
    init(network: NetworkHerosProtocol = NetworkHeros()){
        Network = network
    }
    
    func getHeros(filter: String) async -> [HerosModel] {
        return await Network.getHeros(filter: filter)
    }
    
    func getHeroTransformations(idHero: String) async -> [TransformationModel] {
        await Network.getHeroTransformations(idHero: idHero)
    }
}

//Fake
final class HerosRepositoryFake: HerosRepositoryProtocol {
    private var Network: NetworkHerosProtocol
    
    init(network: NetworkHerosProtocol = NetworkHerosFake()){
        Network = network
    }
    
    func getHeros(filter: String) async -> [HerosModel] {
        return await Network.getHeros(filter: filter)
    }
    
    func getHeroTransformations(idHero: String) async -> [TransformationModel] {
        await Network.getHeroTransformations(idHero: idHero)
    }
}

