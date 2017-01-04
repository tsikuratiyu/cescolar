//
//  SolicitudViewController.swift
//  prueba1
//
//  Created by Juan Carlos on 12/24/16.
//  Copyright © 2016 Juan Carlos. All rights reserved.
//

import UIKit
import Eureka
import PopupDialog
import Alamofire
import EZLoadingActivity

class SolicitudViewController: FormViewController {
    
    var ArrayServicios:Array<String> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let peticion = NSURLRequest(url: NSURL(string: "https://cescolar.cucea.udg.mx/servicios/situacion.php?codigo=216355666")! as URL)
        let carrerasdata = getDataSynchronously(request: peticion)
        let carreras = extraer_json(carrerasdata! as Data)
        var ArrayCarreras:Array<NSDictionary>  = []
        for i in 0..<carreras.count
        {
            if let carrera = carreras[i] as? NSDictionary
            {
                ArrayCarreras.append(carrera)
            }
        }
        //print(carreras.value(forKey: "carrera"))
        //print(ArrayCarreras)
        let sitsection = SelectableSection<ListCheckRow<String>>("carreras", selectionType: .singleSelection(enableDeselection: false))
        sitsection.tag = "carreras"
        form +++ sitsection
        let situaciones = ArrayCarreras
        
        for option in situaciones {
            
            let cve = option.value(forKey: "idc") as? String
            let carrera = option.value(forKey: "carrera") as? String
            form.last! <<< ListCheckRow<String>(cve){ listRow in
                listRow.title = carrera
                listRow.selectableValue = cve
                listRow.value = nil
                }.onChange{listRow in
                    
                    
                    let values = sitsection.selectedRows()
                    for value in values{
                        if (value != nil){
                            
                            //Checa si existe section de situaciones, si existe la elimina y crea una nueva
                            if self.form.sectionBy(tag: "section1") != nil{
                                print("si existe.. eliminando")
                                self.form.remove(at: 1)
                            }
                            let idc: String = value.baseValue! as! String
                            let peticion2 = NSURLRequest(url: NSURL(string: "https://cescolar.cucea.udg.mx/servicios/muestra_servicios.php?codigo=216355666&idc=" + idc)! as! URL)
                            let serviciosdata = getDataSynchronously(request: peticion2)
                            let servicios = extraer_json(serviciosdata! as Data)
                            //print(servicios)
                            var ArrayServicios:Array<String> = []
                            var ArrayServiciosC:Array<NSDictionary> = []
                            for i in 0..<servicios.count
                            {
                                
                                if let servicio = servicios[i] as? NSDictionary
                                {
                                    ArrayServiciosC.append(servicio)
                                    //print(servicio["servicio"])
                                    if let serv = servicio["servicio"] as? String
                                    {
                                        if let costo = servicio["costo"] as? String
                                        {
                                            ArrayServicios.append(serv + " ($ " + costo + ")")
                                        }
                                    }
                                }
                            }
                            
                            
                            var servsection =  SelectableSection<ListCheckRow<String>>("Servicios", selectionType: .multipleSelection)
                            servsection.tag = "section1"
                            servsection.hidden = false
                            self.form +++ servsection
                            let solicitudes = ArrayServiciosC
                            for option in solicitudes {
                                if let servicio = option.value(forKey: "servicio") as? String
                                {
                                    let idserv = option.value(forKey: "idserv") as? String
                                    let costo = option.value(forKey: "costo") as? String
                                    let requisitos = option.value(forKey: "requisitos") as? String
                                    let duracion = option.value(forKey: "duracion_aprox") as? String
                                    
                                    servsection <<< ListCheckRow<String>(idserv){ row in
                                        row.title = servicio
                                        row.selectableValue = idserv
                                        row.hidden = false
                                        }.onChange{row in
                                            //let seleccionado = (row.value ?? false) ? "si" : "no"
                                            if row.value != nil{
                                                let alert = UIAlertController(title: servicio, message: "Costo: $" + costo! + "\n" + "Duracion: " + duracion! + " dias\n" + "Requisitos:" + "\n" + requisitos!, preferredStyle: UIAlertControllerStyle.alert)
                                                alert.addAction(UIAlertAction(title: "Acepto", style: UIAlertActionStyle.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                            }
                                            //let dict = servsection.selectedRows()
                                            //print(dict)
                                            if let aceptarbtn = self.form.rowBy(tag: "aceptar"){
                                                print("si existe.. eliminando")
                                                servsection.removeLast()
                                            }
                                            servsection <<< ButtonRow("aceptar") {
                                                $0.title = "Aceptar"
                                                }
                                                .onCellSelection {  cell, row in
                                                    
                                                    
                                                    let alert = UIAlertController(title: "Acepto los cargos", message: "Se le haran los cargos correspondintes a su estado de cuenta!" , preferredStyle: UIAlertControllerStyle.alert)
                                                    
                                                    
                                                    let aceptar = UIAlertAction(title: "Acepto", style: UIAlertActionStyle.default) {
                                                        UIAlertAction in
                                                        NSLog("OK Pressed")
                                                        let carrera = sitsection.selectedRow()
                                                        let servicios = servsection.selectedRows()
                                                        var arrayserv: [String] = []
                                                        var arrayfirma: [String] = []
                                                        var arraycant: [String] = []
                                                        
                                                        for servicio in servicios{
                                                            arrayserv.append(servicio.baseValue! as! String)
                                                            arraycant.append("1")
                                                            arrayfirma.append("0")
                                                            
                                                        }
                                                        
                                                        let parametros: Parameters = ["codigo": "216355666", "carrera": "178", "com":"Esto es un comentario","firma":arraycant, "opc": arrayserv, "cant": arraycant]
                                                        print(parametros)
                                                        
                                                        Alamofire.request("https://cescolar.cucea.udg.mx/servicios/registraServ.php?", parameters: parametros).responseJSON { response in
                                                            EZLoadingActivity.show("Procesando...", disableUI: true)
                                                            print(response.result)
                                                            
                                                            if let dictionary = response.result.value as? [String: Any] {
                                                                if let error = dictionary["error"] as? String {
                                                                    if error == "no"{
                                                                        EZLoadingActivity.hide()
                                                                        let alert = UIAlertController(title: "Éxito", message: "La solicitud ha sido procesada con folio \(dictionary["folio"] as! String)" , preferredStyle: UIAlertControllerStyle.alert)
                                                                        self.present(alert, animated: true, completion: nil)
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                                                                            self.navigationController?.popViewController(animated: true)
                                                                            alert.dismiss(animated: true, completion: nil)
                                                                        })
                                                                        
                                                                    }else{
                                                                        EZLoadingActivity.hide()
                                                                        let alert = UIAlertController(title: "Error", message: "Error al procesar la solicitu, razon:  \(dictionary["error"]as! String)" , preferredStyle: UIAlertControllerStyle.alert)
                                                                        self.present(alert, animated: true, completion: nil)
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                                                                            self.navigationController?.popViewController(animated: true)
                                                                            alert.dismiss(animated: true, completion: nil)
                                                                        })
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                            
                                                        }
                                                    }
                                                    alert.addAction(aceptar)
                                                    alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
                                                    
                                                    self.present(alert, animated: true, completion: nil)
                                                    
                                                    
                                                }
                                        }
                                    
                                }
                            }
                            
                        }
                        
                        
                    
                    }
                    
                    
                }
        }
        

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
