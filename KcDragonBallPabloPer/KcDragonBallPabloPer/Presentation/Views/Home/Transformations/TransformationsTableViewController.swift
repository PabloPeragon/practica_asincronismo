//
//  TransformationsTableViewController.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 2/4/24.
//

import UIKit
import Combine

class TransformationsTableViewController: UITableViewController {
    
    private var Hero: HerosModel
    private var vm: HerosVeiwModel
    
    private var suscriptors = Set<AnyCancellable>()
    
    init(HeroSelected: HerosModel, vmHeros: HerosVeiwModel){
        self.Hero = HeroSelected
        self.vm = vmHeros
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TransformationsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        self.title = self.Hero.name
        binding()
        
        //Lanzamos las transformaciones
        Task{
            await self.vm.getHeroTransformation(idHero: self.Hero.id.uuidString)
        }


    }
    
    private func binding(){
        self.vm.$transformationHeroData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { data in
                self.tableView.reloadData()
            })
            .store(in: &suscriptors)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.transformationHeroData.count == 0{
            return 1
        } else {
            return vm.transformationHeroData.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransformationsTableViewCell
        
        if vm.transformationHeroData.count == 0 {
            cell.title.text = "No hay transformaciones"
            cell.descripcion.text = ""
            cell.photo.image = nil
        } else {
            //cogemos el modelo de la transformacion
            let transformationModel = self.vm.transformationHeroData[indexPath.row]
            
            //creamos la celda
            cell.title.text = transformationModel.name
            cell.photo.loadImageRemote(url: URL(string: transformationModel.photo)!)
            cell.descripcion.text = transformationModel.description
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    

}
