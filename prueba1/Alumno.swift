//
//  Alumno.swift
//  prueba1
//
//  Created by Juan Carlos on 11/25/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

import Foundation
import Eureka
import JWT


class Alumno {
    
    //properties
    
    let codigo: String
    let nombre: String
    let ap: String
    let am: String
    let nombrec: String
    let estatus: String
    let carrera: String
    let nivel: String
    let idc: String
    let correo: String
    let telefono: String
    let fecha_nac: String
    
    
    

    init?(json: [String: Any]) {
        guard let codigo = json["codigo"] as? String,
            let nombre = json["nombre"] as? String,
            let ap = json["ap"] as? String,
            let am = json["am"] as? String,
            let estatus = json["estatus"] as? String,
            let carrera = json["carrera"] as? String,
            let nivel = json["nivel"] as? String,
            let clave = json["clave"] as? String,
            let correo = json["correo"] as? String,
            let telefono = json["telefono"] as? String,
            let fecha_nac = json["fecha_nac"] as? String
            else {
                return nil
            }
        
        self.codigo = codigo
        self.nombre = nombre
        self.ap = ap
        self.am = am
        self.nombrec = ap + am + nombre
        self.estatus = estatus
        self.carrera = carrera
        self.idc = clave
        self.nivel = nivel
        self.correo = correo
        self.telefono = telefono
        self.fecha_nac = fecha_nac
    }
    
}
