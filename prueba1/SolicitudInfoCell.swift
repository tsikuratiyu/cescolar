//
//  SolicitudInfoCell.swift
//  prueba1
//
//  Created by Juan Carlos on 12/25/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

import UIKit
import Eureka
import Foundation

final  class SolicitudInfoCell:  Cell<String>, CellType {

    @IBOutlet weak var Miniatura: UIImageView!
    @IBOutlet weak var Titulo: UILabel!
    @IBOutlet weak var Descripcion: UILabel!
    @IBOutlet weak var Costo: UILabel!
    
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



