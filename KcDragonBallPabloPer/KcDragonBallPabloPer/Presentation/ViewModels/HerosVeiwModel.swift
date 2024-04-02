//
//  HerosVeiwModel.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 1/4/24.
//

import Foundation
import Combine

final class HerosVeiwModel: ObservableObject {
    @Published var herosData = [HerosModel]()
    @Published var transformationHeroData = [TransformationModel]()
    
    private var userCaseHeros: herosUseCaseProtocol
    
    init(userCaseHeros: herosUseCaseProtocol = HeroUseCase()) {
        self.userCaseHeros = userCaseHeros
        
        Task(priority: .high){
            await getHeros()
        }
    }
    
    //carga de los heroes
    func getHeros() async {
        let data = await userCaseHeros.getHeros(filter: "")
        
        //asigno en el hilo principal para la actualizacion de la UI
        DispatchQueue.main.async {
            self.herosData = data
        }
    }
    
    //carga de las transformaciones
    func getHeroTransformation(idHero: String) async {
        let data = await userCaseHeros.getHeroTransformations(idHero: idHero)
        
        DispatchQueue.main.async {
            self.transformationHeroData = data
        }
    }
}
