//
//  LoginRepository.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 30/3/24.
//

import Foundation

//Real
final class DefaultLoginRepository: LoginRepositoryProtocol {
    private var Network: NetworkLoginProtocol
    
    init(Network: NetworkLoginProtocol) {
        self.Network = Network
    }
    
    func loginApp(user: String, password: String) async -> String {
        return await Network.loginApp(user: user, password: password)
    }
}

//Fake
final class DefaultLoginRepositoryFake: LoginRepositoryProtocol {
    private var Network: NetworkLoginProtocol
    
    init(Network: NetworkLoginProtocol = NetworkLoginFake()) {
        self.Network = Network
    }
    
    func loginApp(user: String, password: String) async -> String {
        return await Network.loginApp(user: user, password: password)
    }
}
