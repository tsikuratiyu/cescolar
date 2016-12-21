//
//  AlumnoModel.swift
//  prueba1
//
//  Created by Juan Carlos on 11/25/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//
import Foundation

protocol HomeModelProtocal: class {
    func itemsDownloaded(items: NSArray)
}


class HomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: HomeModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    let urlPath: String = "http://cescolar.cucea.udg.mx/servicios/service.php?" //this will be changed to the path where service.php lives
    
    
    func downloadItems() {
        
        
        let url = URL(string: urlPath)
        
        let theRequest = NSMutableURLRequest(url: url! as URL)
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession.shared
        let task = session.dataTask(with: theRequest as URLRequest, completionHandler: {data, response, error -> Void in
           print(data)
            self.parseJSON()
        })
        
        task.resume()
        
    }
    
    
    func parseJSON() {
        
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSMutableArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let datos: NSMutableArray = NSMutableArray()
        var i: Int = 0
        
        for i in 0...jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let alumno = AlumnoModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let nombre = jsonElement["nombre"] as? String,
                let estatus = jsonElement["estatus"] as? String,
                let carrera = jsonElement["carrera"] as? String,
                let idc = jsonElement["idc"] as? String
            {
                
                alumno.nombre = nombre
                alumno.estatus = estatus
                alumno.carrera = carrera
                
                
            }
            
            datos.add(alumno)
        }
    }
}
