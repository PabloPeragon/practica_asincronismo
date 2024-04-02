//
//  KcDragonBallPabloPerTests.swift
//  KcDragonBallPabloPerTests
//
//  Created by Pablo Jesús Peragón Garrido on 30/3/24.
//

import XCTest
@testable import KcDragonBallPabloPer
import Combine
import CombineCocoa
import UIKit
import KcLibraryswift

final class KcDragonBallPabloPerTests: XCTestCase {
    
    func testKeyChainLibrary() throws {
        let kc = KeyChainKC()
        XCTAssertNotNil(kc)
        
        let save = kc.saveKC(key: "Test", value: "123")
        XCTAssertEqual(save, true)
        
        let value = kc.loadKC(key: "Test")
        if let valor = value{
            XCTAssertEqual(valor, "123")
        }
        
        XCTAssertNoThrow(kc.deleteKC(key: "test"))
    }
    
    func testNetworkLogin() async throws {
        let obj1 = NetworkLogin()
        XCTAssertNotNil(obj1)
        let obj2 = NetworkLoginFake()
        XCTAssertNotNil(obj2)
        
        let tokenFake = await obj2.loginApp(user: "", password: "")
        XCTAssertNotEqual(tokenFake, "")
        
        let token = await obj1.loginApp(user: "lala", password: "papa")
        XCTAssertEqual(token, "")
    }
    
    func testLoginFake() async throws {
        let KC = KeyChainKC()
        XCTAssertNotNil(KC)
        
        let obj = LoginUseCaseFake()
        XCTAssertNotNil(obj)
        
        //validar el token
        let resp = await obj.validateToken()
        XCTAssertEqual(resp, true)
        
        //login
        let dloginDo = await obj.loginApp(user: "", password: "")
        XCTAssertEqual(dloginDo, true)
        
        var jwt = KC.loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
        
        //close session
        await obj.logout()
        jwt = KC.loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }
    
    
    func testLoginReal() async throws {
        let KC = KeyChainKC()
        XCTAssertNotNil(KC)
        
        KC.saveKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: "")
        
        //caso de uso con repo fake
        let useCase = LoginUseCase(repo: DefaultLoginRepositoryFake())
        XCTAssertNotNil(useCase)
        
        //validar
        let resp = await useCase.validateToken()
        XCTAssertEqual(resp, false)
        
        //login
        let dloginDo = await useCase.loginApp(user: "", password: "")
        XCTAssertEqual(dloginDo, true)
        
        var jwt = KC.loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
        
        //close session
        await useCase.logout()
        jwt = KC.loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }
    
    func testUIErrorView() async throws {
        let appStateVM = AppState(loginUseCase: LoginUseCaseFake())
        
        appStateVM.statusLogin = .error
        
        let vc = await ErrorViewController(appState: appStateVM, error: "Error")
        XCTAssertNotNil(vc)
    }
    
    func testHeroViewModel() async throws {
        let vm = HerosVeiwModel(userCaseHeros: HeroUseCaseFake())
        XCTAssertNotNil(vm)
    }
    
    func testHerosUseCase() async throws {
        let usecase = HeroUseCase(repo: HerosRepositoryFake())
        XCTAssertNotNil(usecase)
        
        let data = await usecase.getHeros(filter: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
    }
    
    
    func testTransforUseCase() async throws {
        let usecase = HeroUseCase(repo: HerosRepositoryFake())
        XCTAssertNotNil(usecase)
        
        let data = await usecase.getHeroTransformations(idHero: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
    }
        
}
