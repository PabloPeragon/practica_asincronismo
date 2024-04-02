//
//  TransformationsTableViewCell.swift
//  KcDragonBallPabloPer
//
//  Created by Pablo Jesús Peragón Garrido on 2/4/24.
//

import UIKit

class TransformationsTableViewCell: UITableViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
