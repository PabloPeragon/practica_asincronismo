//
//  LoginViewController.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 30/3/24.
//

import UIKit
import Combine
import CombineCocoa


class LoginViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //usuario y clave
    private var user: String = ""
    private var pass: String = ""
    
    //combine
    private var suscriptors = Set<AnyCancellable>()
    
    
    private var appState: AppState?
    
    init(appState: AppState){
        self.appState = appState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingUI()
        
        emailText.placeholder = NSLocalizedString("User", comment: "Traduccion de ususario")
        
        passwordText.placeholder = NSLocalizedString("Password", comment: "Traduccion de contraseña")
        
        loginButton.titleLabel?.text = NSLocalizedString("Login", comment: "traduccion del boton entrar")

    }
    
    //suscriptores
    func bindingUI(){
        //usuario
        if let emailText = self.emailText {
            emailText.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    if let usr = data {
                        print(usr)
                        self?.user = usr
                    }
                }
                .store(in: &suscriptors)
        }
        
        //pass
        if let passwordText = self.passwordText {
            passwordText.textPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    if let password = data {
                        print(password)
                        self?.pass = password
                    }
                }
                .store(in: &suscriptors)
        }
        
        if let loginButton = self.loginButton {
            loginButton.tapPublisher
                .sink { [weak self] _ in
                    // llamamos al login
                    if let user = self?.user,
                       let pass = self?.pass {
                        
                        self?.appState?.loginApp(user: user, pass: pass)
                    }
                }
                .store(in: &suscriptors)
        }
        
    }

}
