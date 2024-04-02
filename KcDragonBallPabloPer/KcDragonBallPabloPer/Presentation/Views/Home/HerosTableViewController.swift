//
//  HerosTableViewController.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 1/4/24.
//

import UIKit
import Combine

class HerosTableViewController: UITableViewController {
    
    private var appState: AppState
    private var viewModel: HerosVeiwModel
    
    private var suscriptors = Set<AnyCancellable>()
    
    init(appState: AppState, viewModel: HerosVeiwModel) {
        self.appState = appState
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //registro de celda personalizada
        tableView.register(UINib(nibName: "HeroTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        //tutulo en el navigation controller
        self.title = "Lista de heroes"
        
        
        //añadimos un boton para cerrar session
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSession))
           
        //binding al viewModel
        binding()
 
    }
    
    @objc func closeSession(){
        appState.closeSessionUser()
    }
    
    func binding(){
        self.viewModel.$herosData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                //recargamos la tabla
                self.tableView.reloadData()
            })
            .store(in: &suscriptors)
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.herosData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HeroTableViewCell
        
        //El modelo
        let hero = viewModel.herosData[indexPath.row]
        
        //compongo la celda
        cell.title.text = hero.name
        cell.photo.loadImageRemote(url: URL(string: hero.photo)!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = viewModel.herosData[indexPath.row]
        
        //cargo el controlador sobre el navegador y le pasamos el hero y el viewModel. La vista lanza la carga necesaria.
        
        let vm = TransformationsTableViewController(HeroSelected: hero, vmHeros: self.viewModel)
        self.navigationController?.pushViewController(vm, animated: true)
    }
}
