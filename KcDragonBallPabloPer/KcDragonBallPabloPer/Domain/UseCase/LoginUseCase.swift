//
//  LoginUseCase.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 30/3/24.
//

import Foundation
import KcLibraryswift

protocol LoginUseCaseProtocol{
    var repo: LoginRepositoryProtocol {get set}
    func loginApp(user: String, password: String) async -> Bool
    func logout() async -> Void
    func validateToken() async -> Bool
}

//implementamos el caso de uso
final class LoginUseCase: LoginUseCaseProtocol{
    var repo: LoginRepositoryProtocol
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(Network: NetworkLogin())) {
        self.repo = repo
    }
    
    func loginApp(user: String, password: String) async -> Bool {
        
        let token = await repo.loginApp(user: user, password: password)
        
        //guardar token en keychain
        if token != "" {
            KeyChainKC().saveKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: token)
            return true
        } else {
            KeyChainKC().deleteKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
            return false
        }
    }
    
    func logout() async {
        KeyChainKC().deleteKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
    }
    
    func validateToken() async -> Bool {
        if KeyChainKC().loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN) != "" {
            return true
        } else {
            return false
        }
    }
}

//fake
final class LoginUseCaseFake: LoginUseCaseProtocol{
    var repo: LoginRepositoryProtocol
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepositoryFake()) {
        self.repo = repo
    }
    
    func loginApp(user: String, password: String) async -> Bool {
        
        let token = await repo.loginApp(user: user, password: password)
        
        //guardar token en keychain
        if token != "" {
            KeyChainKC().saveKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: token)
            return true
        } else {
            KeyChainKC().deleteKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
            return false
        }
    }
    
    func logout() async {
        KeyChainKC().deleteKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
    }
    
    func validateToken() async -> Bool {
        true
    }
}
