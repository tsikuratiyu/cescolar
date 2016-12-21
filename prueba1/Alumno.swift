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
    init(jsonStr:String) {
        super.init()
        
        if let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<AnyObject>
                
                /* Loop
                for (key, value) in json {
                    let keyName = key as String
                    let keyValue: String = value as! String
                }
                */
            } catch let error as Error {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        else
        {
            print("json is of wrong format!")
        }
        // Or you can do it with using
        // self.setValuesForKeysWithDictionary(JSONDictionary)
        // instead of loop method above
    }
    //construct with @name, @address, @latitude, and @longitude parameters
    
    /*init(nombre: String, ap: String, am: String, estatus: String, carrera: String, nivel: Int, idc: Int) {
        
        self.nombre = nombre
        self.ap = ap
        self.am = am
        self.nombrec = nombre + ap + am
        self.estatus = estatus
        self.carrera = carrera
        self.nivel = nivel
        self.idc = idc
    }*/
    
    
    //prints object's current state
    
    override var description: String {
        return "Nombre: \(nombre), estatus: \(estatus), carrera: \(carrera), idc: \(idc)"
        
    }
    
    
}
