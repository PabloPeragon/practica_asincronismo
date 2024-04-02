//
//  UiImageView+extension.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 1/4/24.
//

import UIKit

extension UIImageView {
    func loadImageRemote(url: URL) {
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url) {
                if let imagen = UIImage(data: data) {
                    //toto ok.
                    DispatchQueue.main.async {
                        self?.image = imagen
                    }
                }
            }
        }
    }
}
