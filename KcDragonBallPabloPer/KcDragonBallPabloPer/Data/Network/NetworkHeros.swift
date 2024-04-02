//
//  NetworkHeros.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 1/4/24.
//

import Foundation
import KcLibraryswift

protocol NetworkHerosProtocol {
    func getHeros(filter: String) async -> [HerosModel]
    func getHeroTransformations(idHero: String) async -> [TransformationModel]
}

final class NetworkHeros: NetworkHerosProtocol {
    func getHeros(filter: String) async -> [HerosModel] {
        var modelReturn = [HerosModel]()
        
        let urlCad = "\(ConstantsApp.CONST_API_URL)\(Endpoints.heros.rawValue)"
        var request = URLRequest(url: URL(string: urlCad)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(HerosModelRequest(name: filter))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        
        //necesitamos el token
        let tokenJWT = KeyChainKC().loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        
        if let token = tokenJWT {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        //llamamos al servidor
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode == HTTPResponseCodes.SUCESS {
                    modelReturn = try! JSONDecoder().decode([HerosModel].self, from: data)
                }
            }
        } catch {
            
        }
        return modelReturn
    }
    
    //return de transformaciones
    func getHeroTransformations(idHero: String) async -> [TransformationModel] {
        var modelReturn = [TransformationModel]()
        
        let urlCad = "\(ConstantsApp.CONST_API_URL)\(Endpoints.transformations.rawValue)"
        var request = URLRequest(url: URL(string: urlCad)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(TransformationModelRequest(id: idHero))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        
        //neceistamos el token JWT
        let tokenJWT = KeyChainKC().loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        
        if let token = tokenJWT {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        //llamada al servidor
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode == HTTPResponseCodes.SUCESS {
                    modelReturn = try! JSONDecoder().decode([TransformationModel].self, from: data)
                }
            }
        } catch {
            
        }
        return modelReturn
    }
}

//Fake

final class NetworkHerosFake: NetworkHerosProtocol {
    func getHeros(filter: String) async -> [HerosModel] {
        
        let model1 = HerosModel(id: UUID(), favorite: true, description: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.", photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300", name: "Goku")
      
       let model2 = HerosModel(id: UUID(), favorite: true, description: "Vegeta es todo lo contrario. Es arrogante, cruel y despreciable. Quiere conseguir las bolas de Dragón y se enfrenta a todos los protagonistas, matando a Yamcha, Ten Shin Han, Piccolo y Chaos. Es despreciable porque no duda en matar a Nappa, quien entonces era su compañero, como castigo por su fracaso. Tras el intenso entrenamiento de Goku, el guerrero se enfrenta a Vegeta y estuvo a punto de morir. Lejos de sobreponerse, Vegeta huye del planeta Tierra sin saber que pronto tendrá que unirse a los que considera sus enemigos.", photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300", name: "Vegeta")
        
       return [model1, model2]
        
        
        
    }
    
    //return the transformations of hero
    func getHeroTransformations(idHero: String) async -> [TransformationModel] {
       let trans1 = TransformationModel(id: UUID(), name: "1. Oozaru – Gran Mono", description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru", photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp")
        
        
        let trans2 = TransformationModel(id: UUID(), name: "2. Kaio-Ken", description: "La técnica de Kaio-sama permitía a Goku aumentar su poder de forma exponencial durante un breve periodo de tiempo para intentar realizar un ataque que acabe con el enemigo, ya que después de usar esta técnica a niveles altos el cuerpo de Kakarotto queda exhausto. Su máximo multiplicador de poder con esta técnica es de hasta x20, aunque en la película en la que se enfrenta contra Lord Slug es capaz de envolverse en éste aura roja a nivel x100", photo: "https://areajugones.sport.es/wp-content/uploads/2017/05/Goku_Kaio-Ken_Coolers_Revenge.jpg")
        
        return [trans1, trans2]
    }
}

