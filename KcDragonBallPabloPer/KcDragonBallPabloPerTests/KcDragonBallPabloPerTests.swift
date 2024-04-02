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
    
    func testHeros_data() async throws {
        let network = NetworkHerosFake()
        XCTAssertNotNil(network)
        
        let repo = HerosRepository(network: network)
        XCTAssertNotNil(repo)
        
        let repo2 = HerosRepositoryFake()
        XCTAssertNotNil(repo2)
        
        let data = await repo.getHeros(filter: "")
        XCTAssertEqual(data.count, 2)
        
        let data2 = await repo2.getHeros(filter: "")
        XCTAssertEqual(data2.count, 2)
    }
    
    func testHero_Domain() async throws {
        let model = HerosModel(id: UUID(), favorite: true, description: "Hola", photo: "", name: "goku")
        XCTAssertNotNil(model)
        
        XCTAssertEqual(model.name, "goku")
        XCTAssertEqual(model.getFullName(), "goku $")
        XCTAssertEqual(model.description, "Hola")
    }
    
    func testHeros_Presentation() async throws {
        let viewModel = HerosVeiwModel(userCaseHeros: HeroUseCaseFake())
        XCTAssertNotNil(viewModel)
        
        let view = await HerosTableViewController(appState: AppState(loginUseCase: LoginUseCaseFake()), viewModel: viewModel)
        XCTAssertNotNil(view)
    }
    
    func testTrans_Model() throws {
        let model = TransformationModel(id: UUID(), name: "Goku1", description: "", photo: "")
        XCTAssertNotNil(model)
        XCTAssertEqual(model.name, "Goku1")
        
        
        let modelResquest = TransformationModelRequest(id: "10010")
        XCTAssertNotNil(modelResquest)
        XCTAssertEqual(modelResquest.id, "10010")
    }
    
    func testTrans_Data() async throws {
        let network = NetworkHerosFake()
        XCTAssertNotNil(network)
       
        let repo = HerosRepository(network: network)
        XCTAssertNotNil(repo)
        
        let repo2 = HerosRepositoryFake()
        XCTAssertNotNil(repo2)
        
        
        let data = await repo.getHeroTransformations(idHero: "100")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
        
        let data2 = await repo2.getHeroTransformations(idHero: "100")
        XCTAssertNotNil(data2)
        XCTAssertEqual(data2.count, 2)

    }
    
    func testTrans_Domain() async throws {
        let caseUse = HeroUseCase(repo: HerosRepository(network: NetworkHerosFake()))
        XCTAssertNotNil(caseUse)
        
        let data = await caseUse.getHeroTransformations(idHero: "XXXXX")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)

    }
    
    func testTrans_Presentation()  throws {
        let viewModel = HerosVeiwModel(userCaseHeros: HeroUseCaseFake())
        XCTAssertNotNil(viewModel)

        let model = HerosModel(id: UUID(), favorite: true, description: "", photo: "", name: "goku")
        XCTAssertNotNil(model)
        
        let view =  TransformationsTableViewController(HeroSelected: model, vmHeros: viewModel)
        XCTAssertNotNil(view)
    }
}
