//
//  File.swift
//  prueba1
//
//  Created by Juan Carlos on 12/25/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

import Foundation


struct Solicitud: Equatable {
    var idserv: String
    var servicio: String
    var costo: String
    var requisitos: String
    var duracion_aprox: String
    var descripcion: String
}

func ==(lhs: Solicitud, rhs: Solicitud) -> Bool {
    return lhs.servicio == rhs.servicio
}

