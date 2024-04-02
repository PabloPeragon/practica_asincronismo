//
//  AppState.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 30/3/24.
//

import Foundation
import Combine

//Control del estado de la app
enum LoginStatus {
    case none
    case success
    case error
    case notValidate
}

//ViewModel
final class AppState {
    
    //estado del login
    @Published var statusLogin: LoginStatus = .none
    
    private var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    //funcion de login
    func loginApp(user: String, pass: String){
        
        Task{
            if (await loginUseCase.loginApp(user: user, password: pass)){
                self.statusLogin = .success
            } else {
                self.statusLogin = .error
            }
        }
    }
    
    //evaluo autologin
    func validateControlLogin(){
        Task{
            if (await loginUseCase.validateToken()) {
                self.statusLogin = .success
            } else {
                self.statusLogin = .notValidate
            }
        }
    }
    func closeSessionUser() {
        Task{
            await loginUseCase.logout()
            self.statusLogin = .none
        }
    }
    
}

