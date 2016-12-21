//
//  Alumno.swift
//  prueba1
//
//  Created by Juan Carlos on 11/25/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

import Foundation

class AlumnoModel: NSObject {
    
    //properties
    
    var nombre: String?
    var ap: String?
    var am: String?
    var nombrec: String?
    var estatus: String?
    var carrera: String?
    var nivel: Int?
    var idc: Int?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(nombre: String, ap: String, am: String, estatus: String, carrera: String, nivel: Int, idc: Int) {
        
        self.nombre = nombre
        self.ap = ap
        self.am = am
        self.nombrec = nombre + ap + am
        self.estatus = estatus
        self.carrera = carrera
        self.nivel = nivel
        self.idc = idc
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Nombre: \(nombre), estatus: \(estatus), carrera: \(carrera), idc: \(idc)"
        
    }
    
    
}
