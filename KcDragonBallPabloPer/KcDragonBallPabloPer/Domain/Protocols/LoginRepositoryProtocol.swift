//
//  LoginRepositoryProtocol.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 30/3/24.
//

import Foundation

protocol LoginRepositoryProtocol {
    func loginApp(user: String, password: String) async -> String //devuelve el token
}
